#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"

#define _MENUITEM_                "01046"

/*
Definici¢n de la base de datos de pedidos a proveedores
*/

#define _CSERPED                   1      //   C      1     0
#define _NNUMPED                   2      //   C      9     0
#define _CSUFPED                   3      //   C      2     0
#define _CTURPED                   4      //   C      6     0
#define _DFECPED                   5      //   D      8     0
#define _CCODPRV                   6      //   C      7     0
#define _CCODALM                   7      //   C      4     0
#define _CCODCAJ                   8      //   C      4     0
#define _CNOMPRV                   9      //   C     35     0
#define _CDIRPRV                  10      //   C     35     0
#define _CPOBPRV                  11      //   C     25     0
#define _CPROPRV                  12      //   C     20     0
#define _CPOSPRV                  13      //   C      5     0
#define _CDNIPRV                  14      //   C     15     0
#define _DFECENT                  15      //   D      8     0
#define _NESTADO                  16      //   N      1     0
#define _CSUPED                   17      //   C     10     0
#define _CCODPGO                  18      //   C      2     0
#define _NBULTOS                  19      //   N      3     0
#define _NPORTES                  20      //   N      6     0
#define _CDTOESP                  21      //   N      4     1
#define _NDTOESP                  22      //   N      4     1
#define _CDPP                     23      //   N      4     1
#define _NDPP                     24      //   N      4     1
#define _LRECARGO                 25      //   L      1     0
#define _CCONDENT                 26      //   C     20     0
#define _CEXPED                   27      //   C     20     0
#define _COBSERV                  28      //   M     10     0
#define _CDIVPED                  29      //   C      3     0
#define _NVDVPED                  30      //   C     10     4
#define _LSNDDOC                  31      //   L      1     0
#define _CDTOUNO                  32      //   N      4     1
#define _NDTOUNO                  33      //   N      4     1
#define _CDTODOS                  34      //   N      4     1
#define _NDTODOS                  35      //   N      4     1
#define _LCLOPED                  36      //   L      1     0
#define _CCODUSR                  37      //   C      3     0
#define _CNUMPEDCLI               38      //   C     12     0
#define _LIMPRIMIDO               39      //   L      1     0
#define _DFECIMP                  40      //   D      8     0
#define _CHORIMP                  41      //   C      5     0
#define _DFECCHG                  42
#define _CTIMCHG                  43
#define _CCODDLG                  44
#define _CSITUAC                  45
#define _NREGIVA                  46
#define _NTOTNET                  47
#define _NTOTIVA                  48
#define _NTOTREQ                  49
#define _NTOTPED                  50
#define _CNUMALB                  51
#define _LRECC                    52
#define _CCENTROCOSTE             53 

/* Definici¢n de la base de datos de lineas de detalle */

#define _CREF                      4      //   C     18     0
#define _CREFPRV                   5      //   C     20     0
#define _CDETALLE                  6      //   C     50     0
#define _NIVA                      7      //   N      6     2
#define _NCANPED                   8      //   N     13     3
#define _NUNICAJA                  9      //   N     13     3
#define _NPREDIV                  10      //   N     13     3
#define _NCANENT                  11      //   N     13     3
#define _NUNIENT                  12      //   N     13     3
#define _CUNIDAD                  13      //   C      2     0
#define _MLNGDES                  14      //   M     10     0
#define _NDTOLIN                  15      //   N      5     2
#define _NDTOPRM                  16
#define _NDTORAP                  17
#define _CCODPR1                  18      //   C      5     0
#define _CCODPR2                  19      //   C      5     0
#define _CVALPR1                  20      //   C      5     0
#define _CVALPR2                  21      //   C      5     0
#define _NFACCNV                  22      //   N     13     4
#define _NCTLSTK                  23
#define _CALMLIN                  24      //   C     3      0
#define _LLOTE                    25      //   N     4      0
#define _NLOTE                    26      //   N     4      0
#define _CLOTE                    27      //   N     4      0
#define _NNUMLIN                  28
#define _NUNDKIT                  29
#define _LKITART                  30
#define _LKITCHL                  31
#define _LKITPRC                  32      //   L     4      0
#define _LIMPLIN                  33      //   L     4      0
#define _LCONTROL                 34
#define _MNUMSER                  35
#define _LANULADO                 36
#define _DANULADO                 37
#define _MANULADO                 38
#define _CCODFAM                  39      //   C     8      0
#define _CGRPFAM                  40      //   C     3      0
#define _NREQ                     41      //   C    16      6
#define _MOBSLIN                  42      //   M    10      0
#define _CPEDCLI                  43      //   C    12      0
#define _NPVPREC                  44
#define _NNUMMED                  45
#define _NMEDUNO                  46
#define _NMEDDOS                  47
#define _NMEDTRE                  48
#define _NSTKACT                  49  
#define _NSTKMIN                  50  
#define _NPDTREC                  51   
#define _NCONREA                  52  
#define _NCONSEM                  53  
#define _NCONQUI                  54  
#define _NCONMES                  55  
#define _aNESTADO                 56  
#define _LFROMIMP                 57
#define __NBULTOS                 58
#define _CFORMATO                 59
#define _CCODIMP                  60  
#define _NVALIMP                  61
#define _LLABEL                   62
#define _NLABEL                   63
#define _CREFAUX                  64
#define _CREFAUX2                 65
#define _NPOSPRINT                66
#define __CCENTROCOSTE            67  
#define _CTIPCTR                  68
#define _CTERCTR                  69

memvar cDbf
memvar cDbfCol
memvar cDbfPrv
memvar cDbfPgo
memvar cDbfIva
memvar cDbfAlm
memvar cDbfDiv
memvar cDbfArt
memvar cDbfKit
memvar cDbfPro
memvar cDbfUsr
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
memvar nTotReq
memvar nTotIvm
memvar nTotPed
memvar nTotImp
memvar nTotUno
memvar nTotDos

memvar cPicUndPed
memvar cPinDivPed
memvar cPirDivPed
memvar nDinDivPed
memvar nDirDivPed
memvar nVdvDivPed
memvar nPagina
memvar lEnd

static oWndBrw
static oBrwIva
static dbfPedPrvT
static dbfPedPrvL
static dbfPedPrvI
static dbfPedPrvD
static dbfPedPrvS
static dbfAlbPrvT
static dbfPedCliT
static dbfPrv
static dbfIva
static dbfTmp
static dbfDiv
static dbfArticulo
static dbfTmpInc
static dbfTmpDoc
static dbfTmpArt
static dbfTmpLin
static dbfTmpSer
static cTmpArt
static cTmpSer
static cTmpPed
static tmpPedidosIncidencias
static tmpPedidosLineas
static tmpPedidosDocumentos
static dbfFamilia
static dbfArtPrv

static oMailing

static dbfClient
static oGetNet
static oGetIva
static oGetIvm
static oGetReq
static oGetTotal
static oUsr
static cUsr
static cPirDiv
static cPinDiv
static cPicUnd
static nDinDiv
static nDirDiv
static nGetNeto         := 0
static nGetIva          := 0
static nGetReq          := 0
static nVdvDiv          := 1
static oFont
static oMenu
static oDetMenu
static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static cFiltroUsuario   := ""
static bEdtRec          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtDet          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aPedPrv | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aPedPrv ) }
static bEdtInc          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }

static nView

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste   := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

//----------------------------------------------------------------------------//

static Function initPublics()

   public nTotPed    := 0
   public nTotBrt    := 0
   public nTotDto    := 0
   public nTotDPP    := 0
   public nTotNet    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotImp    := 0
   public nTotIvm    := 0
   public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]
   public nTotUno    := 0
   public nTotDos    := 0

Return ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock
   local oError

   if lOpenFiles
      MsgStop( 'Ficheros de pedidos a proveedores abiertos previamente' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      nView             := D():CreateView()

      D():PedidosProveedores( nView )

      D():Proveedores( nView )

      D():GruposProveedores( nView )

      D():Clientes( nView )

      D():PedidosProveedoresLineas( nView )

      D():PedidosProveedoresIncidencias( nView )

      D():PedidosProveedoresDocumentos( nView )

      D():AlbaranesProveedores( nView )

      D():AlbaranesProveedoresLineas( nView )

      D():TiposIva( nView )

      D():FormasPago( nView )

      D():Divisas( nView )

      D():ProveedorArticulo( nView )
      ( D():ProveedorArticulo( nView ) )->( ordSetFocus( "cCodPrv" ) )

      D():ArticuloPrecioPropiedades( nView )

      D():Articulos( nView )

      D():ArticulosCodigosBarras( nView )

      D():ArticuloLenguaje( nView )

      D():Familias( nView )

      D():Almacen( nView )

      D():Kit( nView )

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( ordSetFocus( "cTipo" ) )

      D():Cajas( nView )

      D():Usuarios( nView )

      D():PedidosClientesReservas( nView )

      D():Propiedades( nView )

      D():PropiedadesLineas( nView )

      D():Delegaciones( nView )

      D():Contadores( nView )

      D():Empresa( nView )

      D():UnidadMedicion( nView )

      D():ImpuestosEspeciales( nView )
      
      D():CamposExtraHeader( nView ):setTipoDocumento( "Pedidos a proveedores" )
      D():CamposExtraHeader( nView ):setbId( {|| D():PedidosProveedoresId( nView ) } )

      D():CamposExtraLine( nView ):setTipoDocumento( "Lineas pedidos a proveedores" )
      D():CamposExtraLine( nView ):setbId( {|| D():PedidosProveedoresLineasId( nView ) } )

      D():CentroCoste( nView )

      D():Stocks( nView )

      D():objectCodigosPostales( nView )

      D():Banderas( nView )

      /*
      Recursos y fuente--------------------------------------------------------
      */

      oMailing          := TGenmailingDatabasePedidosProveedor():New( nView )

      oFont             := TFont():New( "Arial", 8, 26, .F., .T. )

      initPublics()

   RECOVER USING oError

      lOpenFiles        := .f.

      MsgStop( ErrorMessage( oError ), "Imposible abrir ficheros de pedidos a proveedores" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   EnableAcceso()

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( D():PedidosProveedores( nView ), .t., .t. )

   if !empty( oFont )
      oFont:end()
   end if

   D():DeleteView( nView )

   lOpenFiles           := .f.

   oWndBrw              := nil

   EnableAcceso()

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION PedPrv( oMenuItem, oWnd, cCodPrv, cCodArt )

   local oPrv
   local oImp
   local oSnd
   local oDel
   local oRpl
   local oPdf
   local oMail
   local oRotor
   local oScript
   local oBtnEur
   local nLevel
   local LabelGeneratorPedidoProveedores
   local lEuro          := .f.

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodPrv      := ""
   DEFAULT cCodArt      := ""

   /*
   Obtenemos el nivel de acceso------------------------------------------------
   */

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
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

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Pedidos a proveedores" ;
      PROMPT   "Número",;
               "Fecha",;
               "Entrada",;
               "Código",;
               "Nombre proveedor";
      MRU      "gc_clipboard_empty_businessman_16";
      BITMAP   Rgb( 0, 114, 198 ) ;
      ALIAS    ( D():PedidosProveedores( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():PedidosProveedores( nView ), cCodPrv, cCodArt ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():PedidosProveedores( nView ), cCodPrv, cCodArt ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():PedidosProveedores( nView ), cCodPrv, cCodArt ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():PedidosProveedores( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():PedidosProveedores( nView ), {|| QuiPedPrv() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	oWndBrw:lFechado     := .t.
      oWndBrw:bChgIndex    := {|| if( oUser():lFiltroVentas(), CreateFastFilter( cFiltroUsuario, D():PedidosProveedores( nView ), .f., , cFiltroUsuario ), CreateFastFilter( "", D():PedidosProveedores( nView ), .f. ) ) }
	oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->lCloPed }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_lock2_12", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| Max( ( D():PedidosProveedores( nView ) )->nEstado, 1 ) }
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
         :bBmpData         := {|| nEstadoIncidencia( ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed ) }
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
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_printer2_12", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cSerPed + "/" + Alltrim( Str( ( D():PedidosProveedores( nView ) )->nNumPed ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cSufPed }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():PedidosProveedores( nView ) )->cTurPed, "######" ) }
         :nWidth           := 60
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesPed"
         :bEditValue       := {|| Dtoc( ( D():PedidosProveedores( nView ) )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entrada"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( D():PedidosProveedores( nView ) )->dFecEnt ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situación"
         :cSortOrder       := "cSituac"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cSituac }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cCodPrv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre proveedor"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->cNomPrv }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| alltrim( ( D():PedidosProveedores( nView ) )->cPosPrv ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| alltrim( ( D():PedidosProveedores( nView ) )->cPobPrv ) }
         :nWidth           := 180
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| alltrim( ( D():PedidosProveedores( nView ) )->cProPrv ) }
         :nWidth           := 180
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->nTotNet }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->nTotIva }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->nTotReq }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():PedidosProveedores( nView ) )->nTotPed }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():PedidosProveedores( nView ) )->cDivPed ), D():Divisas( nView ) ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| if( !empty( ( D():PedidosProveedores( nView ) )->cNumPedCli ), AllTrim( GetCodCli( ( D():PedidosProveedores( nView ) )->cNumPedCli ) ) + " - " + AllTrim( GetNomCli( ( D():PedidosProveedores( nView ) )->cNumPedCli ) ), "" ) }
         :nWidth           := 280
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Creación/Modificación"
         :bEditValue       := {|| dtoc( ( D():PedidosProveedores( nView ) )->dFecChg ) + space( 1 ) + ( D():PedidosProveedores( nView ) )->cTimChg }
         :nWidth           := 120
         :lHide            := .t.
      end with

      D():CamposExtraHeader( nView ):addCamposExtra( oWndBrw )

      oWndBrw:cHtmlHelp    := "Pedido a proveedor"

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
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oPrv RESOURCE "GC_PRINTER2_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenPedPrv( IS_PRINTER ) ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oPrv, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesPedidosProveedores() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oImp RESOURCE "GC_MONITOR_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenPedPrv( IS_SCREEN ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oImp, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedPrv( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TLabelGeneratorPedidoProveedores():New( nView ):Dialog() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "ChgState" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChgState( oWndBrw:oBrw ) ) ;
         TOOLTIP  "Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar pedidos para ser enviados" ;
      ACTION   lSnd( oWndBrw, D():PedidosProveedores( nView ) ) ;
      HOTKEY   "V";
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
         ACTION   ( ReplaceCreator( oWndBrw, D():PedidosProveedores( nView ), aItmPedPrv() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ReplaceCreator( oWndBrw, D():PedidosProveedoresLineas( nView ), aColPedPrv() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "GC_SHOPPING_CART_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( Generador( oWndBrw:oBrw ) ) ;
      TOOLTIP  "(G)enerar" ;
      HOTKEY   "G";

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( PED_PRV, ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "gc_document_text_pencil_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TCounter():New( nView, "nPedPrv" ):OpenDialog() ) ;
      TOOLTIP  "Establecer contadores"

   DEFINE BTNSHELL oScript RESOURCE "gc_folder_document_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( oWndBrw, oScript, "PedidosProveedores", nView )

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( EdtPrv( ( D():PedidosProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfProveedor( ( D():PedidosProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Informe proveedor" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( ( D():PedidosProveedores( nView ) )->nEstado == 3, MsgStop( "Pedido recibido" ), AlbPrv( nil, oWnd, nil, nil, ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed ) ) );
         TOOLTIP  "Generar albarán" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
         ACTION   ( Ped2Alb( ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed ) );
         TOOLTIP  "Modificar albarán" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmPedPrv() )
      oWndBrw:oActiveFilter:SetFilterType( PED_PRV )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( cCodPrv ) .or. !empty( cCodArt )
         oWndBrw:recAdd()
      end if

      cCodPrv  := nil
      cCodArt  := nil

   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, cCodPrv, cCodArt, nMode )

   local oDlg
   local oFld
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oSay                 := Array( 5 )
   local cSay                 := Array( 5 )
   local oSayLabels           := Array( 7 )
   local oBtnAtp
   local oBmpDiv
   local oBmpEmp
   local cEstPed
   local oGetMasDiv
   local cGetMasDiv           := ""
   local cTlfPrv
   local oTlfPrv
   local oPedCli
   local oCodCli
   local oNomCli
   local cCodCli              := GetCodCli( aTmp[ _CNUMPEDCLI ] )
   local cNomCli              := GetNomCli( aTmp[ _CNUMPEDCLI ] )
   local oBmpGeneral
   local oBmpDatos
   local oBmpIncidencias
   local oBmpDocumentos

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli                 := aTmp[ _CCODPRV ]
   cPicUnd                    := MasUnd()                               // Picture de las unidades

   do case
   case nMode == APPD_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CSERPED ]        := cNewSer( "nPedPrv" )
      aTmp[ _CTURPED ]        := cCurSesion()
      aTmp[ _CCODCAJ ]        := oUser():cCaja()
      aTmp[ _CCODALM ]        := oUser():cAlmacen()
      aTmp[ _CDIVPED ]        := cDivEmp()
      aTmp[ _NVDVPED ]        := nChgDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) )
      aTmp[ _CSUFPED ]        := RetSufEmp()
      aTmp[ _LSNDDOC ]        := .t.
      aTmp[ _NESTADO ]        := 1
      aTmp[ _CCODUSR ]        := cCurUsr()
      aTmp[ _CCODDLG ]        := oUser():cDelegacion()
      if !empty( cCodPrv )
         aTmp[ _CCODPRV ]     := cCodPrv
      end if

   case nMode == DUPL_MODE
   
      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURPED ]        := cCurSesion()
      aTmp[ _CCODCAJ ]        := oUser():cCaja()
      aTmp[ _LSNDDOC ]        := .t.
      aTmp[ _LCLOPED ]        := .f.
      aTmp[ _NESTADO ]        := 1

   case nMode == EDIT_MODE

      if aTmp[ _NESTADO ] == 3
         msgStop( "El pedido ya fue recibido." )
         Return .f.
      end if

      if aTmp[ _LCLOPED ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar los pedidos cerrados los administradores." )
         Return .f.
      end if

   end case

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   if aTmp[ _NESTADO ] == 0
      aTmp[ _NESTADO ]  := 1
   end if

   do case
   case  aTmp[ _NESTADO ] == 1
      cEstPed           := "Pendiente"
   case  aTmp[ _NESTADO ] == 2
      cEstPed           := "Parcial"
   case  aTmp[ _NESTADO ] == 3
      cEstPed           := "Recibido"
   end case

   if empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if empty( aTmp[ _CDPP ] ) 
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 1 ]            := RetFld( aTmp[ _CCODALM ], D():Almacen( nView ) )
   cSay[ 2 ]            := RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ) )
   cSay[ 3 ]            := RetFld( aTmp[ _CCODCAJ ], D():Cajas( nView ) )
   cSay[ 4 ]            := RetFld( aTmp[ _CCODPRV ], D():Proveedores( nView ) )
   cTlfPrv              := RetFld( aTmp[ _CCODPRV ], D():Proveedores( nView ), "Telefono" )
   cUsr                 := RetFld( aTmp[ _CCODUSR ], D():Usuarios( nView ), "cNbrUse" )
   cSay[ 5 ]            := RetFld( cCodEmp() + aTmp[ _CCODDLG ], D():Delegaciones( nView ), "cNomDlg" )

   DEFINE DIALOG oDlg RESOURCE "PEDPRV" TITLE LblTitle( nMode ) + "pedidos a proveedores"

	REDEFINE FOLDER oFld ;
         ID          400 ; 
         OF          oDlg ;
         PROMPT      "&Pedido",;
                     "Da&tos",;
                     "I&ncidencias",;
                     "D&ocumentos" ;
         DIALOGS     "PEDPRV_1",;
                     "PEDPRV_2",;
                     "PEDCLI_3",;
                     "PEDCLI_4"

      // cuadro del usuario

      REDEFINE GET   aGet[ _CCODUSR ] ;
         VAR         aTmp[ _CCODUSR ];
         ID          215 ;
         WHEN        ( .f. ) ;
         VALID       ( SetUsuario( aGet[ _CCODUSR ], oUsr, nil, D():Usuarios( nView ) ) );
         OF          oFld:aDialogs[2]

      REDEFINE GET   oUsr ;
         VAR         cUsr ;
         ID          216 ;
         WHEN        ( .f. ) ; 
         OF          oFld:aDialogs[2] 

      // Datos del proveedor_________________________________________________

      REDEFINE BITMAP oBmpGeneral ;
         ID          990 ;
         RESOURCE    "gc_clipboard_empty_businessman_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[1]

      REDEFINE BITMAP oBmpDatos ;
        ID       990 ;
        RESOURCE "gc_folders2_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      REDEFINE BITMAP oBmpIncidencias ;
        ID       990 ;
        RESOURCE "gc_information_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[3]

      REDEFINE BITMAP oBmpDocumentos ;
        ID       990 ;
        RESOURCE "gc_address_book_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[4]

      REDEFINE GET   aGet[ _CCODPRV ] ;
         VAR         aTmp[ _CCODPRV ] ;
         ID          140 ;
         PICTURE     ( RetPicCodPrvEmp() ) ;
         WHEN 	      ( nMode != ZOOM_MODE ) ;
         VALID       ( LoaPrv( aGet, aTmp, D():Proveedores( nView ), nMode, oSay[ 4 ], oTlfPrv ) ) ;
         ON HELP     ( BrwProvee( aGet[ _CCODPRV ], oSay[ 4 ] ) ) ;
         BITMAP      "LUPA" ;
         OF          oFld:aDialogs[1]

      // aGet[ _CCODPRV ]:bPreValidate    := {|| msginfo( oSender:ClassName() ) }
      // aGet[ _CCODPRV ]:bPostValidate   := {|| msginfo( 'bPostValidate' ) }

      REDEFINE GET aGet[ _CNOMPRV ] VAR aTmp[ _CNOMPRV ];
         ID 		141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CDNIPRV] VAR aTmp[_CDNIPRV] ;
         ID       145 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTlfPrv VAR cTlfPrv ;
         ID       146 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRPRV ] VAR aTmp[ _CDIRPRV ] ;
         ID       142 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRPRV ], Rtrim( aTmp[ _CPOBPRV ] ) + Space( 1 ) + Rtrim( aTmp[ _CPROPRV ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSPRV ] VAR aTmp[ _CPOSPRV ] ;
         ID       143 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( D():objectCodigosPostales( nView ):validCodigoPostal() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBPRV ] VAR aTmp[ _CPOBPRV ] ;
         ID       144 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPROPRV ] VAR aTmp[ _CPROPRV ] ;
         ID       147 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ]	;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 1 ] ) ) ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 1 ] ) ) ;
         BITMAP   "Lupa" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 1 ] VAR cSay[ 1 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			ID 		151 ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
			OF 		oFld:aDialogs[1] ;

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ];
			ID 		160 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cFPago( aGet[ _CCODPGO ], D():FormasPago( nView ), oSay[ 2 ] ) ;
         ON HELP  brwFPago( aGet[ _CCODPGO ], oSay[ 2 ]) ;
         BITMAP   "Lupa" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ];
			ID 		161 ;
         WHEN     .f. ;
			OF 		oFld:aDialogs[1]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], D():Cajas( nView ), oSay[ 3 ] ) ;
         ID       165 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 3 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         ID       166 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

		/*
		Moneda__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVPED ] VAR aTmp[ _CDIVPED ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivIn( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], @cPinDiv, @nDinDiv, @cPirDiv, @nDirDiv, oGetMasDiv, D():Divisas( nView ), D():Banderas( nView ) ) );
			PICTURE	"@!";
			ID 		170 ;
         ON HELP  BrwDiv( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], D():Divisas( nView ), D():Banderas( nView ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NVDVPED ] VAR aTmp[ _NVDVPED ];
			WHEN 		( .F. ) ;
			ID 		180 ;
			PICTURE	"@E 999,999.9999" ;
			OF 		oFld:aDialogs[1]

		/*
		Bitmap________________________________________________________________
		*/

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgPedPrv.bmp" ;
         ID       500 ;
         OF       oDlg ;

      /*
      Precios de compra por propiedades----------------------------------------
      */

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter         := .t.
      oBrwLin:cName           := "Lineas de pedidos a proveedor"

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Número"
            :cSortOrder       := "nNumLin"
            :bEditValue       := {|| if( ( dbfTmpLin )->lKitChl, "", Trans( ( dbfTmpLin )->nNumLin, "9999" ) ) }
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
            :nWidth           := 65
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Posición"
            :cSortOrder       := "nPosPrint"
            :bEditValue       := {|| ( dbfTmpLin )->nPosPrint }
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
            :cEditPicture     := "9999"
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with 

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Es. Estado"
            :bStrData         := {|| "" }
            :bBmpData         := {|| nTotRecibido( dbfTmpLin, D():AlbaranesProveedoresLineas( nView ) ) }
            :nWidth           := 20
            :AddResource( "gc_delete_12" )
            :AddResource( "gc_shape_square_12" )
            :AddResource( "gc_check_12" )
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código"
            :cSortOrder       := "cRef"
            :bEditValue       := {|| ( dbfTmpLin )->cRef }
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
            :nWidth           := 80
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "C. Barras"
            :bEditValue       := {|| cCodigoBarrasDefecto( ( dbfTmpLin )->cRef, D():ArticulosCodigosBarras( nView ) ) }
            :nWidth           := 100
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código proveedor"
            :cSortOrder       := "cRefPrv"
            :bEditValue       := {|| ( dbfTmpLin )->cRefPrv }
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Descripción"
            :cSortOrder       := "cDetalle"
            :bEditValue       := {|| if( empty( ( dbfTmpLin )->cRef ), ( dbfTmpLin )->mLngDes, ( dbfTmpLin )->cDetalle ) }
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
            :nWidth           := 280
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 1"
            :bEditValue       := {|| ( dbfTmpLin )->cValPr1 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Valor prop. 1"
            :bEditValue       := {|| nombrePropiedad( ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cValPr1, nView ) }
            :nWidth           := 40
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 2"
            :bEditValue       := {|| ( dbfTmpLin )->cValPr2 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Valor prop. 2"
            :bEditValue       := {|| nombrePropiedad( ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr2, nView ) }
            :nWidth           := 40
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Lote"
            :bEditValue       := {|| ( dbfTmpLin )->cLote }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Bultos"
            :bEditValue       := {|| ( dbfTmpLin )->nBultos }
            :cEditPicture     := MasUnd()
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreCajas()
            :bEditValue       := {|| ( dbfTmpLin )->nCanPed }
            :cEditPicture     := MasUnd()
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreUnidades()
            :cSortOrder       := "nUniCaja"
            :bEditValue       := {|| ( dbfTmpLin )->nUniCaja }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
            :nEditType        := 1
            :nFooterType      := AGGR_SUM
            :bOnPostEdit      := {|o,x,n| ChangeUnidades( o, x, n, aTmp ) }
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
         end with
   
         with object ( oBrwLin:AddCol() )
            :cHeader          := "Sumar unidades"
            :bStrData         := {|| "" }
            :bOnPostEdit      := {|| .t. }
            :bEditBlock       := {|| SumaUnidadLinea( aTmp ) }
            :nEditType        := 5
            :nWidth           := 20
            :nHeadBmpNo       := 1
            :nBtnBmp          := 1
            :nHeadBmpAlign    := 1
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
            :cHeader          := "Total " + cNombreUnidades()
            :bEditValue       := {|| nTotNPedPrv( dbfTmpLin ) }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "UM. Unidad de medición"
            :bEditValue       := {|| ( dbfTmpLin )->cUnidad }
            :nWidth           := 25
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Almacen"
            :bEditValue       := {|| ( dbfTmpLin )->cAlmLin }
            :nWidth           := 60
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotUPedPrv( dbfTmpLin, nDinDiv ) }
            :cEditPicture     := cPinDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% Dto."
            :bEditValue       := {|| ( dbfTmpLin )->nDtoLin }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% Prm."
            :bEditValue       := {|| ( dbfTmpLin )->nDtoPrm }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 40
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Stock actual"
            :bEditValue       := {|| ( dbfTmpLin )->nStkAct }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Pendiente recibir"
            :bEditValue       := {|| ( dbfTmpLin )->nPdtRec }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Stock mínimo"
            :bEditValue       := {|| ( dbfTmpLin )->nStkMin }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Consumo"
            :bEditValue       := {|| ( dbfTmpLin )->nConRea }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "7 dias"
            :bEditValue       := {|| ( dbfTmpLin )->nConSem }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "15 dias"
            :bEditValue       := {|| ( dbfTmpLin )->nConQui }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "30 dias"
            :bEditValue       := {|| ( dbfTmpLin )->nConMes }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with


         with object ( oBrwLin:AddCol() )
            :cHeader          := "% " + cImp()
            :bEditValue       := {|| ( dbfTmpLin )->nIva }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Total"
            :bEditValue       := {|| nTotLPedPrv( dbfTmpLin, nDinDiv, nDirDiv ) }
            :cEditPicture     := cPirDiv
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Comentario"
            :bEditValue       := {|| Padr( RetFld( ( dbfTmpLin )->cRef, D():Articulos( nView ), "mComent" ), 100 ) }
            :nWidth           := 180
            :lHide            := .t.
            :nEditType        := 1
            :cEditPicture     := "@S180"
            :bOnPostEdit      := {|o,x,n| ChangeComentario( o, x, n, aTmp ) }
         end with

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
         end if

         oBrwLin:CreateFromResource( 190 )

      REDEFINE BUTTON ;
            ID          500 ;
            OF          oFld:aDialogs[1] ;
            WHEN        ( nMode != ZOOM_MODE ) ;
            ACTION      ( AppDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
            ID          501 ;
            OF          oFld:aDialogs[1] ;
            WHEN 	      ( nMode != ZOOM_MODE ) ;
            ACTION      ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

      REDEFINE BUTTON ;
            ID          502 ;
            OF          oFld:aDialogs[1] ;
            WHEN        ( nMode != ZOOM_MODE ) ;
            ACTION      ( WinDelRec( oBrwLin, dbfTmpLin, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION      ( EdtZoom( oBrwLin, bEdtDet, aTmp ) )

      REDEFINE BUTTON ;
   	   ID 	524 ;
   	   OF 	oFld:aDialogs[1] ;
   	   WHEN 	( nMode != ZOOM_MODE ) ;
         ACTION   ( LineUp( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON ;
         ID 	525 ;
         OF 	oFld:aDialogs[1] ;
         WHEN 	( nMode != ZOOM_MODE ) ;
         ACTION   ( LineDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnAtp;
         ID       526 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ImportaComprasProveedor( aTmp, oBrwLin, oDlg ) )

   /*
	Descuentos______________________________________________________________
	*/

   REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
      ID          199 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      ON CHANGE   ( RecalculaTotal( aTmp ) );
      OF 		oFld:aDialogs[1]

	REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
      ID 		200 ;
      WHEN 		( nMode != ZOOM_MODE ) ;
      PICTURE     "@E 999.99" ;
      SPINNER ;
      ON CHANGE   ( RecalculaTotal( aTmp ) );
      OF 		oFld:aDialogs[1]

   REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
      ID          209 ;
      WHEN 		( nMode != ZOOM_MODE ) ;
      ON CHANGE   ( RecalculaTotal( aTmp ) );
		OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
			ID 		240 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

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
         :nWidth        := 106
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 2 ] )
         :cHeader       := "Base"
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 2 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 106
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 3 ] )
         :cHeader       := "%" + cImp()
         :bStrData      := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue    := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth        := 55
         :cEditPicture  := "@E 999.99"
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :nEditType     := 1
         :bEditWhen     := {|| !isNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit   := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, D():TiposIva( nView ), oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:aCols[ 4 ] )
         :cHeader       := "%R.E."
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 4 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9" ), "" ) }
         :nWidth        := 55
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
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetIvm VAR nTotIvm;
         ID       403 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
			ID 		400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotPed ;
			ID 		410 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       420 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSERPED ] VAR aTmp[ _CSERPED ] ;
         ID       690 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[_CSERPED] ) );
         ON DOWN  ( DwSerie( aGet[_CSERPED] ) );
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

		REDEFINE GET aGet[_DFECPED] VAR aTmp[_DFECPED];
			ID 		110 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NESTADO] VAR cEstPed;
         WHEN     .f. ;
         ID       120 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ] ;
         ID       125 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         SPINNER ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] VAR aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( nMode != ZOOM_MODE );
         ITEMS    ( SituacionesModel():arraySituaciones() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE RADIO aGet[ _NREGIVA ] VAR aTmp[ _NREGIVA ] ;
         ID       270, 271, 272, 273 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ] ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         SPINNER ;
         PICTURE  "@E 999,999" ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      //Segunda caja de dialogo

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       510 ;
         IDTEXT   511 ;
         BITMAP   "LUPA" ;
         VALID    ( D():CentroCoste( nView ):Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( D():CentroCoste( nView ):Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CSUPED] VAR aTmp[_CSUPED] ;
         ID       235 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 701 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 702 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 706 OF oFld:aDialogs[ 1 ]

      /*
      Datos del envio----------------------------------------------------------
      */

      REDEFINE GET aGet[_CEXPED] VAR aTmp[_CEXPED];
         ID       180 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      /*
      Observaciones------------------------------------------------------------
      */

      REDEFINE GET aGet[_COBSERV] VAR aTmp[_COBSERV];
			ID 		200 ;
         MEMO ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET oPedCli VAR aTmp[_CNUMPEDCLI] ;
         ID       230 ;
         WHEN     ( .f. ) ;
         PICTURE  "@R #/#########/##" ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oCodCli VAR cCodCli ;
         ID       210 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oNomCli VAR cNomCli ;
         ID       220 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

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
      Caja de diálogos de incidencias------------------------------------------
      */

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 5
      oBrwInc:cName           := "Incidencias de pedidos a proveedor"

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
            :nWidth           := 390
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
         ACTION   ( ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) )

		/*
      Botones comunes a la caja de dialogo_____________________________________
		*/

     REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecalculaPedidoProveedores( aTmp, oDlg ), ( oBrwLin:Refresh() ), RecalculaTotal( aTmp ) )

     REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aGet, aTmp, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       3 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aGet, aTmp, oBrw, nMode, oDlg ), GenPedPrv( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmpLin ), ( oDlg:end() ), ) )

      D():objectCodigosPostales( nView ):setBinding( { "CodigoPostal" => aGet[ _CPOSPRV ], "Poblacion" => aGet[ _CPOBPRV ], "Provincia" => aGet[ _CPROPRV ] } )

      if nMode != ZOOM_MODE
         oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp ) } )
         oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
         oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmpLin, {|| DelDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

         oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

         oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) } )

         oDlg:AddFastKey( VK_F5, {|| EndTrans( aGet, aTmp, oBrw, nMode, oDlg ) } )
         oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aGet, aTmp, oBrw, nMode, oDlg ), GenPedPrv( IS_PRINTER ), ) } )
         oDlg:AddFastKey( VK_F9, {|| D():CamposExtraHeader( nView ):Play( space(1) ) } )
         oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

      do case
         case nMode == APPD_MODE .and. lRecogerUsuario() .and. empty( cCodArt )
            oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], D():Usuarios( nView ) ), , oDlg:end() ), StartEdtRec( aGet ) }

         case nMode == APPD_MODE .and. lRecogerUsuario() .and. !empty( cCodArt )
            oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], D():Usuarios( nView ) ), AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), oDlg:end() ), StartEdtRec( aGet ) }

         case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !empty( cCodArt )
            oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), StartEdtRec( aGet ) }
         otherwise
            oDlg:bStart := {|| StartEdtRec( aGet ) }
      end case

	ACTIVATE DIALOG oDlg	;
      ON INIT  (  initEdtRec( aGet, aTmp, oBrw, oBrwLin, oBrwInc, nMode, cCodPrv, oDlg ) ) ;
      ON PAINT (  recalculaTotal( aTmp ) );
      CENTER

   killTrans( oBrwLin )

   endEdtRecMenu()

   oBmpDiv:end()
   oBmpEmp:end()
   oBmpGeneral:end()
   oBmpIncidencias:end()
   oBmpDatos:end()
   oBmpDocumentos:end()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static function StartEdtRec( aGet )

   if !empty( aGet[ _CCENTROCOSTE ] )
      aGet[ _CCENTROCOSTE ]:lValid()
   endif

return .t.

//---------------------------------------------------------------------------//

static Function initEdtRec( aGet, aTmp, oBrw, oBrwLin, oBrwInc, nMode, cCodPrv, oDlg )

   edtRecMenu( aGet, aTmp, oBrw, oBrwLin, nMode, oDlg )

   showKitCom( D():PedidosProveedores( nView ), dbfTmpLin, oBrwLin, cCodPrv, dbfTmpInc, aGet )
   
   oBrwLin:Load()
   oBrwLin:MakeTotals()
   oBrwLin:RefreshFooters()

   oBrwInc:Load()

RETURN ( .t. )

//--------------------------------------------------------------------------//

Static Function EdtRecMenu( aGet, aTmp, oBrw, oBrwLin, nMode, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( D():CamposExtraHeader( nView ):Play( space(1) ) )

            MENUITEM    "&2. Modificar proveedor";
               MESSAGE  "Modificar la ficha del proveedor" ;
               RESOURCE "gc_businessmen2_16";
               ACTION   ( EdtPrv( aTmp[ _CCODPRV ] ) )

            MENUITEM    "&3. Informe de proveedor";
               MESSAGE  "Abrir el informe del proveedor" ;
               RESOURCE "Info16";
               ACTION   ( InfProveedor( aTmp[ _CCODPRV ] ) );

            SEPARATOR

            end if

            MENUITEM    "&4. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16";
               ACTION   ( TTrazaDocumento():Activate( PED_PRV, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] ) )



         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//----------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return ( if( oMenu != nil, oMenu:End(), ) )

//---------------------------------------------------------------------------//

Static Function RecalculaPedidoProveedores( aTmp, oDlg )

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

   nRecNum                          := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      nPreCom                       := nComPro( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr2, D():ArticuloPrecioPropiedades( nView ) )

      if nPrecom  != 0

         ( dbfTmpLin )->nPreDiv     := nPreCom

      else

         if uFieldEmpresa( "lCosPrv", .f. )
            nPreCom                 := nPrecioReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, D():ProveedorArticulo( nView ) )
         end if

         if nPreCom != 0
            ( dbfTmpLin )->nPreDiv  := nPreCom
         else
            ( dbfTmpLin )->nPreDiv  := nCosto( ( dbfTmpLin )->cRef, D():Articulos( nView ), D():Kit( nView ), .f., aTmp[ _CDIVPED ], D():Divisas( nView ) )
         end if

         /*
         Descuento de articulo----------------------------------------------
         */

         if uFieldEmpresa( "lCosPrv", .f. )

            nPreCom                    := nDescuentoReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, D():ProveedorArticulo( nView ) )

            if nPreCom != 0
               ( dbfTmpLin )->nDtoLin  := nPreCom
            end if

         /*
         Descuento de promocional----------------------------------------------
         */

            nPreCom                    := nPromocionReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, D():ProveedorArticulo( nView ) )

            if nPreCom != 0
               ( dbfTmpLin )->nDtoPrm  := nPreCom
            end if

         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecNum ) )

   oDlg:Enable()

Return nil

//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de pedido a proveedor"

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

//----------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERPED  ] := aTmpLin[ _CSERPED ]
      aTmp[ _NNUMPED  ] := aTmpLin[ _NNUMPED ]
      aTmp[ _CSUFPED  ] := aTmpLin[ _CSUFPED ]
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de pedido a proveedor"

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

/*
Funcion Auxiliar para A¤adir lineas de detalle a un pedido
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt )

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, aTmp, cCodArt )

Return ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un pedido
*/
STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, aTmp )

Return ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un pedido
*/

STATIC FUNCTION DelDeta()

   if ( dbfTmpLin )->lKitArt
      dbDelKit( , dbfTmpLin, ( dbfTmpLin )->nNumLin )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrwLin, bEdtDet, aTmp )

   WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, aTmp )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, aTmpPed, cCodArt, nMode )

   local oDlg
   local oFld
   local oBmp
   local oBtn
   local oSay2
   local cSay2
   local oSayFam
   local cSayFam        := ""
   local oSayPr1
   local oSayPr2
   local cSayPr1        := ""
   local cSayPr2        := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1        := ""
   local cSayVp2        := ""
   local oTotal
   local nTotal         := 0
   local oGet1
   local oGetStk
   local nGetStk        := 0
   local oSayLote
   local nTotRes
   local oTotUni
   local oTotEnt
   local oTotPdt
   local oBrwAlb
   local nOrdAnt
   local oBrwPrp
   local cNumPed        := aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]

   cOldCodArt           := aTmp[ _CREF ]
   cOldUndMed           := aTmp[ _CUNIDAD ]
   cTipoCtrCoste        := alltrim( aTmp[ _CTIPCTR ] )

   if nMode == APPD_MODE

      aTmp[_NUNICAJA]   := 1
      aTmp[_CALMLIN ]   := aTmpPed[ _CCODALM ]

      if !empty( cCodArt )
         aTmp[ _CREF ]  := cCodArt
      end if

      cTipoCtrCoste     := "Centro de coste"

      D():CamposExtraLine( nView ):setTemporalAppend()

      //runScript( "PedidosProveedores\Lineas\beforeAppendLine.prg", aTmp, aGet, nView, nMode, ( ( dbfTmpLin )->( ordKeyCount() ) == 0 ) )

   else

      nGetStk           := D():Stocks( nView ):nPutStockActual( aTmp[ _CREFPRV ], aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ] )

   end if

   nTotRes              := nUnidadesRecibidasPedPrv( aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ], aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CREFPRV ], D():AlbaranesProveedoresLineas( nView ) )

   if nTotRes > nTotNPedPrv( aTmp )
      nTotRes           := nTotNPedPrv( aTmp )
   end if

   nOrdAnt              := ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( "cPedPrvRef" ) )

   ( D():AlbaranesProveedoresLineas( nView ) )->( OrdScope( 0, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] + aTmp[ _CLOTE ] ) )
   ( D():AlbaranesProveedoresLineas( nView ) )->( OrdScope( 1, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] + aTmp[ _CLOTE ] ) )
   ( D():AlbaranesProveedoresLineas( nView ) )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "LPEDPRV" ;
      TITLE       LblTitle( nMode ) + "líneas a pedidos de proveedores"

	  REDEFINE FOLDER oFld ID 400 OF oDlg ;
         PROMPT   "&General",;
                  "Da&tos",;
                  "&Anular",;
                  "&Observaciones",;
                  "&Centro coste" ;
         DIALOGS  "LPEDPRV_1",;
                  "LPEDPRV_2",;
                  "LFACPRV_4",;
                  "LFACPRV_6",;
                  "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF ] VAR aTmp[ _CREF ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oDlg, oBmp, oGetStk ) );
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], , if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]
 
      /*
      Lotes
      ------------------------------------------------------
      */

      REDEFINE SAY oSayLote;
         ID       111 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], D():PropiedadesLineas( nView ) ),;
                        LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oDlg, oBmp, oGetStk ),;
                        .f. ) ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[_CCODPR1 ] ) ) ;
	      OF 		oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), D():Stocks( nView ):nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) }

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
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], D():PropiedadesLineas( nView ) ),;
                        LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oDlg, oBmp, oGetStk ),;
                        .f. ) ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), D():Stocks( nView ):nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ]  ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    (  cAlmacen( aGet[ _CALMLIN ], , oSay2 ),;
                     D():Stocks( nView ):lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, oSay2 ) ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET oSay2 VAR cSay2 ;
			WHEN 		.F. ;
         ID       241 ;
			OF 		oFld:aDialogs[1]

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

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		130 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 99.99" ;
         ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         VALID    ( lTiva( D():TiposIva( nView ), aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON HELP  ( BrwIva( aGet[ _NIVA ], D():TiposIva( nView ), , .t. ) ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

      // IVMH------------------------------------------------------------------

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPinDiv ;
         ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         OF       oFld:aDialogs[1]

      // Bultos y cajas---------------------------------------------------------
      
      REDEFINE GET   aGet[ __NBULTOS ] ;
         VAR         aTmp[ __NBULTOS ] ;
         ID          420 ;
         IDSAY       421 ;
         SPINNER ;
         WHEN        ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE     cPicUnd ;
         OF          oFld:aDialogs[1]   

      aGet[ __NBULTOS ]:Cargo          := "nBultos"
      aGet[ __NBULTOS ]:bPostValidate  := {| oSender | runScript( "PedidosProveedores\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } 

      REDEFINE GET   aGet[ _NCANPED ] ;
         VAR         aTmp[ _NCANPED ];
			ID          140 ;
         IDSAY       141 ;
         SPINNER ;
         WHEN        ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
         PICTURE     cPicUnd ;
         OF          oFld:aDialogs[1] 

      aGet[ _NCANPED ]:Cargo          := "nCanPed"
      aGet[ _NCANPED ]:bPostValidate  := {| oSender | runScript( "PedidosProveedores\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } 

      // Campos de las descripciones de la unidad de medición------------------

      REDEFINE GET   aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR         aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID          300 ;
         IDSAY       301 ;
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
         PICTURE     MasUnd() ;
         OF          oFld:aDialogs[1]

      aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET   aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR         aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID          310 ;
         IDSAY       311 ;
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
         PICTURE     MasUnd() ;
         OF          oFld:aDialogs[1]

      aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET   aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR         aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID          320 ;
         IDSAY       321 ;
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
         PICTURE     MasUnd() ;
         OF          oFld:aDialogs[1]

      aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET   aGet[ _NUNICAJA ] ;
         VAR         aTmp[ _NUNICAJA ] ;
         ID          150 ;
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ON CHANGE   ( lCalcDeta( aTmp, oTotal ) ) ;
         PICTURE 	   cPicUnd ;
         OF          oFld:aDialogs[1] ;
         IDSAY       151

         aGet[ _NUNICAJA ]:Cargo          := "nUniCaja"
         aGet[ _NUNICAJA ]:bPostValidate  := {| oSender | runScript( "PedidosProveedores\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } 

      REDEFINE GET   aGet[ _NPREDIV ] ;
         VAR         aTmp[ _NPREDIV ] ;
			ID          160 ;
			SPINNER ;
			PICTURE     cPinDiv ;
			WHEN        ( nMode != ZOOM_MODE ) ;
			ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
			OF          oFld:aDialogs[1]

      /*aGet[ _NPREDIV ]:Cargo          := "nPreDiv"
      aGet[ _NPREDIV ]:bPostValidate  := {| oSender | runScript( "PedidosProveedores\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } */

      REDEFINE GET   aGet[ _CUNIDAD ] ;
         VAR         aTmp[ _CUNIDAD ] ;
         ID          170 ;
         IDTEXT      171 ;
         BITMAP      "LUPA" ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         VALID       ( D():UnidadMedicion( nView ):Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet) );
         ON HELP     ( D():UnidadMedicion( nView ):Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         OF          oFld:aDialogs[1]

		REDEFINE GET   aGet[ _NDTOLIN ] ;
         VAR         aTmp[ _NDTOLIN ] ;
			ID          180 ;
			WHEN        ( nMode != ZOOM_MODE ) ;
			ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
			SPINNER ;
         PICTURE     "@E 999.99" ;
			OF          oFld:aDialogs[1]

      REDEFINE GET   aGet[ _NDTOPRM ] ;
         VAR         aTmp[ _NDTOPRM ] ;
         ID          250 ;
			WHEN        ( nMode != ZOOM_MODE ) ;
			ON CHANGE   ( lCalcDeta( aTmp, oTotal ) );
			SPINNER ;
			PICTURE     "@E 99.99" ;
			OF          oFld:aDialogs[1]

      REDEFINE GET   aGet[ _NDTORAP ] ;
         VAR         aTmp[ _NDTORAP ] ;
         ID          260 ;
			WHEN        ( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE     "@E 99.99" ;
			OF          oFld:aDialogs[1]

      REDEFINE GET   aGet[ _CFORMATO ] ;
         VAR         aTmp[ _CFORMATO ] ;
         ID          430 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oFld:aDialogs[1]

      REDEFINE GET   oGetStk ;
         VAR         nGetStk ;
         ID          190 ;
         WHEN        .f. ;
			PICTURE 	   cPicUnd ;
			OF          oFld:aDialogs[1]

      REDEFINE GET   aGet[ _CREFPRV ] ;
         VAR         aTmp[ _CREFPRV ];
         ID          400 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oFld:aDialogs[1]

		REDEFINE GET    oTotal VAR nTotal ;
			ID          210 ;
         PICTURE     cPirDiv ;
			WHEN        .f. ;
			OF          oFld:aDialogs[1]

      REDEFINE BITMAP oBmp ;
         ID          100 ;
         OF          oDlg

      oBmp:SetColor( , GetSysColor( 15 ) )

      /*
      Segunda Caja de diálogo--------------------------------------------------
      */

      REDEFINE SAY   oTotUni ;
         PROMPT      nTotNPedPrv( aTmp ) ;
         ID          150 ;
         COLOR       "B/W*" ;
         PICTURE     cPicUnd ;
         OF          oFld:aDialogs[2]

      REDEFINE SAY   oTotEnt ;
         PROMPT      nTotRes ;
         ID          160 ;
         COLOR       "G/W*" ;
         PICTURE     cPicUnd ;
         OF          oFld:aDialogs[2]

      REDEFINE SAY   oTotPdt ;
         PROMPT      nTotNPedPrv( aTmp ) - nTotRes ;
         ID          170 ;
         COLOR       "R/W*" ;
         PICTURE     cPicUnd ;
         OF          oFld:aDialogs[2]

      /*
      Browse de albaranes------------------------------------------------------
      */

      oBrwAlb                 := IXBrowse():New( oFld:aDialogs[ 2 ] )

      oBrwAlb:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAlb:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAlb:cAlias          := D():AlbaranesProveedoresLineas( nView )

      oBrwAlb:lFooter         := .f.
      oBrwAlb:nMarqueeStyle   := 5

      oBrwAlb:CreateFromResource( 180 )

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( dFecAlbPrv( ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresLineas( nView ) )->cSufAlb, D():AlbaranesProveedores( nView ) ) ) }
            :nWidth           := 80
         end with

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Albarán"
            :bEditValue       := {|| AllTrim( ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb ) + "/" + AllTrim( Str( ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb ) ) + "/" + AllTrim( ( D():AlbaranesProveedoresLineas( nView ) )->cSufAlb ) }
            :nWidth           := 80
         end with

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Proveedor"
            :bEditValue       := {|| AllTrim( aTmpPed[ _CCODPRV ] ) + " - " + AllTrim( aTmpPed[ _CNOMPRV ] ) }
            :nWidth           := 240
         end with

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Total unidades"
            :bEditValue       := {|| nTotNAlbPrv( D():AlbaranesProveedoresLineas( nView ) ) }
            :bFooter          := {|| nTotRes }
            :cEditPicture     := cPicUnd
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

      /*
      Quinta caja de diálogo---------------------------------------------------
      */

      REDEFINE GET aGet[ __CCENTROCOSTE ] VAR aTmp[ __CCENTROCOSTE ] ;
         ID       410 ;
         IDTEXT   411 ;
         BITMAP   "LUPA" ;
         VALID    ( D():CentroCoste( nView ):Existe( aGet[ __CCENTROCOSTE ], aGet[ __CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( D():CentroCoste( nView ):Buscar( aGet[ __CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[5]

      REDEFINE COMBOBOX oTipoCtrCoste ;
         VAR      cTipoCtrCoste ;
         ITEMS    aTipoCtrCoste ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oFld:aDialogs[5]

         oTipoCtrCoste:bChange   := {|| clearGet( aGet[ _CTERCTR ] ), loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ) }

      REDEFINE GET aGet[ _CTERCTR ] ;
         VAR      aTmp[ _CTERCTR ] ;
         ID       150 ;
         IDTEXT   160 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oFld:aDialogs[5]

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aGet, oBrwPrp, oFld, oDlg, oBrw, nMode, oTotal, oGet1, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetStk, oSayLote, oBtn ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( GoHelp() )

      REDEFINE CHECKBOX aGet[_LANULADO] VAR aTmp[_LANULADO] ;
			ID 		400 ;
         ON CHANGE( CambiaAnulado( aGet, aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[_DANULADO] VAR aTmp[_DANULADO] ;
         ID       410 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _MANULADO ] VAR aTmp[_MANULADO] ;
			MEMO ;
         ID       420 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[_MOBSLIN] VAR aTmp[_MOBSLIN] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| SaveDeta( aTmp, aGet, oBrwPrp, oFld, oDlg, oBrw, nMode, oTotal, oGet1, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetStk, oSayLote, oBtn ) } )
      oDlg:AddFastKey( VK_F9, {|| D():CamposExtraLine( nView ):Play( if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) ) } )
   end if 

   oDlg:SetControlFastKey( "PedidosProveedoresLineas", nView, aGet )

   oDlg:bStart    := {||   aGet[ _CUNIDAD ]:lValid(),;
                           loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                           if( !empty( cCodArt ), aGet[ _CREF ]:lValid(), ),;
                           SetDlgMode( aGet, aTmp, aTmpPed, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oFld, oDlg, oTotal, oGetStk ),;
                           lCalcDeta( aTmp, oTotal ),;
                           oBrwAlb:GoTop(), oBrwAlb:Refresh() }

   ACTIVATE DIALOG oDlg ;
         ON INIT  ( MenuEdtDet( aGet[ _CREF ], oDlg, , if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) ) );
         CENTER

   if !Empty( oDetMenu )      
      oDetMenu:End()
   end if

   ( D():AlbaranesProveedoresLineas( nView ) )->( OrdScope( 0, nil ) )
   ( D():AlbaranesProveedoresLineas( nView ) )->( OrdScope( 1, nil ) )
   ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION SetDlgMode( aGet, aTmp, aTmpPed, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oFld, oDlg, oTotal )

   local cCodArt        := aGet[ _CREF ]:VarGet()

   if !uFieldEmpresa( "lUseBultos" )
      aGet[ __NBULTOS ]:Hide()
   else
      if !empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if !lUseCaj()
      aGet[ _NCANPED ]:Hide()
   else
      aGet[ _NCANPED ]:SetText( cNombreCajas() )
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if empty( aTmp[ _CALMLIN ] )
      aTmp[ _CALMLIN ]  := aTmpPed[ _CCODALM ]
   end if

   oBrwPrp:Hide()

   oSayPr1:SetText( "" )
   oSayVp1:SetText( "" )

   oSayPr2:SetText( "" )
   oSayVp2:SetText( "" )
   
   runScript( "PedidosProveedores\Lineas\beforeAppendLine.prg", aTmp, aGet, nView, nMode, ( ( dbfTmpLin )->( ordKeyCount() ) == 0 ) )
   
   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:show()
      aGet[ _CDETALLE]:show()
      aGet[ _MLNGDES ]:hide()
      aGet[ _CLOTE   ]:hide()
      aGet[ _NUNICAJA]:cText( 1 )
      aGet[ _NCANPED ]:cText( 1 )
      aGet[ _CALMLIN ]:cText( aTmpPed[ _CCODALM ] )
      aGet[ _DANULADO]:cText( Ctod( "" ) )
      aGet[ _LANULADO]:Click( .f. )
      aGet[ _NIVA    ]:cText( nIva( D():TiposIva( nView ), cDefIva() ) )

      aTmp[ _NREQ    ]     := nReq( D():TiposIva( nView ), cDefIva() )

      aTmp[ _NNUMLIN ]     := nLastNum( dbfTmpLin )
      aTmp[ _NPOSPRINT ]   := nLastNum( dbfTmpLin, "nPosPrint" )

      oSayLote:hide()

      aGet[ __CCENTROCOSTE ]:cText( aTmpPed[ _CCENTROCOSTE ] )

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif
   
   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[_CREF    ]:hide()
		aGet[_CDETALLE]:hide()
		aGet[_MLNGDES ]:show()
      aGet[_CLOTE   ]:hide()

      oSayLote:hide()

      aGet[ __CCENTROCOSTE ]:cText( aTmpPed[ _CCENTROCOSTE ] )

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

   case nMode != APPD_MODE .AND. !empty( cCodArt )

      aGet[_CREF    ]:show()
		aGet[_CDETALLE]:show()
		aGet[_MLNGDES ]:hide()

      if aTmp[_LLOTE]
         aGet[_CLOTE   ]:Show()
         oSayLote:Show()
      else
         aGet[_CLOTE   ]:Hide()
         oSayLote:Hide()
      end if

      aGet[ __CCENTROCOSTE ]:cText( aTmpPed[ _CCENTROCOSTE ] )

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

   end case

   if !empty( aTmp[ _CCODPR1 ] )
      aGet[ _CVALPR1 ]:Show()
      //aGet[ _CVALPR1 ]:lValid()
      oSayPr1:SetText( retProp( aTmp[ _CCODPR1 ], D():Propiedades( nView ) ) )
      oSayPr1:Show()
      oSayVp1:Show()
      oSayVp1:cText( cNombrePropiedad( aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], D():PropiedadesLineas( nView ) ) )
      oSayVp1:Refresh()
      aGet[ _CVALPR1 ]:Refresh()
   else
      aGet[ _CVALPR1 ]:Hide()
      oSayPr1:Hide()
      oSayVp1:Hide()
   end if

   if !empty( aTmp[ _CCODPR2 ] )
      aGet[ _CVALPR2 ]:Show()
      //aGet[ _CVALPR2 ]:lValid()
      oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], D():Propiedades( nView ) ) )
      oSayPr2:Show()
      oSayVp2:Show()
      oSayVp2:cText( cNombrePropiedad( aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], D():PropiedadesLineas( nView ) ) )
      oSayVp2:Refresh()
      aGet[ _CVALPR2 ]:Refresh()
   else
      aGet[ _CVALPR2 ]:hide()
      oSayPr2:Hide()
      oSayVp2:Hide()
   end if

   //Ocultamos las tres unidades de medicion

   aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()

   if D():UnidadMedicion( nView ):oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if D():UnidadMedicion( nView ):oDbf:nDimension >= 1 .and. !empty( D():UnidadMedicion( nView ):oDbf:cTextoDim1 )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( D():UnidadMedicion( nView ):oDbf:cTextoDim1 )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if D():UnidadMedicion( nView ):oDbf:nDimension >= 2 .and. !empty( D():UnidadMedicion( nView ):oDbf:cTextoDim2 )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( D():UnidadMedicion( nView ):oDbf:cTextoDim2 )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if D():UnidadMedicion( nView ):oDbf:nDimension >= 3 .and. !empty( D():D():UnidadMedicion( nView ):oDbf:cTextoDim3 )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( D():UnidadMedicion( nView ):oDbf:cTextoDim3 )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   // Prepramos la caja

   oFld:SetOption( 1 )

   aGet[ _CALMLIN ]:lValid()
   aGet[ _CCODFAM ]:lValid()

   oTotal:cText( 0 )
   
   aGet[ _CREF    ]:SetFocus()

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oDlg, oBmp, oGetStk )

   local nOrdAnt
   local cCodFam
   local cCodPrv
   local cPrpArt
   local cCodArt
   local nUnidad
   local nPreCom
   local lChgCodArt
   local lSeek       := .f.

   nPreCom           := 0
   cCodPrv           := aTmpPed[ _CCODPRV ]
   cCodArt           := aGet[ _CREF ]:varGet()
   cPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   lChgCodArt        := ( Rtrim( cOldCodArt ) != Rtrim( cCodArt ) .or. Rtrim( cOldPrpArt ) != Rtrim( cPrpArt ) )

   if empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      aGet[ _NIVA     ]:bWhen := {|| .t. }
      aGet[ _CDETALLE ]:Hide()
      aGet[ _CLOTE    ]:Hide()

      oSayLote:Hide()

      aGet[ _MLNGDES  ]:Show()
      aGet[ _MLNGDES  ]:SetFocus()

      if !empty( oBrwPrp )
         oBrwPrp:Hide()
      end if

   else

      if lModIva()
         aGet[ _NIVA  ]:bWhen := {|| .t. }
      else
         aGet[ _NIVA  ]:bWhen := {|| .f. }
      end if

      aGet[ _CREF     ]:Show()
      aGet[ _CDETALLE ]:Show()
      aGet[ _MLNGDES  ]:Hide()

      if lIntelliArtciculoSearch( cCodArt, cCodPrv, D():Articulos( nView ), D():ProveedorArticulo( nView ), D():ArticulosCodigosBarras( nView ) )

         if ( lChgCodArt )

            if ( D():Articulos( nView ) )->lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               return .f.
            end if

            aGet[ _CREF     ]:cText( ( D():Articulos( nView ) )->Codigo )
            aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )

            //Pasamos las referencias adicionales------------------------------

            aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            if ( D():Articulos( nView ) )->lMosCom .and. !empty( ( D():Articulos( nView ) )->mComent )
               MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
            end if

            // Ahora recogemos el impuesto especial si lo hay------------------

            aTmp[ _CCODIMP ]  := ( D():Articulos( nView ) )->cCodImp

            D():ImpuestosEspeciales( nView ):setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

            // Preguntamos si el regimen de " + cImp() + " es distinto de Exento

            if aTmpPed[ _NREGIVA ] <= 1
               aGet[ _NIVA ]:cText( nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) )
               aTmp[ _NREQ ]     := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
            end if

            if ( D():Articulos( nView ) )->nCajEnt != 0
               aGet[ _NCANPED ]:cText( ( D():Articulos( nView ) )->nCajEnt )
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
            end if

            // Lotes---------------------------------------------------------------------

            aTmp[ _LLOTE ]    := ( D():Articulos( nView ) )->lLote

            if ( D():Articulos( nView ) )->lLote
               oSayLote:Show()
               aGet[ _CLOTE ]:Show()
               aGet[ _CLOTE ]:cText( ( D():Articulos( nView ) )->cLote )
            else
               oSayLote:Hide()
               aGet[ _CLOTE ]:Hide()
            end if

            /*
            Referencia de proveedor-----------------------------------------------
            */

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
            Control de stocks--------------------------------------------------
            */

            aTmp[ _NCTLSTK ]        := ( D():Articulos( nView ) )->nCtlStock

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

            // Buscamos la familia del articulo y anotamos las propiedades--------

            aTmp[ _CCODPR1 ]        := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]        := ( D():Articulos( nView ) )->cCodPrp2

            if ( !empty( aTmp[ _CCODPR1 ] ) .or. !empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

               nPreCom              := nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmpPed[ _CDIVPED ], D():Divisas( nView ) )

               setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _NPREDIV ], aGet[ _NUNICAJA ], oBrwPrp, nView )

            else

               hidePropertiesTable( oBrwPrp )

               if !empty( aTmp[ _CCODPR1 ] ) // .and. !uFieldEmpresa( "lUseTbl" ) .or. ( nMode == APPD_MODE )

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

               if !empty( aTmp[ _CCODPR2 ] ) // .and. !uFieldEmpresa( "lUseTbl" )

                  if aGet[ _CVALPR2 ] != nil
                     aGet[ _CVALPR2 ]:show()
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

            // Precios de compra--------------------------------------------

            nPreCom           := nComPro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], D():ArticuloPrecioPropiedades( nView ) )

            if nPrecom  != 0

               aGet[ _NPREDIV ]:cText( nPreCom )

            else

               if uFieldEmpresa( "lCosPrv", .f. )
                  nPreCom     := nPrecioReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )
               end if

               if nPreCom != 0
                  aGet[ _NPREDIV ]:cText( nPreCom )
               else
                  aGet[ _NPREDIV ]:cText( nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmpPed[ _CDIVPED ], D():Divisas( nView ) ) )
               end if

               // Descuento de articulo-------------------------------------

               if uFieldEmpresa( "lCosPrv", .f. )

                  nPreCom     := nDescuentoReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )
                  if nPreCom != 0
                     aGet[ _NDTOLIN ]:cText( nPreCom )
                  end if

                  // Descuento de promocional-------------------------------

                  nPreCom     := nPromocionReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )
                  if nPreCom != 0
                     aGet[ _NDTOPRM ]:cText( nPreCom )
                  end if

               end if

            end if

            // Recogemos las familias y los grupos de familias--------------------

            cCodFam              := ( D():Articulos( nView ) )->Familia
            if !empty( cCodFam )
               aTmp[ _CCODFAM ]  := cCodFam
               aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, D():Familias( nView ) )
            end if

            // Ponemos el precio de venta recomendado-----------------------------

            aTmp[ _NPVPREC  ]    := ( D():Articulos( nView ) )->PvpRec

            // Ponemos el stock---------------------------------------------------

            if oGetStk != nil .and. aTmp[ _NCTLSTK ] <= 1
               D():Stocks( nView ):nPutStockActual( cCodArt, aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk )
            end if

            if !empty( aGet[ _CUNIDAD ] )
                aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
                aGet[ _CUNIDAD ]:lValid()
            else
                aTmp[ _CUNIDAD ]    := ( D():Articulos( nView ) )->cUnidad
            end if

            ValidaMedicion( aTmp, aGet )

         end if

      else

         msgStop( "Artículo no encontrado" )

         Return .f.

      end if

   end if

   cOldCodArt        := cCodArt
   cOldPrpArt        := cPrpArt

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION GetArtPrv( cRefPrv, cCodPrv, aGet )

	local nOrdAnt

   if empty( cRefPrv )
      Return .t.
   end if 

   nOrdAnt  := ( D():ProveedorArticulo( nView ) )->( ordSetFocus( "cRefPrv" ) )

   if ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodPrv + cRefPrv ) )
      aGet[ _CREF ]:cText( ( D():ProveedorArticulo( nView ) )->cCodArt )
		aGet[ _CREF ]:lValid()
   else
      msgStop( "Referencia de proveedor no encontrada" )
   end if

	( D():ProveedorArticulo( nView ) )->( ordSetFocus( nOrdAnt ) )

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrwPrp, oFld, oDlg, oBrw, nMode, oTotal, oGet, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetStk, oSayLote, oBtn )

   local n, i

   if !lMoreIva( aTmp[ _NIVA ] )
      Return nil
   end if

   if empty( aTmp[ _CALMLIN ] ) .and. !empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
      Return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ] )
      Return nil
   end if

   /*
   Escribir en fichero definitivo----------------------------------------------
   */

   aTmp[ _CTIPCTR ]  := cTipoCtrCoste

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )   
      end if

      if !empty( oBrwPrp:Cargo )

         for n := 1 to len( oBrwPrp:Cargo )

            for i := 1 to len( oBrwPrp:Cargo[ n ] )

               if oBrwPrp:Cargo[ n, i ]:Value != nil .and. oBrwPrp:Cargo[ n, i ]:Value != 0

                  aTmp[ _NNUMLIN ]     := nLastNum( dbfTmpLin )
                  aTmp[ _NPOSPRINT ]   := nLastNum( dbfTmpLin, "nPosPrint" )
                  aTmp[ _NUNICAJA]     := oBrwPrp:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]     := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]     := oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]     := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]     := oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
                  
                  if isNum( oBrwPrp:Cargo[ n, i ]:nPrecioCompra ) .and. ( oBrwPrp:Cargo[ n, i ]:nPrecioCompra != 0 ) 
                     aTmp[ _NPREDIV ]  := oBrwPrp:Cargo[ n, i ]:nPrecioCompra
                  end if 
                  
                  winGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

               end if

            next

         next

         aCopy( dbBlankRec( dbfTmpLin ), aTmp )

         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      else

         WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      end if

      if lEntCon()

         /*aCopy( dbBlankRec( dbfTmpLin ), aTmp )

         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )*/

         SetDlgMode( aGet, aTmp, aTmpPed, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oFld, oDlg, oTotal, oGetStk )

         nTotPedPrv( nil, D():PedidosProveedores( nView ), dbfTmpLin, D():TiposIva( nView ), D():Divisas( nView ), aTmpPed )

      else

         oDlg:end( IDOK )

      end if

   else

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      oDlg:end( IDOK )

   end if

   runScript( "PedidosProveedores\Lineas\afterSaveLine.prg", nView, nMode, aTmpPed, dbfTmpLin )

   if nMode == APPD_MODE
      D():CamposExtraLine( nView ):SaveTemporalAppend( ( dbfTmpLin )->( OrdKeyNo() ) )
   end if

   aTmp[ _MNUMSER ]                 := ""
   cOldCodArt                       := ""
   cOldUndMed                       := ""

   if !empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if !empty( oBrwPrp )
      oBrwPrp:Cargo                 := nil
   end if

   if oGet != nil
      oGet:cText( Space( 14 ) )
      oGet:SetFocus()
   end if

   if oGetStk != nil
      oGetStk:cText( 0 )
   end if

Return nil

//--------------------------------------------------------------------------//

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

   MsgStop( "Pedido con mas de 3 tipos de " + cImp(), "Imposible añadir" )

Return .f.

//---------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie( oBrw )

   local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := ( D():PedidosProveedores( nView ) )->cSerPed
   local cSerFin     := ( D():PedidosProveedores( nView ) )->cSerPed
   local nDocIni     := ( D():PedidosProveedores( nView ) )->nNumPed
   local nDocFin     := ( D():PedidosProveedores( nView ) )->nNumPed
   local cSufIni     := ( D():PedidosProveedores( nView ) )->cSufPed
   local cSufFin     := ( D():PedidosProveedores( nView ) )->cSufPed
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) )
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()

   if empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "PP" )
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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "PP" ) ) ;
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

      nRecno            := ( D():PedidosProveedores( nView ) )->( Recno() )
      nOrdAnt           := ( D():PedidosProveedores( nView ) )->( OrdSetFocus( "NNUMPED" ) )

      if !lInvOrden

            ( D():PedidosProveedores( nView ) )->( dbSeek( cDocIni, .t. ) )

            while ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed >= cDocIni .AND. ;
                  ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed <= cDocFin

                  lChgImpDoc( D():PedidosProveedores( nView ) )

            if lCopiasPre

                  nCopyProvee := if( nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) )

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

            else

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nNumCop )

            end if

            ( D():PedidosProveedores( nView ) )->( dbSkip() )

            end while

      else

      ( D():PedidosProveedores( nView ) )->( dbSeek( cDocFin ) )

         while ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed >= cDocIni .and.;
               ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed <= cDocFin .and.;
               !( D():PedidosProveedores( nView ) )->( Bof() )

               lChgImpDoc( D():PedidosProveedores( nView ) )

         if lCopiasPre

               nCopyProvee := if( nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) )

               GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

         else

               GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nNumCop )

         end if

         ( D():PedidosProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   else

      nRecno            := ( D():PedidosProveedores( nView ) )->( Recno() )
      nOrdAnt           := ( D():PedidosProveedores( nView ) )->( OrdSetFocus( "DFECPED" ) )

      if !lInvOrden

            ( D():PedidosProveedores( nView ) )->( dbGoTop() )

            while !( D():PedidosProveedores( nView ) )->( Eof() )

               if ( D():PedidosProveedores( nView ) )->dFecPed >= dFecDesde .and. ( D():PedidosProveedores( nView ) )->dFecPed <= dFecHasta

                  lChgImpDoc( D():PedidosProveedores( nView ) )

                  if lCopiasPre

                        nCopyProvee := if( nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) )

                        GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

                  else

                        GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nNumCop )

                  end if

               end if   

            ( D():PedidosProveedores( nView ) )->( dbSkip() )

            end while

      else

         ( D():PedidosProveedores( nView ) )->( dbGoBottom() )

         while !( D():PedidosProveedores( nView ) )->( Bof() )

            if ( D():PedidosProveedores( nView ) )->dFecPed >= dFecDesde .and. ( D():PedidosProveedores( nView ) )->dFecPed <= dFecHasta

               lChgImpDoc( D():PedidosProveedores( nView ) )

               if lCopiasPre

                  nCopyProvee := if( nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) )

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + (D():PedidosProveedores( nView ))->cSufPed, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         ( D():PedidosProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if
   
   end if   

   ( D():PedidosProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():PedidosProveedores( nView ) )->( dbGoTo( nRecNo ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION GenPedPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nPedido

   if ( D():PedidosProveedores( nView ) )->( Lastrec() ) == 0
      return nil
   end if

   nPedido              := ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo pedido"
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) )
   DEFAULT nCopies      := if( nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) ) )

   if empty( cCodDoc )
      cCodDoc           := cFirstDoc( "PP", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      PrintReportPedPrv( nDevice, nCopies, cPrinter, cCodDoc )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():PedidosProveedores( nView ) )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   nTotPedPrv( nil, D():PedidosProveedores( nView ), dbfTmpLin, D():TiposIva( nView ), D():Divisas( nView ), aTmp )

   oBrwIva:Refresh()

   oGetNet:SetText( Trans( nTotNet, cPirDiv ) )

   oGetIva:SetText( Trans( nTotIva, cPirDiv ) )

   oGetIvm:SetText( Trans( nTotIvm, cPirDiv ) )

   oGetReq:SetText( Trans( nTotReq, cPirDiv ) )

   oGetTotal:SetText( Trans( nTotPed, cPirDiv ) )

Return .t.

//--------------------------------------------------------------------------//

/*
Carga los datos del proveedor
*/

STATIC FUNCTION LoaPrv( aGet, aTmp, dbf, nMode, oSay, oTlfPrv )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCODPRV ]:VarGet()
   local lChgCodCli  := ( empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODPRV ], "0", RetNumCodPrvEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodPrvEmp() )
   end if

   if ( D():Proveedores( nView ) )->( dbSeek( cNewCodCli ) )

      if ( D():Proveedores( nView ) )->lBlqPrv
         msgStop( "Proveedor bloqueado, no se pueden realizar operaciones de compra" )
         return .f.
      end if

      aGet[ _CCODPRV ]:cText( ( D():Proveedores( nView ) )->Cod )

      if empty( aGet[ _CNOMPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMPRV ]:cText( ( D():Proveedores( nView ) )->Titulo )
      end if

      if oTlfPrv != nil
         oTlfPrv:SetText( ( D():Proveedores( nView ) )->Telefono )
      end if

      if empty( aGet[ _CDIRPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRPRV ]:cText( ( D():Proveedores( nView ) )->Domicilio )
      endif

      if empty( aGet[ _CPOBPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBPRV ]:cText( ( D():Proveedores( nView ) )->Poblacion )
      endif

      if empty( aGet[ _CPROPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPROPRV ]:cText( ( D():Proveedores( nView ) )->Provincia )
      endif

      if empty( aGet[ _CPOSPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSPRV ]:cText( ( D():Proveedores( nView ) )->CodPostal )
      endif

      if empty( aGet[ _CDNIPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDNIPRV ]:cText( ( D():Proveedores( nView ) )->Nif )
      endif

      /*
      Descuentos
      */

      if lChgCodCli
         aGet[ _CDTOESP ]:cText( ( D():Proveedores( nView ) )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( D():Proveedores( nView ) )->nDtoEsp )
         aGet[ _CDPP    ]:cText( ( D():Proveedores( nView ) )->cDtoPp  )
         aGet[ _NDPP    ]:cText( ( D():Proveedores( nView ) )->DtoPp   )
      end if

      if empty( aGet[ _CCODPGO ]:VarGet() )
         aGet[ _CCODPGO ]:cText( ( D():Proveedores( nView ) )->fPago )
         aGet[ _CCODPGO ]:lValid()
      end if

      /*
      Fecha de entrada
      */

      if lChgCodCli
         if ( D():Proveedores( nView ) )->nPlzEnt != 0
            aGet[ _DFECENT ]:cText( GetSysDate() + ( D():Proveedores( nView ) )->nPlzEnt )
         else
            aGet[ _DFECENT ]:cText( Ctod( "" ) )
         end if
      end if

      if nMode == APPD_MODE

         aGet[ _NREGIVA ]:nOption( Max( ( D():Proveedores( nView ) )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         if empty( aTmp[ _CSERPED ] )

            if !empty( ( D():Proveedores( nView ) )->Serie )
               aGet[ _CSERPED ]:cText( ( D():Proveedores( nView ) )->Serie )
            end if

         else

            if !empty( ( D():Proveedores( nView ) )->Serie ) .and. aTmp[ _CSERPED ] != ( D():Proveedores( nView ) )->Serie .and. ApoloMsgNoYes( "La serie del proveedor seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERPED ]:cText( ( D():Proveedores( nView ) )->Serie )
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

      cOldCodCli     := ( D():Proveedores( nView ) )->Cod

      lValid         := .t.

   else

		msgStop( "Proveedor no encontrado" )

   end if

RETURN lValid

//--------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, oTotal )

   local nCalculo := nTotUPedPrv( aTmp, nDinDiv )

   IF lCalCaj()
      nCalculo    *= If( aTmp[ _NCANPED ] != 0, aTmp[ _NCANPED ], 1 )
	END IF

	IF aTmp[ _NDTOLIN ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTOLIN ] / 100
	END IF

   IF aTmp[ _NDTOPRM ] != 0
		nCalculo 	-= nCalculo * aTmp[ _NDTOPRM ] / 100
	END IF

   nCalculo       *= nTotNPedPrv( aTmp )

   nCalculo       := Round( nCalculo, nDinDiv )

	oTotal:cText( nCalculo )

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local lErrors     := .f.
   local cDbfLin     := "PProL"
   local cDbfInc     := "PProI"
   local cDbfDoc     := "PProD"
   local nPedido     := aTmp[ _CSERPED ] +  Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      tmpPedidosLineas        := cGetNewFileName( cPatTmp() + cDbfLin )
      tmpPedidosIncidencias   := cGetNewFileName( cPatTmp() + cDbfInc )
      tmpPedidosDocumentos    := cGetNewFileName( cPatTmp() + cDbfDoc )

      /*
      Primero Crear la base de datos local----------------------------------------
      */

      dbCreate( tmpPedidosLineas, aSqlStruct( aColPedPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), tmpPedidosLineas, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

      if !( dbfTmpLin )->( neterr() )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin, 4 ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "cRef", "cRef", {|| Field->cRef } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "cDetalle", "Left( cDetalle, 100 )", {|| Left( Field->cDetalle, 100 ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "nUniCaja", "nUniCaja", {|| Field->nUniCaja } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "cRefPrv", "cRefPrv", {|| Field->cRefPrv } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( tmpPedidosLineas, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

      end if

      /*
      Creamos el fichero de incidencias-------------------------------------------
      */

      dbCreate( tmpPedidosIncidencias, aSqlStruct( aIncPedPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), tmpPedidosIncidencias, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )

      if !( dbfTmpInc )->( neterr() )
         ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpInc )->( ordCreate( tmpPedidosIncidencias, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      Creamos el fichero de Documentos--------------------------------------------
      */

      dbCreate( tmpPedidosDocumentos, aSqlStruct( aPedPrvDoc() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), tmpPedidosDocumentos, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
      if !( dbfTmpDoc )->( neterr() )
         ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpDoc )->( ordCreate( tmpPedidosDocumentos, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de lineas-----------------------------------------
      */

      D():CamposExtraLine( nView ):initArrayValue()

      if ( D():PedidosProveedoresLineas( nView ) )->( dbSeek( nPedido ) )

         while ( ( D():PedidosProveedoresLineas( nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed == nPedido .and. ( D():PedidosProveedoresLineas( nView ) )->( !eof() ) )

            dbPass( D():PedidosProveedoresLineas( nView ), dbfTmpLin, .t. )

            D():CamposExtraLine( nView ):SetTemporalLines( ( dbfTmpLin )->cSerPed + str( ( dbfTmpLin )->nNumPed ) + ( dbfTmpLin )->cSufPed + str( ( dbfTmpLin )->nNumLin ), ( dbfTmpLin )->( OrdKeyNo() ), nMode )

            ( D():PedidosProveedoresLineas( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmpLin )->( dbgotop() )

      /*
      A¤adimos desde el fichero de incidencias------------------------------------
      */

      if ( nMode != DUPL_MODE ) .and. ( D():PedidosProveedoresIncidencias( nView ) )->( dbSeek( nPedido ) )

         while ( ( D():PedidosProveedoresIncidencias( nView ) )->cSerPed + Str( ( D():PedidosProveedoresIncidencias( nView ) )->nNumPed ) + ( D():PedidosProveedoresIncidencias( nView ) )->cSufPed == nPedido ) .AND. ( D():PedidosProveedoresIncidencias( nView ) )->( !eof() )

            dbPass( D():PedidosProveedoresIncidencias( nView ), dbfTmpInc, .t. )

            ( D():PedidosProveedoresIncidencias( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmpInc )->( dbgotop() )

      /*
      A¤adimos desde el fichero de Documentos-------------------------------------
      */

      if ( nMode != DUPL_MODE ) .and. ( D():PedidosProveedoresDocumentos( nView ) )->( dbSeek( nPedido ) )

         while ( ( D():PedidosProveedoresDocumentos( nView ) )->cSerPed + Str( ( D():PedidosProveedoresDocumentos( nView ) )->nNumPed ) + ( D():PedidosProveedoresDocumentos( nView ) )->cSufPed == nPedido ) .AND. ( D():PedidosProveedoresDocumentos( nView ) )->( !eof() )

            dbPass( D():PedidosProveedoresDocumentos( nView ), dbfTmpDoc, .t. )

            ( D():PedidosProveedoresDocumentos( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmpDoc )->( dbgotop() )

      /*
      Cargamos los temporales de los campos extra---------------------------------
      */

      D():CamposExtraHeader( nView ):SetTemporal( aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aGet, aTmp, oBrw, nMode, oDlg )

   local oError
   local oBlock
   local aTabla
   local cSerie
   local nPedido
   local cSufijo
   local nNumLin
   local cNumPedCli

   if empty( aTmp[ _CSERPED ] )
      aTmp[ _CSERPED ]  := "A"
   end if

   // Comprobamos la fecha del documento---------------------------------------

   if !lValidaOperacion( aTmp[ _DFECPED ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERPED ] )
      Return .f.
   end if

   // Estos campos no pueden estar vacios--------------------------------------

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

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   oDlg:Disable()

   oMsgText( "Archivando" )

   // Guardamos datos -------------------------------------------------------

   nNumLin              := 1

   cSerie               := aTmp[ _CSERPED ]
   nPedido              := aTmp[ _NNUMPED ]
   cSufijo              := aTmp[ _CSUFPED ]
   cNumPedCli           := aTmp[ _CNUMPEDCLI ]

   aTmp[ _DFECCHG ]     := getSysDate()
   aTmp[ _CTIMCHG ]     := time()
   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTPED ]     := nTotPed

   // control de errores-------------------------------------------------------

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   beginTransaction()

   do case
   case isAppendOrDuplicateMode( nMode )

      oMsgText( "Obteniendo nuevo número" )

      nPedido           := aTmp[ _NNUMPED ]  := nNewDoc( cSerie, D():PedidosProveedores( nView ), "nPedPrv", , D():Contadores( nView ) )
      cSufijo           := aTmp[ _CSUFPED ]  := retSufEmp()

   case isEditMode( nMode ) .and. ( nPedido != 0 )

      oMsgText( "Eliminando registros anteriores" )

      PedidosProveedoresModel():deleteLineasById( cSerie, nPedido, cSufijo )

      PedidosProveedoresModel():deleteIncidenciasById( cSerie, nPedido, cSufijo )

      PedidosProveedoresModel():deleteDocumentosById( cSerie, nPedido, cSufijo )

   end case

   // Quitamos los filtros--------------------------------------------------------

   ( dbfTmpLin )->( dbClearFilter() )

   oMsgText( "Escribiendo lineas de pedidos" )

   oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )

   // Ahora escribimos en el fichero definitivo-----------------------------------

   ( dbfTmpLin )->( dbgotop() )
   while !( dbfTmpLin )->( eof() )

      if !( ( dbfTmpLin )->nUniCaja == 0 .and. ( dbfTmpLin )->lFromImp )
         dbPass( dbfTmpLin, D():PedidosProveedoresLineas( nView ), .t., cSerie, nPedido, cSufijo )
      end if

      D():CamposExtraLine( nView ):saveExtraField( cSerie + Str( nPedido ) + cSufijo + Str( ( dbfTmpLin )->nNumLin ), ( dbfTmpLin )->( ordkeyno() ) )

      ( dbfTmpLin )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   // Ahora escribimos en el fichero definitivo de incidencias--------------------

   oMsgText( "Escribiendo incidencias de pedidos" )

   oMsgProgress():SetRange( 0, ( dbfTmpInc )->( LastRec() ) )

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )

      dbPass( dbfTmpInc, D():PedidosProveedoresIncidencias( nView ), .t., cSerie, nPedido, cSufijo )

      ( dbfTmpInc )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   // Ahora escribimos en el fichero definitivo de documentos------------------

   oMsgText( "Escribiendo documentos de pedidos" )

   oMsgProgress():SetRange( 0, ( dbfTmpDoc )->( LastRec() ) )

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )

      dbPass( dbfTmpDoc, D():PedidosProveedoresDocumentos( nView ), .t., cSerie, nPedido, cSufijo )

      ( dbfTmpDoc )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   // Cargamos los temporales de los campos extra---------------------------------

   oMsgText( "Escribiendo campos extras de pedidos" )

   D():CamposExtraHeader( nView ):saveExtraField( cSerie + str( nPedido ) + cSufijo, "", nMode )

   // Salvamos el registro del pedido

   oMsgText( "Escribiendo pedido" )

   WinGather( aTmp, , D():PedidosProveedores( nView ), oBrw, nMode )

   // Ponemos el pedido en su estado

   oMsgText( "Actualizando estado del pedido" )

   D():Stocks( nView ):SetPedPrv( cSerie + str( nPedido ) + cSufijo )

   dbCommitAll()

   CommitTransaction()

   RECOVER USING oError
      RollBackTransaction()
      msgStop( "Imposible almacenar pedido" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )

   oMsgText()
   endProgress()

   oDlg:Enable()

   runEventScript( "PedidosProveedores\AfterSave", nView, cSerie, nPedido, cSufijo, nMode )

   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwLin )

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

   dbfErase( tmpPedidosLineas )
   dbfErase( tmpPedidosIncidencias )
   dbfErase( tmpPedidosDocumentos )

   /*
   Guardamos los posibles cambios en el browse---------------------------------
   */

   if oBrwLin != nil
      oBrwLin:CloseData()
   end if

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "PedProvT.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedProvT.Dbf", aSqlStruct( aItmPedPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedProvL.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedProvL.Dbf", aSqlStruct( aColPedPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedPrvI.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedPrvI.Dbf", aSqlStruct( aIncPedPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedPrvD.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedPrvD.Dbf", aSqlStruct( aPedPrvDoc() ), cLocalDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//
//
// Cambia el estado de un pedido
//

STATIC FUNCTION ChgState( oBrw )

   local nRec
   local nRecAlb
   local nOrdAlb
   local cNumPed
   local lQuit

   CursorWait()

   SysRefresh()

   if apoloMsgNoYes( "Al cambiar el estado perderá la referencia a cualquier documento que esté asociado.", "¿Desea cambiarlo?" )

      /*
      Cambia el estado del pedido----------------------------------------------
      */

      for each nRec in ( oBrw:aSelected )

         ( D():PedidosProveedores( nView ) )->( dbGoTo( nRec ) )

         lQuit                         := .f.

         cNumPed                       := ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView )  )->cSufPed

         /*
         Cambiamos el estado---------------------------------------------------
         */

         if dbLock( D():PedidosProveedores( nView ) )

            if ( D():PedidosProveedores( nView ) )->nEstado == 1
               ( D():PedidosProveedores( nView ) )->nEstado := 3
            else
               lQuit                   := .t.
               ( D():PedidosProveedores( nView ) )->nEstado := 1
               ( D():PedidosProveedores( nView ) )->cNumAlb := ""
            end if

            ( D():PedidosProveedores( nView ) )->( dbRUnlock() )

         end if

         if lQuit

            /*
            Borramos la referencia a cualquier cabecera de albarán asociado-------
            */

            nRecAlb  := ( D():AlbaranesProveedores( nView ) )->( RecNo() )
            nOrdAlb  := ( D():AlbaranesProveedores( nView ) )->( OrdSetFocus( "CNUMPED" ) )


            if ( D():AlbaranesProveedores( nView ) )->( dbSeek( cNumPed ) )

               while ( D():AlbaranesProveedores( nView ) )->cNumPed == cNumPed  .and. !( D():AlbaranesProveedores( nView ) )->( Eof() )

                  if dbLock( D():AlbaranesProveedores( nView ) )
                     ( D():AlbaranesProveedores( nView ) )->cNumPed    := ""
                     ( D():AlbaranesProveedores( nView ) )->( dbUnLock() )
                  end if

                  ( D():AlbaranesProveedores( nView ) )->( dbSkip() )

               end if

            end if

            ( D():AlbaranesProveedores( nView ) )->( OrdSetFocus( nOrdAlb ) )
            ( D():AlbaranesProveedores( nView ) )->( dbGoTo( nRecAlb ) )

            /*
            Borramos la referencia a cualquier linea de albarán asociado-------
            */

            nRecAlb  := ( D():AlbaranesProveedoresLineas( nView ) )->( RecNo() )
            nOrdAlb  := ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( "cCodPed" ) )

            if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( cNumPed ) )

               while ( D():AlbaranesProveedoresLineas( nView ) )->cCodPed == cNumPed  .and. !( D():AlbaranesProveedoresLineas( nView ) )->( Eof() )

                  if dbLock( D():AlbaranesProveedoresLineas( nView ) )
                     ( D():AlbaranesProveedoresLineas( nView ) )->cCodPed    := ""
                     ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnLock() )
                  end if

                  ( D():AlbaranesProveedoresLineas( nView ) )->( dbSkip() )

               end if

            end if

            ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( nOrdAlb ) )
            ( D():AlbaranesProveedoresLineas( nView ) )->( dbGoTo( nRecAlb ) )

         end if

      next

    end if

    oBrw:Refresh()
    oBrw:SetFocus()

   CursorArrow()
   SysRefresh()

RETURN NIL

//-------------------------------------------------------------------------//

Static Function lNotOpen()

   if NetErr()
      msgStop( "Imposible abrir ficheros." )
      CloseFiles()
      return .t.
   end if

return .f.

//---------------------------------------------------------------------------//

static function lGenPed( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if empty( oBtn )
      return nil
   end if

   if !( D():Documentos( nView ) )->( dbSeek( "PP" ) )

      DEFINE BTNSHELL RESOURCE "gc_document_white_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay pedidos de proveedores predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ( D():Documentos( nView ) )->cTipo == "PP" .and. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenPed( nDevice, "Imprimiendo pedidos de proveedores", ( D():Documentos( nView ) )->CODIGO )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      end do

   end if

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenPed( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   if nDev == IS_PRINTER
      bGen     := {|| GenPedPrv( nDevice, cTit, cCod ) }
   else
      bGen     := {|| GenPedPrv( nDevice, cTit, cCod ) }
   end if

return bGen

//---------------------------------------------------------------------------//

STATIC FUNCTION QuiPedPrv( lDetail )

   local cPedido

   DEFAULT lDetail   := .t.

   if ( D():PedidosProveedores( nView ) )->lCloPed .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar los pedidos cerrados los administradores." )
      Return .f.
   end if

   CursorWait()

   cPedido           := ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed

   if lDetail
      DelDetalle( cPedido )
   end if

   /*
   Actualizamos el estado del campo generado-----------------------------------
   */

   if !empty( ( D():PedidosProveedores( nView ) )->cNumPedCli )
      D():Stocks( nView ):SetGeneradoPedCli( ( D():PedidosProveedores( nView ) )->cNumPedCli )
   end if

   CursorWe()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function DelDetalle( cPedido )

   local nOrdAnt

   DEFAULT cPedido  := ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed

   CursorWait()

   nOrdAnt           := ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( "nNumPed" ) )

   while ( D():PedidosProveedoresLineas( nView ) )->( dbSeek( cPedido ) ) .and. !( D():PedidosProveedoresLineas( nView ) )->( eof() )
      if dbDialogLock( D():PedidosProveedoresLineas( nView ) )
         ( D():PedidosProveedoresLineas( nView ) )->( dbDelete() )
         ( D():PedidosProveedoresLineas( nView ) )->( dbUnLock() )
      end if
   end do

   ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )

   while ( D():PedidosProveedoresIncidencias( nView ) )->( dbSeek( cPedido ) .and. !( D():PedidosProveedoresIncidencias( nView ) )->( eof() ) )
      if dbLock( D():PedidosProveedoresIncidencias( nView ) )
         ( D():PedidosProveedoresIncidencias( nView ) )->( dbDelete() )
         ( D():PedidosProveedoresIncidencias( nView ) )->( dbUnLock() )
      end if
   end while

   while ( D():PedidosProveedoresDocumentos( nView ) )->( dbSeek( cPedido ) .and. !( D():PedidosProveedoresDocumentos( nView ) )->( eof() ) )
      if dbLock( D():PedidosProveedoresDocumentos( nView ) )
         ( D():PedidosProveedoresDocumentos( nView ) )->( dbDelete() )
         ( D():PedidosProveedoresDocumentos( nView ) )->( dbUnLock() )
      end if
   end while

   CursorWe()

RETURN NIL

//---------------------------------------------------------------------------//

Static Function mSer2Mem( aNumSer, nTotUnd )

   local n
   local mNumSer     := ""

   for n := 1 to nTotUnd
      mNumSer        += AllTrim( aNumSer[ n ] ) + ","
   next

Return ( mNumSer )

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

Static Function TrazaPedidoProveedor( cNumDoc )

   local oDlg
   local oTree

   DEFINE DIALOG oDlg RESOURCE "TrazaDocumentos"

      oTree          := TTreeView():Redefine( 100, oDlg  )

      REDEFINE BUTTON ;
         ID       560 ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       561 ;
			OF 		oDlg ;
			ACTION	( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
         ON INIT  ( InitTrazaPedidoProveedor( cNumDoc, oTree ) );
         CENTER

Return nil

//---------------------------------------------------------------------------//

Static Function InitTrazaPedidoProveedor( cNumDoc, oTree )

   local n
   local aDocumentsPedidoProveedor  := aDocumentsPedidoProveedor( cNumDoc )

   for n := 1 to len( aDocumentsPedidoProveedor )
      oTree:Add(  aDocumentsPedidoProveedor[ n, 1 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 2 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 3 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 4 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 5 ] )
   next

Return ( aDocumentsPedidoProveedor )

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumPed )

   local nEstado  := 0

   if ( D():PedidosProveedoresIncidencias( nView ) )->( dbSeek( cNumPed ) )

      while ( D():PedidosProveedoresIncidencias( nView ) )->cSerPed + Str( ( D():PedidosProveedoresIncidencias( nView ) )->nNumPed ) + ( D():PedidosProveedoresIncidencias( nView ) )->cSufPed == cNumPed .and. !( D():PedidosProveedoresIncidencias( nView ) )->( Eof() )

         if ( D():PedidosProveedoresIncidencias( nView ) )->lListo
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

         ( D():PedidosProveedoresIncidencias( nView ) )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

/*
Botón anterior
*/

Static Function BtnAnt( oPag, oBtnNxt, oBtnAnt )

   if oPag:nOption == 2

      /*
      Vacia la temporal para añadirle nuevos registros-------------------------
      */

      ( dbfTmpArt )->( __dbZap() )
      oPag:GoPrev()
      SetWindowText( oBtnNxt:hWnd, "Siguien&te >" )

      oBtnAnt:Hide()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Botón siguiente
*/

static function BtnNxt( oPag, oBtnNxt, oBtnAnt, oDlg, oProvee, cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, oMtr, oBrw, cCodAlm )

   do case
      case oPag:nOption == 1

         /*
         Comprueba que eliga un proveedor
         */

         if empty( cProvee )
            MsgStop( "Tiene que seleccionar un proveedor para generar el pedido" )
            oProvee:SetFocus()
            Return .f.
         end if

         /*
         Llena la temporal con los artículos que cumplen las condiciones deseadas
         */

         LlenaTemporal( cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, cCodAlm, oMtr )

         oBrw:Refresh()

         oPag:GoNext()

         oBtnAnt:Show()

         SetWindowText( oBtnNxt:hWnd, "&Terminar" )

      case oPag:nOption == 2

         /*
         Crea el pedido a proveedor
         */

         CreaPedido( cProvee, cCodAlm )

         /*
         Elimina las temporales
         */

         KillTemporal()

         oDlg:end( IDOK )

   end case

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Crea las bases de datos temporales que usaremos
*/

Static Function CreaTemporal()

   local cDbfArt  := "PArt"
   local cDbfPed  := "PPed"

   cTmpArt        := cGetNewFileName( cPatTmp() + cDbfArt )
   cTmpPed        := cGetNewFileName( cPatTmp() + cDbfPed )

   dbCreate( cTmpArt, aSqlStruct( aColTmpArt() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpArt, cCheckArea( cDbfArt, @dbfTmpArt ), .f. )
   if !( dbfTmpArt )->( neterr() )
      ( dbfTmpArt )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpArt )->( ordCreate( cTmpArt, "cRef", "cRef", {|| Field->cRef } ) )
   end if

   dbCreate( cTmpPed, aSqlStruct( aColPedPrv() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpPed, cCheckArea( cDbfPed, @dbfTmpLin ), .f. )
   if !( dbfTmpLin )->( neterr() )
      ( dbfTmpLin )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpLin )->( ordCreate( cTmpPed, "cRef", "cRef", {|| Field->cRef } ) )
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Llena la temporal con los artículos que cumplen las condiciones deseadas
*/

Static Function LlenaTemporal( cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, cCodAlm, oMtr )

   local nStkFisico
   local nStkDisponible
   local nStkMinimo
   local nStkMaximo

   ( D():Articulos( nView ) )->( dbGoTop() )

   while !( D():Articulos( nView ) )->( Eof() )

      nStkFisico                    := D():Stocks( nView ):nTotStockAct( ( D():Articulos( nView ) )->Codigo, , , , , ( D():Articulos( nView ) )->lKitArt, ( D():Articulos( nView ) )->nKitStk )
      nStkDisponible                := nStkFisico - nReservado( ( D():Articulos( nView ) )->Codigo )
      nStkMinimo                    := nStockMinimo( ( D():Articulos( nView ) )->Codigo, cCodAlm, nView )
      nStkMaximo                    := nStockMaximo( ( D():Articulos( nView ) )->Codigo, cCodAlm, nView )

      if ( D():Articulos( nView ) )->cPrvHab == cProvee .and.;
         ( D():Articulos( nView ) )->Codigo >= cArtOrg  .and.;
         ( D():Articulos( nView ) )->Codigo <= cArtDes

         do case
            case nStockDis == 1 .and. nStkDisponible < 0
               
               AppTemporal( nStockFin, nStkFisico, nStkDisponible, nStkMinimo, nStkMaximo )

            case nStockDis == 2 .and. nStkDisponible <= 0
               
               AppTemporal( nStockFin, nStkFisico, nStkDisponible, nStkMinimo, nStkMaximo )

            case nStockDis == 3 .and. nStkDisponible < nStkMinimo
               
               AppTemporal( nStockFin, nStkFisico, nStkDisponible, nStkMinimo, nStkMaximo )

            otherwise
               
               AppTemporal( nStockFin, nStkFisico, nStkDisponible, nStkMinimo, nStkMaximo )

         end case

      end if

      ( D():Articulos( nView ) )->( dbSkip() )

      oMtr:Set( ( D():Articulos( nView ) )->( OrdKeyNo() ) )

   end while

   oMtr:Set( 0 )

   ( dbfTmpArt )->( dbGoTop() )

Return nil

//---------------------------------------------------------------------------//
/*
Hace el append a la temporal
*/

static function AppTemporal( nStockFin, nStkFisico, nStkDisponible, nStkMinimo, nStkMaximo )

   ( dbfTmpArt )->( dbAppend() )

   ( dbfTmpArt )->cRef                 := ( D():Articulos( nView ) )->Codigo
   ( dbfTmpArt )->cDetalle             := ( D():Articulos( nView ) )->Nombre
   ( dbfTmpArt )->nStkFis              := nStkFisico
   ( dbfTmpArt )->nStkDis              := nStkDisponible

   do case
      case nStockFin == 1

         if nStkMinimo != 0
            ( dbfTmpArt )->nObjUni     := nStkMinimo
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( nStkMinimo )
            ( dbfTmpArt )->lSelArt     := nCalculaUnidades( nStkMinimo ) != 0
         
         else

            ( dbfTmpArt )->nObjUni     := 1
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( 1 )
            ( dbfTmpArt )->lSelArt     := nCalculaUnidades( 1 ) != 0

         end if
      
      case nStockFin == 2

         if nStkMaximo != 0

            ( dbfTmpArt )->nObjUni     := nStkMaximo
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( nStkMaximo )
            ( dbfTmpArt )->lSelArt     := nCalculaUnidades( nStkMaximo ) != 0

         else

            ( dbfTmpArt )->nObjUni     := 1
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( 1 )
            ( dbfTmpArt )->lSelArt     := nCalculaUnidades( 1 ) != 0

         end if

   end case

return ( nil )

//---------------------------------------------------------------------------//
/*
Destruye las bases de datos temporales
*/

Static Function KillTemporal()

   if !empty( dbfTmpArt ) .and. ( dbfTmpArt )->( Used() )
      ( dbfTmpArt )->( dbCloseArea() )
   end if

   if !empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   dbfErase( cTmpArt )
   dbfErase( cTmpPed )

Return nil

//---------------------------------------------------------------------------//
/*Campos que tiene que tener la temporal de artículos*/

Static Function aColTmpArt()

   local aColTmpArt  := {}

      aAdd( aColTmpArt, { "CREF",    "C",   18,  0, "Referencia del artículo",         "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "CDETALLE","C",  250,  0, "Nombre del artículo",             "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "LSELART", "L",    1,  0, "Lógico de selección de artículo", "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NNUMUNI", "N",   16,  6, "Unidades pedidas",                "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NOBJUNI", "N",   16,  6, "Objetivo a llegar",               "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NSTKFIS", "N",   16,  6, "Stock fisico",                    "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NSTKDIS", "N",   16,  6, "Stock disponible",                "",  "", "( cDbfCol )" } )

return ( aColTmpArt )

//---------------------------------------------------------------------------//
/*
Selecciona o deselecciona el artículo que tengamos marcado en el browse
*/

Static Function SelArt( dbfTmpArt, oBrw )

   ( dbfTmpArt )->lSelArt := !( dbfTmpArt )->lSelArt

   oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//
/*Selecciona o deselecciona todos los artículos de browse*/

static function SelAllArt( dbfTmpArt, oBrw, lSel )

   local nRec  := ( dbfTmpArt )->( Recno() )

   ( dbfTmpArt )->( dbGoTop() )
   while !( dbfTmpArt )->( eof() )

      ( dbfTmpArt )->lSelArt := lSel

      ( dbfTmpArt )->( dbSkip() )

   end while

   ( dbfTmpArt )->( dbGoTo( nRec ) )

   oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//
/*Devuelve el total de unidades reservadas del artículo*/

Static Function nReservado( cCodArt )

   local nTotal := 0

   ( D():PedidosClientesReservas( nView ) )->( dbGoTop() )

   ( D():PedidosClientesReservas( nView ) )->( OrdSetFocus( "cRef" ) )

   if ( D():PedidosClientesReservas( nView ) )->( dbSeek( cCodArt ) )

      while ( D():PedidosClientesReservas( nView ) )->cRef == cCodArt .and. !( D():PedidosClientesReservas( nView ) )->( Eof() )

         nTotal += nUnidadesReservadasEnPedidosCliente( D():PedidosClientesReservasId( nView ), ( D():PedidosClientesReservas( nView ) )->cRef, ( D():PedidosClientesReservas( nView ) )->cValPr1, ( D():PedidosClientesReservas( nView ) )->cValPr2, D():PedidosClientesReservas( nView ) )

      ( D():PedidosClientesReservas( nView ) )->( dbSkip() )

      end while

   end if

return ( nTotal )

//---------------------------------------------------------------------------//
/*Creamos el pedido*/

Static Function CreaPedido( cCodPrv, cCodAlm )

   local cSeriePedido
   local nNumeroPedido
   local cSufijoPedido

   /*Metemos las lineas en una temporal
     para controlar que no cree un pedido
     sin líneas o con unidades 0 */

   AppTemPedL( cCodAlm )

   if !( dbfTmpLin )->( Eof() )

      //--creo la cabecera del pedido--//

      ( D():Proveedores( nView ) )->( dbSeek( cCodPrv ) )

      //--recogo la serie, número, y sufijo del documento--//

      cSeriePedido               := cNewSer( "NPEDPRV" )
      nNumeroPedido              := nNewDoc( cSeriePedido, D():PedidosProveedores( nView ), "NPEDPRV" )
      cSufijoPedido              := RetSufEmp()

      ( D():PedidosProveedores( nView ) )->( dbAppend())
      ( D():PedidosProveedores( nView ) )->cSerPed    := cSeriePedido
      ( D():PedidosProveedores( nView ) )->nNumPed    := nNumeroPedido
      ( D():PedidosProveedores( nView ) )->cSufPed    := cSufijoPedido
      ( D():PedidosProveedores( nView ) )->cTurPed    := cCurSesion()
      ( D():PedidosProveedores( nView ) )->dFecPed    := GetSysDate()
      ( D():PedidosProveedores( nView ) )->cCodPrv    := cCodPrv
      if !empty( cCodAlm )
         ( D():PedidosProveedores( nView ) )->cCodAlm := cCodAlm
      else
         ( D():PedidosProveedores( nView ) )->cCodAlm := cDefAlm()
      end if
      ( D():PedidosProveedores( nView ) )->cCodCaj    := oUser():cCaja()
      ( D():PedidosProveedores( nView ) )->cNomPrv    := ( D():Proveedores( nView ) )->Titulo
      ( D():PedidosProveedores( nView ) )->cDirPrv    := ( D():Proveedores( nView ) )->Domicilio
      ( D():PedidosProveedores( nView ) )->cPobPrv    := ( D():Proveedores( nView ) )->Poblacion
      ( D():PedidosProveedores( nView ) )->cProPrv    := ( D():Proveedores( nView ) )->Provincia
      ( D():PedidosProveedores( nView ) )->cPosPrv    := ( D():Proveedores( nView ) )->CodPostal
      ( D():PedidosProveedores( nView ) )->cDniPrv    := ( D():Proveedores( nView ) )->Nif
      ( D():PedidosProveedores( nView ) )->dFecEnt    := GetSysDate() + ( D():Proveedores( nView ) )->nPlzEnt
      ( D():PedidosProveedores( nView ) )->nEstado    := 1
      ( D():PedidosProveedores( nView ) )->cDivPed    := cDivEmp()
      ( D():PedidosProveedores( nView ) )->nVdvPed    := nChgDiv( cDivEmp(), D():Divisas( nView ) )
      ( D():PedidosProveedores( nView ) )->lSndDoc    := .t.
      ( D():PedidosProveedores( nView ) )->cCodUsr    := cCurUsr()
      ( D():PedidosProveedores( nView ) )->( dbRUnLock() )

      /*
      Añado las lineas del pedido----------------------------------------------
      */

      while !( dbfTmpLin )->( Eof() )

         ( D():PedidosProveedoresLineas( nView ) )->( dbAppend() )

         ( D():PedidosProveedoresLineas( nView ) )->cSerPed          := cSeriePedido
         ( D():PedidosProveedoresLineas( nView ) )->nNumPed          := nNumeroPedido
         ( D():PedidosProveedoresLineas( nView ) )->cSufPed          := cSufijoPedido
         ( D():PedidosProveedoresLineas( nView ) )->cRef             := ( dbfTmpLin )->cRef
         ( D():PedidosProveedoresLineas( nView ) )->cDetalle         := ( dbfTmpLin )->cDetalle
         ( D():PedidosProveedoresLineas( nView ) )->nIva             := ( dbfTmpLin )->nIva
         ( D():PedidosProveedoresLineas( nView ) )->nReq             := ( dbfTmpLin )->nReq
         ( D():PedidosProveedoresLineas( nView ) )->nCanPed          := ( dbfTmpLin )->nCanPed
         ( D():PedidosProveedoresLineas( nView ) )->nUniCaja         := ( dbfTmpLin )->nUniCaja
         ( D():PedidosProveedoresLineas( nView ) )->cUniDad          := ( dbfTmpLin )->cUniDad
         ( D():PedidosProveedoresLineas( nView ) )->nPreDiv          := ( dbfTmpLin )->nPreDiv
         ( D():PedidosProveedoresLineas( nView ) )->lLote            := ( dbfTmpLin )->lLote
         ( D():PedidosProveedoresLineas( nView ) )->nLote            := ( dbfTmpLin )->nLote
         ( D():PedidosProveedoresLineas( nView ) )->cLote            := ( dbfTmpLin )->cLote
         ( D():PedidosProveedoresLineas( nView ) )->cAlmLin          := ( dbfTmpLin )->cAlmLin

         ( D():PedidosProveedoresLineas( nView ) )->( dbRUnLock() )

      ( dbfTmpLin )->( dbSkip() )

      end while

      MsgInfo( "El pedido a proveedores " + AllTrim( cSeriePedido ) + "/" + AllTrim( Str( nNumeroPedido ) ) + "/" + AllTrim( cSufijoPedido ) + " se ha creado satisfactoriamente", "Información" )

   else

      MsgInfo( "No hay líneas para crear su pedido", "Información" )

   end if

return nil

//---------------------------------------------------------------------------//
/*Calcula las unidades a pedir*/

Static function nCalculaUnidades( nObjetivo )

   local nUnidades := 0

   do case
      case ( dbfTmpArt )->nStkFis <= 0
         nUnidades   := Abs( ( dbfTmpArt )->nStkFis ) + nObjetivo
      case ( dbfTmpArt )->nStkFis > 0 .and. ( dbfTmpArt )->nStkFis < nObjetivo
         nUnidades   := nObjetivo - ( dbfTmpArt )->nStkFis
      case ( dbfTmpArt )->nStkFis > 0 .and. ( dbfTmpArt )->nStkFis > nObjetivo
         nUnidades   := 0
   end case

Return ( nUnidades )

//---------------------------------------------------------------------------//

/*Añade en la temporal de lineas de pedidos*/

Static Function AppTemPedL( cCodAlm )

   ( dbfTmpArt )->( dbGoTop() )

   while !( dbfTmpArt )->( Eof() )

      ( D():Articulos( nView ) )->( dbGotop() )
      ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpArt )->cRef ) )
      ( D():TiposIva( nView ) )->( dbSeek( ( D():Articulos( nView ) )->TipoIva ) )

      if ( dbfTmpArt )->lSelArt .and. ( dbfTmpArt )->nNumUni != 0

         ( dbfTmpLin )->( dbAppend() )
         ( dbfTmpLin )->cRef             := ( dbfTmpArt )->cRef
         ( dbfTmpLin )->cDetalle         := ( dbfTmpArt )->cDetalle
         ( dbfTmpLin )->nIva             := ( D():TiposIva( nView ) )->TPIva
         ( dbfTmpLin )->nReq             := ( D():TiposIva( nView ) )->nRecEq
         ( dbfTmpLin )->nCanPed          := 1
         ( dbfTmpLin )->nUniCaja         := ( dbfTmpArt )->nNumUni
         ( dbfTmpLin )->cUniDad          := ( D():Articulos( nView ) )->cUniDad
         ( dbfTmpLin )->nPreDiv          := ( D():Articulos( nView ) )->pCosto
         ( dbfTmpLin )->lLote            := ( D():Articulos( nView ) )->lLote
         ( dbfTmpLin )->nLote            := ( D():Articulos( nView ) )->nLote
         ( dbfTmpLin )->cLote            := ( D():Articulos( nView ) )->cLote

         if !empty( cCodAlm )
            ( dbfTmpLin )->cAlmLin       := cCodAlm
         else
            ( dbfTmpLin )->cAlmLin       := cDefAlm()
         end if

         ( dbfTmpLin )->( dbRUnLock() )

      end if

   ( dbfTmpArt )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if D():UnidadMedicion( nView ):oDbf:Seek( aTmp[ _CUNIDAD ] )

         if D():UnidadMedicion( nView ):oDbf:nDimension >= 1 .and. !empty( D():UnidadMedicion( nView ):oDbf:cTextoDim1 )
            if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( D():UnidadMedicion( nView ):oDbf:cTextoDim1 )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if D():UnidadMedicion( nView ):oDbf:nDimension >= 2 .and. !empty( D():UnidadMedicion( nView ):oDbf:cTextoDim2 )
            if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( D():UnidadMedicion( nView ):oDbf:cTextoDim2 )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if D():UnidadMedicion( nView ):oDbf:nDimension >= 3 .and. !empty( D():UnidadMedicion( nView ):oDbf:cTextoDim3 )
            if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( D():UnidadMedicion( nView ):oDbf:cTextoDim3 )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.
//---------------------------------------------------------------------------//

Static Function nTotRecibido( dbfLin )

   local nTotRec
   local nTotUni
   local nEstado     := 1

   nTotRec           := nUnidadesRecibidasPedPrv( ( dbfLin )->cSerPed + Str( ( dbfLin )->nNumPed ) + ( dbfLin )->cSufPed, ( dbfLin )->cRef, ( dbfLin )->cValPr1, ( dbfLin )->cValPr2, ( dbfLin )->cRefPrv, D():AlbaranesProveedoresLineas( nView ) )
   nTotUni           := nTotNPedPrv( dbfLin )

   do case
      case nTotRec == 0
         nEstado     := 1
      case nTotRec < nTotUni
         nEstado     := 2
      case nTotRec >= nTotUni
         nEstado     := 3
   end case

RETURN ( nEstado )

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Pedidos", ( D():PedidosProveedores( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Pedidos", cItemsToReport( aItmPedPrv() ) )

   ( D():PedidosProveedoresLineas( nView ) )->( ordsetfocus( "cCodFam" ) )
   oFr:SetWorkArea(     "Lineas de pedidos", ( D():PedidosProveedoresLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de pedidos", cItemsToReport( aColPedPrv() ) )

   oFr:SetWorkArea(     "Incidencias de pedidos", ( D():PedidosProveedoresIncidencias( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de pedidos", cItemsToReport( aIncPedPrv() ) )

   oFr:SetWorkArea(     "Documentos de pedidos", ( D():PedidosProveedoresDocumentos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de pedidos", cItemsToReport( aPedPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Usuarios", ( D():Usuarios( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Familias", ( D():Familias( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Familias", cItemsToReport( aItmFam() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():UnidadMedicion( nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():UnidadMedicion( nView ):oDbf ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( nView ):oDbf ) )

   oFr:SetMasterDetail( "Pedidos", "Lineas de pedidos",        {|| ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Incidencias de pedidos",   {|| ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Documentos de pedidos",    {|| ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Proveedor",                {|| ( D():PedidosProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Pedidos", "Almacenes",                {|| ( D():PedidosProveedores( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Pedidos", "Formas de pago",           {|| ( D():PedidosProveedores( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Pedidos", "Usuarios",                 {|| ( D():PedidosProveedores( nView ) )->cCodUsr } )
   oFr:SetMasterDetail( "Pedidos", "Empresa",                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Pedidos", "Clientes",                 {|| GetCodCli( ( D():PedidosProveedores( nView ) )->cNumPedCli ) } )

   oFr:SetMasterDetail( "Lineas de pedidos", "Artículos",               {|| ( D():PedidosProveedoresLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Familias",                {|| ( D():PedidosProveedoresLineas( nView ) )->cCodFam } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Código de proveedores",   {|| ( D():PedidosProveedores( nView ) )->cCodPrv + ( D():PedidosProveedoresLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Unidades de medición",    {|| ( D():PedidosProveedoresLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Impuestos especiales",    {|| ( D():PedidosProveedoresLineas( nView ) )->cCodImp } )

   oFr:SetResyncPair(   "Pedidos", "Lineas de pedidos" )
   oFr:SetResyncPair(   "Pedidos", "Incidencias de pedidos" )
   oFr:SetResyncPair(   "Pedidos", "Documentos de pedidos" )
   oFr:SetResyncPair(   "Pedidos", "Empresa" )
   oFr:SetResyncPair(   "Pedidos", "Proveedor" )
   oFr:SetResyncPair(   "Pedidos", "Almacenes" )
   oFr:SetResyncPair(   "Pedidos", "Formas de pago" )
   oFr:SetResyncPair(   "Pedidos", "Usuarios" )
   oFr:SetResyncPair(   "Pedidos", "Clientes" )

   oFr:SetResyncPair(   "Lineas de pedidos", "Artículos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Familias" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Código de proveedores" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Impuestos especiales" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Pedidos" )
   oFr:DeleteCategory(  "Lineas de pedidos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Pedidos",             "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Pedidos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Pedidos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Pedidos",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Pedidos",             "Total impuestos especiales",          "GetHbVar('nTotIvm')" )
   oFr:AddVariable(     "Pedidos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Pedidos",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Pedidos",             "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Pedidos",             "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Pedidos",             "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Pedidos",             "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Lineas de pedidos",   "Detalle del artículo",                "CallHbFunc('cDesPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Detalle del artículo otro lenguaje",  "CallHbFunc('cDesPedPrvLeng')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total unidades artículo",             "CallHbFunc('nTotNPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Precio unitario del artículo",        "CallHbFunc('nTotUPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total línea de pedido",               "CallHbFunc('nTotLPedPrv')" )

   oFr:AddVariable(     "Lineas de pedidos",   "Nombre primera propiedad",            "CallHbFunc('nombrePrimeraPropiedad')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Nombre segunda propiedad",            "CallHbFunc('nombreSegundaPropiedad')" )

Return nil

//---------------------------------------------------------------------------//

Static Function MailingReport( oFr )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Pedidos",             "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Pedidos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Pedidos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Pedidos",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Pedidos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Pedidos",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Pedidos",             "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Pedidos",             "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Pedidos",             "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Pedidos",             "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Lineas de pedidos",   "Detalle del artículo",                "CallHbFunc('cDesPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total unidades artículo",             "CallHbFunc('nTotNPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Precio unitario del artículo",        "CallHbFunc('nTotUPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total línea de pedido",               "CallHbFunc('nTotLPedPrv')" )

Return nil

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecPed ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//---------------------------------------------------------------------------//

Static Function CargaComprasProveedor( aTmp, oImportaComprasProveedor, oDlg )

      local nOrd
      local nPreCom
      local nConsumo    := 0
      local nConsumoDia := 0
      local dFecIni     := oImportaComprasProveedor:oFechaInicio:Value()
      local dFecFin     := oImportaComprasProveedor:oFechaFin:Value() 
      local nPorcentaje := oImportaComprasProveedor:oPorcentaje:Value()
      local nDias       := dFecFin - dFecIni

      if empty( aTmp[ _CCODPRV ] )
            msgStop( "Código del proveedor no puede esta vacio.")
            return .f.
      end if

      AutoMeterDialog( oDlg )

      SetTotalAutoMeterDialog( ( D():Articulos( nView ) )->( LastRec() ) )

      CursorWait()

      nOrd        := ( D():Articulos( nView ) )->( ordSetFocus( "cPrvHab" ) )

      if ( D():Articulos( nView ) )->( dbSeek( aTmp[ _CCODPRV ] ) )

         while ( D():Articulos( nView ) )->cPrvHab == aTmp[ _CCODPRV ] .and. !( D():Articulos( nView ) )->( eof() )

            if !dbSeekInOrd( ( D():Articulos( nView ) )->Codigo, "cRef", dbfTmpLin ) .and. !( D():Articulos( nView ) )->lObs 

                  ( dbfTmpLin )->( dbAppend() )

                  ( dbfTmpLin )->nNumLin        := nLastNum( dbfTmpLin )                  
                  ( dbfTmpLin )->cRef           := ( D():Articulos( nView ) )->Codigo
                  ( dbfTmpLin )->cDetalle       := ( D():Articulos( nView ) )->Nombre      
                  ( dbfTmpLin )->nIva           := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
                  ( dbfTmpLin )->nReq           := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
                  ( dbfTmpLin )->cAlmLin        := aTmp[ _CCODALM ]
                  ( dbfTmpLin )->lFromImp       := .t.

                  if ( D():Articulos( nView ) )->nCajEnt != 0
                        ( dbfTmpLin )->nCanPed  := ( D():Articulos( nView ) )->nCajEnt 
                  end if

                  if ( D():Articulos( nView ) )->nUniCaja != 0
                        ( dbfTmpLin )->nUniCaja := ( D():Articulos( nView ) )->nUniCaja 
                  end if

                  if ( D():Articulos( nView ) )->lLote  
                        ( dbfTmpLin )->cLote    := ( D():Articulos( nView ) )->cLote
                  end if 

                  /*
                  Tratamientos kits-----------------------------------------------------
                  */

                  ( dbfTmpLin )->nCtlStk  := ( D():Articulos( nView ) )->nCtlStock

                  if ( D():Articulos( nView ) )->lKitArt
                  
                        ( dbfTmpLin )->lKitArt  := ( D():Articulos( nView ) )->lKitArt                        // Marcamos como padre del kit
                        ( dbfTmpLin )->lImpLin  := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto
                        ( dbfTmpLin )->lKitPrc  := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto

                        if lStockCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )
                              ( dbfTmpLin )->nCtlStk  := ( D():Articulos( nView ) )->nCtlStock
                        else
                              ( dbfTmpLin )->nCtlStk  := STOCK_NO_CONTROLAR // No controlar Stock
                        end if

                  end if 

                  /*
                  Buscamos la familia del articulo y anotamos las propiedades--------
                  */

                  ( dbfTmpLin )->cCodPr1        := ( D():Articulos( nView ) )->cCodPrp1
                  ( dbfTmpLin )->cCodPr2        := ( D():Articulos( nView ) )->cCodPrp2

                  /*
                  Precios de compra--------------------------------------------------
                  */

                  nPreCom                       := nComPro( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr2, D():ArticuloPrecioPropiedades( nView ) )
                  if nPrecom  != 0
                        ( dbfTmpLin )->nPreDiv  := nPreCom
                  end if

                  if uFieldEmpresa( "lCosPrv", .f. )
                        nPreCom                 := nPrecioReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, D():ProveedorArticulo( nView ) )
                  end if

                  if nPreCom != 0
                        ( dbfTmpLin )->nPreDiv  := nPreCom
                  else
                        ( dbfTmpLin )->nPreDiv  := nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmp[ _CDIVPED ], D():Divisas( nView ) )
                  end if

                  /*
                  Descuento de articulo----------------------------------------------
                  */

                  if uFieldEmpresa( "lCosPrv", .f. )

                        nPreCom     := nDescuentoReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, D():ProveedorArticulo( nView ) )
                        if nPreCom != 0
                              ( dbfTmpLin )->nDtoLin  := nPreCom 
                        end if

                        /*
                        Descuento de promocional-------------------------------
                        */

                        nPreCom     := nPromocionReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, D():ProveedorArticulo( nView ) )
                        if nPreCom != 0
                              ( dbfTmpLin )->nDtoPrm  := nPreCom
                        end if

                  end if

                  /*
                  Recogemos las familias y los grupos de familias--------------------
                  */
      
                  ( dbfTmpLin )->cCodFam        := ( D():Articulos( nView ) )->Familia
                  ( dbfTmpLin )->cGrpFam        := cGruFam( ( D():Articulos( nView ) )->Familia, D():Familias( nView ) )

                  /*
                  Ponemos el precio de venta recomendado-----------------------------
                  */
      
                  ( dbfTmpLin )->nPvpRec        := ( D():Articulos( nView ) )->PvpRec
                  ( dbfTmpLin )->cUnidad        := ( D():Articulos( nView ) )->cUnidad
                  ( dbfTmpLin )->nStkMin        := nStockMinimo( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cAlmLin, nView )

                  // Valores del stock-----------------------------------------

                  D():Stocks( nView ):aStockArticulo( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cAlmLin )

                  ( dbfTmpLin )->nStkAct        := D():Stocks( nView ):nUnidadesInStock()
                  ( dbfTmpLin )->nPdtRec        := D():Stocks( nView ):nPendientesRecibirInStock()

                  // Consumo de producto entre dos fechas----------------------

                  nConsumo                      := D():Stocks( nView ):nConsumoArticulo( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cAlmLin, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, ( dbfTmpLin )->cLote, dFecIni, dFecFin )

                  if !empty( nConsumo )
                        
                        ( dbfTmpLin )->nConRea  := nConsumo

                        // Aplicamos el incremento-----------------------------

                        nConsumoDia             := nConsumo + ( nConsumo * nPorcentaje / 100 )
                        nConsumoDia             := nConsumoDia / nDias

                        ( dbfTmpLin )->nConSem  := Round( nConsumoDia * 7, 0 ) 
                        ( dbfTmpLin )->nConQui  := Round( nConsumoDia * 15, 0 ) 
                        ( dbfTmpLin )->nConMes  := Round( nConsumoDia * 30, 0 ) 

                  end if 

                  ( dbfTmpLin )->( dbUnlock() )

            end if

            SetAutoMeterDialog( ( D():Articulos( nView ) )->( Recno() ) )

            ( D():Articulos( nView ) )->( dbSkip() )

            end while
      
      end if 

      EndAutoMeterDialog( oDlg )

      ( D():Articulos( nView ) )->( ordSetFocus( nOrd ) )

      ( dbfTmpLin )->( dbGoTop() )

      CursorWE()

Return .t. 

//---------------------------------------------------------------------------//

Static Function CalculaComprasProveedor( aTmp, oBrwLin, oImportaComprasProveedor )

      local nRec
      local nConsumo    := 0
      local nConsumoDia := 0
      local dFecIni     := oImportaComprasProveedor:oFechaInicio:Value()
      local dFecFin     := oImportaComprasProveedor:oFechaFin:Value() 
      local nPorcentaje := oImportaComprasProveedor:oPorcentaje:Value()
      local nDias       := dFecFin - dFecIni

      CursorWait()

      nRec              := ( dbfTmpLin )->( RecNo() )

      ( dbfTmpLin )->( dbGoTop() )
      while !( dbfTmpLin )->( eof() )

            /*
            Ponemos el stock---------------------------------------------------
            */

            if ( dbfTmpLin )->( dbRLock() )

                  D():Stocks( nView ):aStockArticulo( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cAlmLin )

                  ( dbfTmpLin )->nStkAct        := D():Stocks( nView ):nUnidadesInStock()
                  ( dbfTmpLin )->nPdtRec        := D():Stocks( nView ):nPendientesRecibirInStock()

                  nConsumo                      := D():Stocks( nView ):nConsumoArticulo( ( dbfTmpLin )->cRef, , ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, ( dbfTmpLin )->cLote, dFecIni, dFecFin )

                  if !empty( nConsumo )
                        
                        ( dbfTmpLin )->nConRea  := nConsumo

                        // Aplicamos el incremento-----------------------------

                        nConsumoDia             := nConsumo + ( nConsumo * nPorcentaje / 100 )
                        nConsumoDia             := nConsumoDia / nDias

                        ( dbfTmpLin )->nConSem  := Round( nConsumoDia * 7, 0 ) 
                        ( dbfTmpLin )->nConQui  := Round( nConsumoDia * 15, 0 ) 
                        ( dbfTmpLin )->nConMes  := Round( nConsumoDia * 30, 0 ) 

                  end if 

                  ( dbfTmpLin )->( dbUnlock() )

            end if

            ( dbfTmpLin )->( dbSkip() )

      end while

      ( dbfTmpLin )->( dbGoTo( nRec ) )

      oBrwLin:Refresh()

      RecalculaTotal( aTmp )

      CursorWE()

Return nil 

//---------------------------------------------------------------------------//
 
Static Function ImportaComprasProveedor( aTmp, oBrwLin, oDlg )

      local oImportaComprasProveedor      := ImportarProductosProveedor():New()

      oImportaComprasProveedor:bAction    := {|| CargaComprasProveedor( aTmp, oImportaComprasProveedor, oDlg ), oBrwLin:Refresh() }

      oImportaComprasProveedor:Resource()
      oImportaComprasProveedor:End()      

Return ( nil )

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

Static Function ChangeComentario( oCol, uNewValue, nKey, aTmp )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      if dbSeekInOrd( ( dbfTmpLin )->cRef, "Codigo", D():Articulos( nView ) )

            if dbLock( D():Articulos( nView ) )
                  ( D():Articulos( nView ) )->mComent      := uNewValue
                  ( D():Articulos( nView ) )->( dbUnlock() )
            end if

      end if

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

Static Function ImprimirSeriesPedidosProveedores( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetCompras()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():PedidosProveedores( nView ) )->cSerPed )
   oPrinter:Documento(  ( D():PedidosProveedores( nView ) )->nNumPed )
   oPrinter:Sufijo(     ( D():PedidosProveedores( nView ) )->cSufPed )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():PedidosProveedores( nView ) )->dFecPed )
      oPrinter:oFechaFin:cText( ( D():PedidosProveedores( nView ) )->dFecPed )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "PP" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():PedidosProveedores( nView ) )->cSerPed, "nPedPrv", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "PP", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "PedPROVT", nView )

   oPrinter:bInit    := {||   ( D():PedidosProveedores( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():PedidosProveedoresId( nView ) )                  .and. ;
                              ( D():PedidosProveedores( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():PedidosProveedores( nView ) )->dFecPed )           .and. ;
                              oPrinter:InRangeProveedor( ( D():PedidosProveedores( nView ) )->cCodPrv )         .and. ;
                              oPrinter:InRangeGrupoProveedor( RetFld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "cCodGrp" ) ) }

   oPrinter:bSkip    := {||   ( D():PedidosProveedores( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenPedPrv( nDevice, "Imprimiendo documento : " + D():PedidosProveedoresId( nView ), oPrinter:oFormatoDocumento:uGetValue, oPrinter:oImpresora:uGetValue, oPrinter:oCopias:uGetValue ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "PedPROVT", nView, aStatus )
   
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


/*
Calcula el Total del pedido
*/

FUNCTION nTotPedPrv( cPedido, cPedPrvT, cPedPrvL, cIva, cDiv, aTmp, cDivRet, lPic )

   local nRec
   local nOrdAnt
   local nTotArt
   local nImpuestoEspecial
   local dFecFac
   local lRecargo
   local nDtoEsp
   local nDtoPP
   local nDtoUno
   local nDtoDos
   local nPorte
   local cCodDiv
   local nRegIva
   local aTotDto     := { 0, 0, 0 }
   local aTotDPP     := { 0, 0, 0 }
   local aTotUno     := { 0, 0, 0 }
   local aTotDos     := { 0, 0, 0 }
   local bCondition

   DEFAULT cPedPrvT  := D():PedidosProveedores( nView )
   DEFAULT cPedPrvL  := D():PedidosProveedoresLineas( nView )
   DEFAULT cIva      := D():TiposIva( nView )
   DEFAULT cDiv      := D():Divisas( nView )
   DEFAULT lPic      := .f.
   DEFAULT cPedido   := ( cPedPrvT )->cSerPed + Str( ( cPedPrvT )->nNumPed ) + ( cPedPrvT )->cSufPed

   // variables publicas

   initPublics()

   nRec              := ( cPedPrvL )->( Recno() )
   nOrdAnt           := ( cPedPrvL )->( OrdSetFocus( "nNumPed" ) )
   
   if aTmp != nil
      dFecFac        := aTmp[ _DFECPED ]
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      nPorte         := aTmp[ _NPORTES ]
      cCodDiv        := aTmp[ _CDIVPED ]
      nVdvDiv        := aTmp[ _NVDVPED ]
      nRegIva        := aTmp[ _NREGIVA ]
      bCondition     := {|| ( cPedPrvL )->( !eof() ) }
      ( cPedPrvL )->( dbGoTop() )
   else
      dFecFac        := ( cPedPrvT )->dFecPed
      lRecargo       := ( cPedPrvT )->lRecargo
      nDtoEsp        := ( cPedPrvT )->nDtoEsp
      nDtoPP         := ( cPedPrvT )->nDpp
      nDtoUno        := ( cPedPrvT )->nDtoUno
      nDtoDos        := ( cPedPrvT )->nDtoDos
      nPorte         := ( cPedPrvT )->nPortes
      cCodDiv        := ( cPedPrvT )->cDivPed
      nVdvDiv        := ( cPedPrvT )->nVdvPed
      nRegIva        := ( cPedPrvT )->nRegIva
      bCondition     := {|| ( cPedPrvL )->cSerPed + Str( ( cPedPrvL )->nNumPed ) + ( cPedPrvL )->cSufPed == cPedido .and. ( cPedPrvL )->( !eof() ) }
      ( cPedPrvL )->( dbSeek( cPedido ) )
   end if

   cPinDiv           := cPinDiv( cCodDiv, cDiv )
   cPirDiv           := cPirDiv( cCodDiv, cDiv )
   nDinDiv           := nDinDiv( cCodDiv, cDiv )
   nDirDiv           := nRinDiv( cCodDiv, cDiv )

   while Eval( bCondition )

      if lValLine( cPedPrvL )

         /*
         Importes de lineas
         */

         nTotArt           := nTotLPedPrv( cPedPrvL, nDinDiv, nDirDiv )
         nImpuestoEspecial := nTotIPedPrv( cPedPrvL, nDinDiv, nDirDiv )
         
         if nTotArt != 0

            /*
            Estudio de impuestos
            */

            do case
            case _NPCTIVA1 == NIL .OR. _NPCTIVA1 == ( cPedPrvL )->nIva
               _NPCTIVA1   := (cPedPrvL)->NIVA
               _NPCTREQ1   := (cPedPrvL)->NREQ
               _NBRTIVA1   += nTotArt
               _NIVMIVA1   += nImpuestoEspecial

            case _NPCTIVA2 == NIL .OR. _NPCTIVA2 == ( cPedPrvL )->nIva
               _NPCTIVA2   := (cPedPrvL)->NIVA
               _NPCTREQ2   := (cPedPrvL)->NREQ
               _NBRTIVA2   += nTotArt
               _NIVMIVA2   += nImpuestoEspecial

            case _NPCTIVA3 == NIL .OR. _NPCTIVA3 == ( cPedPrvL )->nIva
               _NPCTIVA3   := (cPedPrvL)->NIVA
               _NPCTREQ3   := (cPedPrvL)->NREQ
               _NBRTIVA3   += nTotArt
               _NIVMIVA3   += nImpuestoEspecial

            end case

         end if

      end if

      ( cPedPrvL )->( dbSkip() )

   end while

   if !Empty( nOrdAnt )
      ( cPedPrvL )->( OrdSetFocus( nOrdAnt ) )
   end if

   ( cPedPrvL )->( dbGoTo( nRec ) )

   // Obtenemos el total bruto----------------------------------------------------

   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   // Portes de la Factura--------------------------------------------------------

   nTotBrt           += nPorte

   _NBASIVA1         := _NBRTIVA1
   _NBASIVA2         := _NBRTIVA2
   _NBASIVA3         := _NBRTIVA3

   /*
   Descuentos de la Facturas
   */

   IF nDtoEsp != 0

      aTotDto[1]     := Round( _NBASIVA1 * nDtoEsp / 100, nDirDiv )
      aTotDto[2]     := Round( _NBASIVA2 * nDtoEsp / 100, nDirDiv )
      aTotDto[3]     := Round( _NBASIVA3 * nDtoEsp / 100, nDirDiv )

      nTotDto        := aTotDto[1] + aTotDto[2] + aTotDto[3]

      _NBASIVA1      -= aTotDto[1]
      _NBASIVA2      -= aTotDto[2]
      _NBASIVA3      -= aTotDto[3]

   END IF

   IF nDtoPP != 0

      aTotDPP[1]     := Round( _NBASIVA1 * nDtoPP / 100, nDirDiv )
      aTotDPP[2]     := Round( _NBASIVA2 * nDtoPP / 100, nDirDiv )
      aTotDPP[3]     := Round( _NBASIVA3 * nDtoPP / 100, nDirDiv )

      nTotDPP        := aTotDPP[1] + aTotDPP[2] + aTotDPP[3]

      _NBASIVA1      -= aTotDPP[1]
      _NBASIVA2      -= aTotDPP[2]
      _NBASIVA3      -= aTotDPP[3]

   END IF

   IF nDtoUno != 0

      aTotUno[1]     := Round( _NBASIVA1 * nDtoUno / 100, nDirDiv )
      aTotUno[2]     := Round( _NBASIVA2 * nDtoUno / 100, nDirDiv )
      aTotUno[3]     := Round( _NBASIVA3 * nDtoUno / 100, nDirDiv )

      nTotUno        := aTotDPP[1] + aTotDPP[2] + aTotDPP[3]

      _NBASIVA1      -= aTotUno[1]
      _NBASIVA2      -= aTotUno[2]
      _NBASIVA3      -= aTotUno[3]

   END IF

   IF nDtoDos != 0

      aTotDos[1]     := Round( _NBASIVA1 * nDtoDos / 100, nDirDiv )
      aTotDos[2]     := Round( _NBASIVA2 * nDtoDos / 100, nDirDiv )
      aTotDos[3]     := Round( _NBASIVA3 * nDtoDos / 100, nDirDiv )

      nTotDos        := aTotDPP[1] + aTotDPP[2] + aTotDPP[3]

      _NBASIVA1      -= aTotDos[1]
      _NBASIVA2      -= aTotDos[2]
      _NBASIVA3      -= aTotDos[3]

   END IF

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

      // Calculo de recargo

      if lRecargo
         _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nDirDiv ), 0 )
         _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nDirDiv ), 0 )
         _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nDirDiv ), 0 )
      end if

   end if

   // Total impuestos

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nDirDiv )

   // Total de R.E.

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nDirDiv )


   // Total impuesto

   nTotIvm           := Round( _NIVMIVA1 + _NIVMIVA2 + _NIVMIVA3, nDirDiv )

   // Total de impuestos

   nTotImp           := Round( nTotIva + nTotReq , nDirDiv )
   if !uFieldEmpresa( "lIvaImpEsp" )
      nTotImp        += Round( nTotIvm , nDirDiv )
   end if 

   // Total facturas

   nTotPed           := nTotNet + nTotImp

   // Refrescos en Pantalla______________________________________________________

   aTotIva           := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   // Solicitan una divisa distinta a la q se hizo originalmente la factura

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet        := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva        := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq        := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotPed        := nCnv2Div( nTotPed, cCodDiv, cDivRet )
      cPirDiv        := cPirDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotPed, cPirDiv ), nTotPed ) ) //

//--------------------------------------------------------------------------//

FUNCTION aTotPedPrv( cPedido, cPedPrvT, cPedPrvL, cIva, cDiv, cDivRet )

   nTotPedPrv( cPedido, cPedPrvT, cPedPrvL, cIva, cDiv, nil, cDivRet, .f. )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotPed, aTotIva } )

//---------------------------------------------------------------------------//

Function sTotPedPrv( cPedido, dbfMaster, dbfLine, cIva, cDiv, cDivRet )

   local sTotal

   nTotPedPrv( cPedido, dbfMaster, dbfLine, cIva, cDiv, nil, cDivRet, .f. )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotPed
   sTotal:nTotalDescuentoGeneral          := nTotDto
   sTotal:nTotalDescuentoProntoPago       := nTotDpp
   sTotal:nTotalDescuentoUno              := nTotUno
   sTotal:nTotalDescuentoDos              := nTotDos

Return ( sTotal )

//--------------------------------------------------------------------------//

FUNCTION BrwPedPrv( oGetNum, cPedPrvT, cPedPrvL, cIva, cDiv, cFPago )

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwPedPrv" )
   local oCbxOrd
   local aCbxOrd  := { "Número", "Fecha", "Código", "Nombre" }
   local cCbxOrd

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]
   nOrd           := ( cPedPrvT )->( OrdSetFocus( nOrd ) )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Pedido a proveedores"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cPedPrvT, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, cPedPrvT ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR       cCbxOrd ;
         ID        102 ;
         ITEMS     aCbxOrd ;
         ON CHANGE ( ( cPedPrvT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF        oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cPedPrvT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Pedido a proveedor.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Es. Estado"
         :bStrData         := {|| "" }
         :bBmpData         := {|| ( cPedPrvT )->nEstado }
         :nWidth           := 20
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número" 
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( cPedPrvT )->cSerPed + "/" + Str( ( cPedPrvT )->nNumPed ) + "/" + ( cPedPrvT )->cSufPed }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPed"
         :bEditValue       := {|| dToc( ( cPedPrvT )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| Rtrim( ( cPedPrvT )->cCodPrv ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| Rtrim( ( cPedPrvT )->cNomPrv ) }
         :nWidth           := 400
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( cPedPrvT )->nTotPed }
         :cEditPicture     := cPirDiv()
         :nWidth           := 120
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
         WHEN     .f.

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     .f.

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if ( cPedPrvT )->nEstado != 3
         oGetNum:cText( ( cPedPrvT )->cSerPed + Str( ( cPedPrvT )->nNumPed ) + ( cPedPrvT )->cSufPed )
         oGetNum:Disable()
      else 
         msgStop( "El pedido ya fue entregado." )
      end if 
   end if

   DestroyFastFilter( cPedPrvT )

   SetBrwOpt( "BrwPedPrv", ( cPedPrvT )->( OrdNumber() ) )

   ( cPedPrvT )->( OrdSetFocus( nOrd ) )

   /*
   Guardamos los datos del browse----------------------------------------------
   */
   
   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION ChgPedPrv( nPedido, nMode, cPedPrvT )

   local oBlock
   local oError
   local lExito   := .t.
   local lClose   := .f.

   if nMode != APPD_MODE .OR. empty( nPedido )
      return nil
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( cPedPrvT )
      USE ( cPatEmp() + "PedProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @cPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PedProvT.Cdx" ) ADDITIVE
      lClose      := .t.
   end if

   if ( cPedPrvT )->( dbSeek( nPedido ) )
      if dbDialogLock( cPedPrvT )
         ( cPedPrvT )->nEstado    := 1
      end if
   else
      lExito      := .f.
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( cPedPrvT )
   end if

RETURN lExito

//-------------------------------------------------------------------------//

FUNCTION nTotEPedPrv( uTmp )

   local nCalculo := 0

   do case
   case ValType( uTmp ) == "C"
      nCalculo    := NotCaja( (uTmp)->nCanEnt ) * (uTmp)->nUniEnt
   case ValType( uTmp ) == "O"
      nCalculo    := NotCaja( uTmp:nCanEnt ) * uTmp:nUniEnt
   case ValType( uTmp ) == "A"
      nCalculo    := NotCaja( uTmp[ _NCANENT ] * uTmp[ _NUNIENT ] )
   end case

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nTotNPedPrv( uTmp )

   local nCalculo := 0

   DEFAULT uTmp   := D():PedidosProveedoresLineas( nView )

   do case
   case ValType( uTmp ) == "C"
      nCalculo    := ( uTmp )->nUniCaja
      nCalculo    *= NotCaja( ( uTmp )->nCanPed )
      nCalculo    *= NotCero( ( uTmp )->nUndKit )
      nCalculo    *= NotCero( ( uTmp )->nMedUno )
      nCalculo    *= NotCero( ( uTmp )->nMedDos )
      nCalculo    *= NotCero( ( uTmp )->nMedTre )

   case ValType( uTmp ) == "O"
      nCalculo    := uTmp:nUniCaja
      nCalculo    *= NotCaja( uTmp:nCanPed )
      nCalculo    *= NotCero( uTmp:nUndKit )
      nCalculo    *= NotCero( uTmp:nMedUno )
      nCalculo    *= NotCero( uTmp:nMedDos )
      nCalculo    *= NotCero( uTmp:nMedTre )

   case ValType( uTmp ) == "A"
      nCalculo    := uTmp[ _NUNICAJA ]
      nCalculo    *= NotCaja( uTmp[ _NCANPED ] )
      nCalculo    *= NotCero( uTmp[ _NUNDKIT ] )
      nCalculo    *= NotCero( uTmp[ _NMEDUNO ] )
      nCalculo    *= NotCero( uTmp[ _NMEDDOS ] )
      nCalculo    *= NotCero( uTmp[ _NMEDTRE ] )

   end case

RETURN ( nCalculo )

//---------------------------------------------------------------------------//
//Total de una linea con impuestos incluidos

FUNCTION nTotFPedPrv( cPedPrvL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo := 0

   nCalculo       += nTotLPedPrv( cPedPrvL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo       += nIvaLPedPrv( cPedPrvL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotUPedPrv( uTmp, nDec, nVdv )

   local nCalculo := 0

   DEFAULT uTmp   := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1

   do case
      case ValType( uTmp ) == "C"
         nCalculo := ( uTmp )->nPreDiv

      case ValType( uTmp ) == "O"
         nCalculo := uTmp:nPreDiv

      case ValType( uTmp ) == "A"
         nCalculo := uTmp[ _NPREDIV ]

   end case

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nImpUPedPrv( uPedPrvT, uPedPrvL, nDec, nVdv, cPorDiv )

   local nCalculo       := 0

   DEFAULT uPedPrvT     := D():PedidosProveedores( nView )
   DEFAULT uPedPrvL     := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec         := nDinDiv()
   DEFAULT nVdv         := 1

   nCalculo             := nTotUPedPrv( uPedPrvL, nDec, nVdv ) 

   if IsArray( uPedPrvT )

      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDTOESP ]  / 100, nDec )
      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDPP    ]  / 100, nDec )
      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDTOUNO ]  / 100, nDec )
      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDTODOS ]  / 100, nDec )
   
   else
   
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDtoEsp / 100, nDec )
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDpp    / 100, nDec )
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDtoUno / 100, nDec )
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDtoDos / 100, nDec )
   
   end if

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUPedPrv( uTmp, nDec, nVdv )

   local nCalculo

   DEFAULT uTmp   := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUPedPrv( uTmp, nDec, nVdv )
   nCalculo       := nCalculo * ( uTmp )->nIva / 100

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTotLPedPrv( uTmp, nDec, nRec, nVdv, cPouDiv )

   local nCalculo

   DEFAULT uTmp   := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec   := nDinDiv()
   DEFAULT nRec   := nRinDiv()
   DEFAULT nVdv   := 1

   // Precio ------------------------------------------------------------------

   nCalculo       := nTotUPedPrv( uTmp, nDec, nVdv )

   do case
      case ValType( uTmp ) == "C"

         if ( uTmp )->nDtoLin != 0
            nCalculo    -= nCalculo * ( uTmp )->nDtoLin / 100
         end if

         if ( uTmp )->nDtoPrm != 0
            nCalculo    -= nCalculo * ( uTmp )->nDtoPrm / 100
         end if

      case ValType( uTmp ) == "O"

         if uTmp:nDtoLin != 0
            nCalculo    -= nCalculo * uTmp:nDtoLin / 100
         end if

         if uTmp:nDtoPrm != 0
            nCalculo    -= nCalculo * uTmp:nDtoPrm / 100
         end if

   end case

   // Unidades

   nCalculo       *= nTotNPedPrv( uTmp )

   if nRec != nil
      nCalculo    := Round( nCalculo, nRec )
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotIPedPrv( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():Get( "PedPrvL", nView )
   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0
   DEFAULT nVdv      := 1

   nCalculo          := Round( ( dbfLin )->nValImp, nDec )
   nCalculo          *= nTotNPedPrv( dbfLin )
   nCalculo          := Round( nCalculo / nVdv, nRouDec )

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLPedPrv( cPedPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cPedPrvL     := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPedPrvL )->nDtoLin != 0 

      nCalculo          := nTotUPedPrv( cPedPrvL, nDec ) * nTotNPedPrv( cPedPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          := nCalculo * ( cPedPrvL )->nDtoLin / 100


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

FUNCTION nPrmLPedPrv( cPedPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cPedPrvL     := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPedPrvL )->nDtoPrm != 0 

      nCalculo          := nTotUPedPrv( cPedPrvL, nDec ) * nTotNPedPrv( cPedPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      if ( cPedPrvL )->nDtoLin != 0 
         nCalculo       -= nCalculo * ( cPedPrvL )->nDtoLin / 100
      end if

      nCalculo          := nCalculo * ( cPedPrvL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION nIvaLPedPrv( uPedPrvL, nDec, nRec, nVdv, cPouDiv )

   local nCalculo

   DEFAULT uPedPrvL  := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotLPedPrv( uPedPrvL, nDec, nRec, nVdv, cPouDiv )

   nCalculo          := Round( nCalculo * ( uPedPrvL )->nIva / 100, nRec )

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLPedPrv( uPedPrvT, uPedPrvL, nDec, nRec, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT uPedPrvT  := D():PedidosProveedores( nView )
   DEFAULT uPedPrvL  := D():PedidosProveedoresLineas( nView )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.

   nCalculo          := nTotLPedPrv( uPedPrvL, nDec, nRec, nVdv )

   if ValType( uPedPrvT ) == "A"
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDTOESP ]  / 100, nRec )
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDPP    ]  / 100, nRec )
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDTOUNO ]  / 100, nRec )
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDTODOS ]  / 100, nRec )
   else
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDtoEsp / 100, nRec )
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDpp    / 100, nRec )
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDtoUno / 100, nRec )
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDtoDos / 100, nRec )
   end if

   if lIva .and. ( D():PedidosProveedoresLineas( nView ) )->nIva != 0
      nCalculo    += nCalculo * ( uPedPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nBrtLPedPrv( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nTotUPedPrv( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNPedPrv( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION mkPedPrv( cPath, lAppend, cPathOld, oMeter, bFor )

   local oldPedPrvT
   local oldPedPrvL
   local oldPedPrvI
   local oldPedPrvD

   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

   if oMeter != NIL
      oMeter:cText   := "Generando bases"
      SysRefresh()
   end if

   createFiles( cPath )

   rxPedPrv( cPath, cLocalDriver() )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "PedProvT.Dbf", cCheckArea( "PedProvT", @dbfPedPrvT ), .f. )
      if !( dbfPedPrvT )->( neterr() )
         ( dbfPedPrvT )->( ordListAdd( cPath + "PedProvT.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PedProvL.Dbf", cCheckArea( "PedProvL", @dbfPedPrvL ), .f. )
      if !( dbfPedPrvL )->( neterr() )
         ( dbfPedPrvL )->( ordListAdd( cPath + "PedProvL.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PedPrvI.Dbf", cCheckArea( "PedPrvI", @dbfPedPrvI ), .f. )
      if !( dbfPedPrvI )->( neterr() )
         ( dbfPedPrvI )->( ordListAdd( cPath + "PedPrvI.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PedPrvD.Dbf", cCheckArea( "PedPrvD", @dbfPedPrvD ), .f. )
      if !( dbfPedPrvD )->( neterr() )
         ( dbfPedPrvD )->( ordListAdd( cPath + "PedPrvD.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PedProvT.Dbf", cCheckArea( "PEDPROVT", @oldPedPrvT ), .f. )
      if !( oldPedPrvT )->( neterr() )
         ( oldPedPrvT )->( ordListAdd( cPathOld + "PedProvT.Cdx" ) )
      end if

       dbUseArea( .t., cDriver(), cPathOld + "PedProvL.Dbf", cCheckArea( "PEDPROVL", @oldPedPrvL ), .f. )
      if !( oldPedPrvL )->( neterr() )
         ( oldPedPrvL )->( ordListAdd( cPathOld + "PedProvL.Cdx" ) ) 
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PedPrvI.Dbf", cCheckArea( "PEDPRVI", @oldPedPrvI ), .f. )
      if !( oldPedPrvI )->( neterr() )
         ( oldPedPrvI )->( ordListAdd( cPathOld + "PedPrvI.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PEDPRVD.DBF", cCheckArea( "PEDPRVD", @oldPedPrvD ), .f. )
      if !( oldPedPrvD )->( neterr() )
         ( oldPedPrvD )->( ordListAdd( cPathOld + "PEDPRVD.CDX" ) )
      end if

      while !( oldPedPrvT )->( eof() )

         if eval( bFor, oldPedPrvT )
            dbCopy( oldPedPrvT, dbfPedPrvT, .t. )

            if ( dbfPedPrvT )->( dbRLock() )
               ( dbfPedPrvT )->cTurPed    := Padl( "1", 6 )
               ( dbfPedPrvT )->( dbRUnlock() )
            end if

            if ( oldPedPrvL )->( dbSeek( (oldPedPrvT)->CSERPED + Str( (oldPedPrvT)->nNumPed ) + (oldPedPrvT)->cSufPed ) )
               while (oldPedPrvT)->CSERPED + Str( (oldPedPrvL)->nNumPed ) + (oldPedPrvL)->cSufPed == (oldPedPrvT)->CSERPED + Str( (dbfPedPrvT)->nNumPed ) + (dbfPedPrvT)->cSufPed .and. !(oldPedPrvL)->( eof() )
                  dbCopy( oldPedPrvL, dbfPedPrvL, .t. )
                  ( oldPedPrvL )->( dbSkip() )
               end while
            end if

            if ( oldPedPrvI )->( dbSeek( ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed ) )
               while ( oldPedPrvI )->cSerPed + Str( ( oldPedPrvI )->nNumPed ) + ( oldPedPrvI )->cSufPed == ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed .and. !( oldPedPrvI )->( eof() )
                  dbCopy( oldPedPrvI, dbfPedPrvI, .t. )
                  ( oldPedPrvI )->( dbSkip() )
               end while
            end if

            if ( oldPedPrvD )->( dbSeek( ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed ) )
               while ( oldPedPrvD )->cSerPed + Str( ( oldPedPrvD )->nNumPed ) + ( oldPedPrvD )->cSufPed == ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed .and. !( oldPedPrvD )->( eof() )
                  dbCopy( oldPedPrvD, dbfPedPrvD, .t. )
                  ( oldPedPrvD )->( dbSkip() )
               end while
            end if

         end if

         ( oldPedPrvT )->( dbSkip() )

      end while

      ( dbfPedPrvT )->( dbCloseArea() )
      ( dbfPedPrvL )->( dbCloseArea() )
      ( dbfPedPrvI )->( dbCloseArea() )
      ( dbfPedPrvD )->( dbCloseArea() )

      ( oldPedPrvT )->( dbCloseArea() )
      ( oldPedPrvL )->( dbCloseArea() )
      ( oldPedPrvI )->( dbCloseArea() )
      ( oldPedPrvD )->( dbCloseArea() )

   end if

Return nil

//--------------------------------------------------------------------------//

FUNCTION rxPedPrv( cPath, cDriver )

   local cPedPrvT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "PedProvT.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedProvL.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedPrvI.Dbf", cDriver )  .or. ;
      !lExistTable( cPath + "PedPrvD.Dbf", cDriver )
      createFiles( cPath, cDriver )
   end if

   // Eliminamos los indices---------------------------------------------------

   fEraseIndex( cPath + "PedProvT.Cdx", cDriver )
   fEraseIndex( cPath + "PedProvL.Cdx", cDriver )
   fEraseIndex( cPath + "PedPrvI.Cdx", cDriver )
   fEraseIndex( cPath + "PedPrvD.Cdx", cDriver )

   buildIndex( cPath + "PedProvT", cDriver, aIndexPedidoProveedor() )

   dbUseArea( .t., cDriver, cPath + "PedProvL.Dbf", cCheckArea( "PEDPROVL", @cPedPrvT ), .f. )
   if !( cPedPrvT )->( neterr() )
      ( cPedPrvT )->( __dbPack() )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "nNumPed", "cSerPed + Str( nNumPed ) + cSufPed", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed } ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cRef", "cRef", {|| Field->cRef }, ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "Lote", "cLote", {|| Field->cLote }, ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cRefLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cPedCliRef", "cPedCli + cRef + cValPr1 + cValPr2", {|| Field->cPedCli + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cPedCliDet", "cPedCli + cRef + cValPr1 + cValPr2 + cRefPrv ", {|| Field->cPedCli + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "iNumPed", "'01' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed", {|| '01' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted() .and. Field->nEstado != 3", {|| !Deleted() .and. Field->nEstado != 3 } ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cStkFast", "cRef + cAlmLin", {|| Field->cRef + Field->cAlmLin }, ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cPedRef", "cRef + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote", {|| Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( cPedPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "nPosPrint", "cSerPed + Str( nNumPed ) + cSufPed + Str( nPosPrint )", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed + Str( Field->nPosPrint ) } ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "nNumPedRef", "cSerPed + Str( nNumPed ) + cSufPed + cRef", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed + Field->cRef } ) )

      ( cPedPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "cCodFam", "cSerPed + Str( nNumPed ) + cSufPed + cCodFam", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed + Field->cCodFam } ) )

      ( cPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "PedPrvI.Dbf", cCheckArea( "PedPrvI", @cPedPrvT ), .f. )
   if !( cPedPrvT )->( neterr() )
      ( cPedPrvT )->( __dbPack() )

      ( cPedPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedPrvI.Cdx", "nNumPed", "cSerPed + Str( nNumPed ) + cSufPed", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed } ) )

      ( cPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "PedPrvD.DBF", cCheckArea( "PedPrvD", @cPedPrvT ), .f. )
   if !( cPedPrvT )->( neterr() )
      ( cPedPrvT )->( __dbPack() )

      ( cPedPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedPrvT )->( ordCreate( cPath + "PedPrvD.Cdx", "nNumPed", "cSerPed + Str( nNumPed ) + cSufPed", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed } ) )

      ( cPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

Return nil

//--------------------------------------------------------------------------//

function aIncPedPrv()

   local aIncPedPrv  := {}

   aAdd( aIncPedPrv, { "cSerPed", "C",    1,  0, "Serie de pedido" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "nNumPed", "N",    9,  0, "Número de pedido" ,                "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "lListo",  "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "lAviso",  "L",    1,  0, "Lógico de Aviso" ,                 "",                   "", "( cDbfCol )" } )

return ( aIncPedPrv )

//---------------------------------------------------------------------------//

function aPedPrvDoc()

   local aPedPrvDoc  := {}

   aAdd( aPedPrvDoc, { "cSerPed", "C",    1,  0, "Serie de pedido" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "nNumPed", "N",    9,  0, "Número de pedido" ,                "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "cRuta",   "M",   10,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aPedPrvDoc )

//---------------------------------------------------------------------------//

FUNCTION lSnd( oWndBrw, dbf )

   local nRecAct
   local nRecOld              := ( dbf )->( Recno() )

   for each nRecAct in ( oWndBrw:oBrw:aSelected )

      ( dbf )->( dbGoTo( nRecAct ) )

      if dbDialogLock( dbf )

         ( dbf )->lSndDoc     := !( dbf )->lSndDoc
         
         if ( dbf )->( fieldPos( 'dFecChg' ) ) != 0
            ( dbf )->dFecChg  := Date()
         end if 
         if ( dbf )->( fieldPos( 'cTimChg' ) ) != 0
            ( dbf )->cTimChg  := Time()
         end if 

         ( dbf )->( dbUnlock() )

      end if

   next

   ( dbf )->( dbGoTo( nRecOld ) )

    oWndBrw:Refresh()

    oWndBrw:SetFocus()

Return nil

//---------------------------------------------------------------------------//

Function AppPedPrv( cCodPrv, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv( nil, nil, cCodPrv, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, D():PedidosProveedores( nView ), cCodPrv, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            WinEdtRec( nil, bEdtRec, D():PedidosProveedores( nView ) )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            WinZooRec( nil, bEdtRec, D():PedidosProveedores( nView ) )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            WinDelRec( nil, D():PedidosProveedores( nView ), {|| QuiPedPrv() } )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            WinDelRec( nil, D():PedidosProveedores( nView ), {|| QuiPedPrv() } )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//----------------------------------------------------------------------------//

FUNCTION PrnPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            GenPedPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            GenPedPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION VisPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            GenPedPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", D():PedidosProveedores( nView ) )
            GenPedPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

function nVtaPedPrv( cCodPrv, dDesde, dHasta, cPedPrvT, cPedPrvL, cIva, cDiv )

   local nCon     := 0
   local nRec     := ( cPedPrvT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cPedPrvT )->( dbSeek( cCodPrv ) )

      while ( cPedPrvT )->cCodPrv == cCodPrv .and. !( cPedPrvT )->( Eof() )

         if ( dDesde == nil .or. ( cPedPrvT )->dFecPed >= dDesde )    .and.;
            ( dHasta == nil .or. ( cPedPrvT )->dFecPed <= dHasta )

            nCon  += nTotPedPrv( ( cPedPrvT )->cSerPed + Str( ( cPedPrvT )->nNumPed ) + ( cPedPrvT )->cSufPed, cPedPrvT, cPedPrvL, cIva, cDiv, nil, cDivEmp(), .f. )

         end if

         ( cPedPrvT )->( dbSkip() )

      end while

   end if

   ( cPedPrvT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

FUNCTION aDocPedPrv( dbfDocFld, dbfDocCol )

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Pedido",          "PP" } )
   aAdd( aDoc, { "Proveedor",       "PR" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

FUNCTION dFecPedPrv( cPedPrv, cPedPrvT )

   local dFecPed  := CtoD("")

   IF ( cPedPrvT )->( dbSeek( cPedPrv ) )
      dFecPed  := ( cPedPrvT )->dFecPed
   END IF

RETURN ( dFecPed )

//---------------------------------------------------------------------------//

FUNCTION nEstPedPrv( cPedPrv, cPedPrvT )

   local nEstPed  := 1

   IF ( cPedPrvT )->( dbSeek( cPedPrv ) )
      nEstPed     := ( cPedPrvT )->nEstado
   END IF

RETURN ( nEstPed )

//---------------------------------------------------------------------------//

FUNCTION cNbrPedPrv( cPedPrv, cPedPrvT )

   local cNomPrv  := ""

   IF ( cPedPrvT )->( dbSeek( cPedPrv ) )
      cNomPrv  := ( cPedPrvT )->cNomPrv
      END IF

RETURN ( cNomPrv )

//---------------------------------------------------------------------------//

function nTotDPedPrv( cCodArt, cPedPrvL, cPedPrvT, cCodAlm )

   local nTotVta  := 0
   local nRecno   := ( cPedPrvL )->( Recno() )

   if ( cPedPrvL )->( dbSeek( cCodArt ) )

      while ( cPedPrvL )->cRef == cCodArt .and. !( cPedPrvL )->( eof() )

        if cCodAlm != nil
           if cCodAlm == ( cPedPrvL )->cAlmLin
              nTotVta  += nTotNPedPrv( cPedPrvL )
           end if
        else
           nTotVta     += nTotNPedPrv( cPedPrvL )
        end if

        ( cPedPrvL )->( dbSkip() )

      end while

   end if

   ( cPedPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

function nTotVPedPrv( cCodArt, cPedPrvL, nDec, nDor )

   local nTotVta  := 0
   local nRecno   := ( cPedPrvL )->( Recno() )

   if ( cPedPrvL )->( dbSeek( cCodArt ) )

      while ( cPedPrvL )->CREF == cCodArt .and. !( cPedPrvL )->( eof() )

         nTotVta += nTotLPedPrv( cPedPrvL, nDec, nDor )

         ( cPedPrvL )->( dbSkip() )

      end while

   end if

   ( cPedPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

function aItmPedPrv()

   local aBase := {  { "cSerPed",   "C",  1,   0, "Serie del pedido",                                            "Serie",                      "", "( cDbf )", nil },;
                     { "nNumPed",   "N",  9,   0, "Número del pedido",                                           "Numero",                     "", "( cDbf )", nil },;
                     { "cSufPed",   "C",  2,   0, "Sufijo del pedido",                                           "Sufijo",                     "", "( cDbf )", nil },;
                     { "cTurPed",   "C",  6,   0, "Sesión del pedido",                                           "Turno",                      "", "( cDbf )", nil },;
                     { "dFecPed",   "D",  8,   0, "Fecha del pedido",                                            "Fecha",                      "", "( cDbf )", nil },;
                     { "cCodPrv",   "C", 12,   0, "Codigo del proveedor",                                        "Cliente",                    "", "( cDbf )", nil },;
                     { "cCodAlm",   "C", 16,   0, "Código de almacen",                                           "Almacen",                    "", "( cDbf )", nil },;
                     { "cCodCaj",   "C",  3,   0, "Código de caja",                                              "Caja",                       "", "( cDbf )", nil },;
                     { "cNomPrv",   "C",150,   0, "Nombre del proveedor",                                        "NombreCliente",              "", "( cDbf )", nil },;
                     { "cDirPrv",   "C",200,   0, "Domicilio del proveedor",                                     "DomicilioCliente",           "", "( cDbf )", nil },;
                     { "cPobPrv",   "C",200,   0, "Población del proveedor",                                     "PoblacionCliente",           "", "( cDbf )", nil },;
                     { "cProPrv",   "C",100,   0, "Provincia del proveedor",                                     "ProvinciaCliente",           "", "( cDbf )", nil },;
                     { "cPosPrv",   "C",  5,   0, "Código postal del proveedor",                                 "CodigoPostalCliente",        "", "( cDbf )", nil },;
                     { "cDniPrv",   "C", 30,   0, "D.N.I. del proveedor",                                        "DniCliente",                 "", "( cDbf )", nil },;
                     { "dFecEnt",   "D",  8,   0, "Fecha de entrada",                                            "",                           "", "( cDbf )", nil },;
                     { "nEstado",   "N",  1,   0, "Estado del pedido",                                           "",                           "", "( cDbf )", nil },;
                     { "cSuped",    "C", 10,   0, "Comentario su pedido",                                        "",                           "", "( cDbf )", nil },;
                     { "cCodPgo",   "C",  2,   0, "Codigo de la forma de pago",                                  "",                           "", "( cDbf )", nil },;
                     { "nBulTos",   "N",  3,   0, "Número de bultos",                                            "",                           "", "( cDbf )", nil },;
                     { "nPorTes",   "N",  6,   0, "Precio de los portes",                                        "",                           "", "( cDbf )", nil },;
                     { "cDtoEsp",   "C", 50,   0, "Descripción descuento especial",                              "",                           "", "( cDbf )", nil },;
                     { "nDtoEsp",   "N",  5,   2, "Descuento factura",                                           "",                           "", "( cDbf )", nil },;
                     { "cDpp",      "C", 50,   0, "Descripción descuento pronto pago",                           "",                           "", "( cDbf )", nil },;
                     { "nDpp",      "N",  5,   2, "Descuento pronto pago",                                       "",                           "", "( cDbf )", nil },;
                     { "lRecargo",  "L",  1,   0, "Recargo de equivalencia",                                     "",                           "", "( cDbf )", nil },;
                     { "cCondEnt",  "C", 20,   0, "Comentarios del pedido",                                      "",                           "", "( cDbf )", nil },;
                     { "cExped",    "C", 20,   0, "Expedición",                                                  "",                           "", "( cDbf )", nil },;
                     { "cObserv",   "M", 10,   0, "Observaciones",                                               "",                           "", "( cDbf )", nil },;
                     { "cDivPed",   "C",  3,   0, "Codigo de divisa",                                            "",                           "", "( cDbf )", nil },;
                     { "nVdvPed",   "N", 10,   4, "Valor de la divisa",                                          "",                           "", "( cDbf )", nil },;
                     { "lSndDoc",   "L",  1,   0, "Enviar documento",                                            "",                           "", "( cDbf )", nil },;
                     { "cDtoUno",   "C", 25,   0, "Descripción de primer descuento personalizado",               "",                           "", "( cDbf )", nil },;          
                     { "nDtoUno",   "N",  5,   2, "Porcentaje de primer descuento personalizado",                "",                           "", "( cDbf )", nil },;          
                     { "cDtoDos",   "C", 25,   0, "Descripción de segundo descuento personalizado",              "",                           "", "( cDbf )", nil },;          
                     { "nDtoDos",   "N",  5,   2, "Porcentaje de segundo descuento personalizado",               "",                           "", "( cDbf )", nil },;
                     { "lCloPed",   "L",  1,   0, "",                                                            "",                           "", "( cDbf )", nil },;
                     { "cCodUsr",   "C",  3,   0, "Código de usuario",                                           "",                           "", "( cDbf )", nil },;
                     { "cNumPedCli","C", 12,   0, "Número del pedido del cliente del que viene",                 "",                           "", "( cDbf )", nil },;
                     { "lImprimido","L",  1,   0, "Lógico de imprimido del documento",                           "",                           "", "( cDbf )", nil },;
                     { "dFecImp",   "D",  8,   0, "Última fecha de impresión del documento",                     "",                           "", "( cDbf )", nil },;
                     { "cHorImp",   "C",  5,   0, "Hora de la última impresión del documento",                   "",                           "", "( cDbf )", nil },;
                     { "dFecChg",   "D",  8,   0, "Fecha de modificación del documento",                         "",                           "", "( cDbf )", nil },;
                     { "cTimChg",   "C",  5,   0, "Hora de modificación del documento",                          "",                           "", "( cDbf )", nil },;
                     { "cCodDlg",   "C",  2,   0, "Código delegación",                                           "",                           "", "( cDbf )", nil },;
                     { "cSituac",   "C", 20,   0, "Situación del documento",                                     "",                           "", "( cDbf )", nil },;
                     { "nRegIva",   "N",  1,   0, "Regimen de " + cImp(),                                        "",                           "", "( cDbf )", nil },;
                     { "nTotNet",   "N", 16,   6, "Total neto",                                                  "TotalNeto",                  "", "( cDbf )", nil },;
                     { "nTotIva",   "N", 16,   6, "Total " + cImp(),                                             "TotalImpuesto",              "", "( cDbf )", nil },;
                     { "nTotReq",   "N", 16,   6, "Total recargo equivalencia",                                  "TotalRecargo",               "", "( cDbf )", nil },;
                     { "nTotPed",   "N", 16,   6, "Total pedido",                                                "TotalDocumento",             "", "( cDbf )", nil },;
                     { "cNumAlb",   "C", 12,   0, "Número del albarán en el se ha agrupado",                     "",                           "", "( cDbf )", nil },;
                     { "lRECC",     "L",  1,   0, "Lógico régimen especial del criterio de caja",                "",                           "", "( cDbf )", nil },;
                     { "cCtrCoste", "C",  9,   0, "Código del centro de coste",                                  "",                           "", "( cDbf )", nil } }

return ( aBase )

//---------------------------------------------------------------------------//

Function aIndexPedidoProveedor()

   local aIndex   := {}

   aAdd( aIndex, { "Id",                  "nNumPed",     "cSerPed + str( nNumPed ) + cSufPed",                          {|| Field->cSerPed + str( Field->nNumPed ) + Field->cSufPed }, .f. } )
   aAdd( aIndex, { "Fecha",               "dFecPed",     "dFecPed",                                                     {|| Field->dFecPed }, .f. } )
   aAdd( aIndex, { "FechaEntrada",        "dFecEnt",     "dFecEnt",                                                     {|| Field->dFecEnt }, .f. } )
   aAdd( aIndex, { "CodigoEntidad",       "cCodPrv",     "cCodPrv",                                                     {|| Field->cCodPrv }, .f. } )
   aAdd( aIndex, { "NombreEntidad",       "cNomPrv",     "Upper( cNomPrv )",                                            {|| Upper( Field->cNomPrv ) }, .f. } )
   aAdd( aIndex, { "AnnoId",              "nNumPedYea",  "str( Year( dFecPed ) ) + cSerPed + str( nNumPed ) + cSufPed", {|| str( Year( Field->dFecPed ) ) + Field->cSerPed + str( Field->nNumPed ) + Field->cSufPed }, .f. } )
   aAdd( aIndex, { "AnnoFecha",           "dFecPedYea",  "str( Year( dFecPed ) ) + Dtoc( dFecPed )",                    {|| str( Year( Field->dFecPed ) ) + Dtoc( Field->dFecPed ) }, .f. } )
   aAdd( aIndex, { "AnnoFechaEntrada",    "dFecEntYea",  "str( Year( dFecPed ) ) + Dtoc( dFecEnt )",                    {|| str( Year( Field->dFecPed ) ) + Dtoc( Field->dFecEnt ) }, .f. } )
   aAdd( aIndex, { "AnnoEntidad",         "cCodPrvYea",  "str( Year( dFecPed ) ) + cCodPrv",                            {|| str( Year( Field->dFecPed ) ) + Field->cCodPrv }, .f. } )
   aAdd( aIndex, { "AnnoNombreEntidad",   "cNomPrvYea",  "str( Year( dFecPed ) ) + Upper( cNomPrv )",                   {|| str( Year( Field->dFecPed ) ) + Upper( Field->cNomPrv ) }, .f. } )
   aAdd( aIndex, { "Estado",              "nEstado",     "nEstado",                                                     {|| Field->nEstado }, .f. } )
   aAdd( aIndex, { "Turno",               "cTurPed",     "cTurPed + cSufPed + cCodCaj",                                 {|| Field->cTurPed + Field->cSufPed + Field->cCodCaj }, .f. } )
   aAdd( aIndex, { "IdPedidoCliente",     "cPedCli",     "cNumPedCli",                                                  {|| Field->cNumPedCli }, .f. } )
   aAdd( aIndex, { "IdUsuario",           "cCodUsr",     "cCodUsr + Dtos( dFecChg ) + cTimChg",                         {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg }, .f. } )
   aAdd( aIndex, { "IdAlbaranProveedor",  "cNumAlb",     "cNumAlb",                                                     {|| Field->cNumAlb }, .f. } )
   aAdd( aIndex, { "IdInforme",           "iNumPed",     "'01' + cSerPed + str( nNumPed ) + Space(1) + cSufPed",        {|| '01' + Field->cSerPed + str( Field->nNumPed ) + Space(1) + Field->cSufPed }, .f. } )
   aAdd( aIndex, { "FechaDescendente",    "dDesPed",     "dFecPed",                                                     {|| Field->dFecPed }, .t. } )

Return ( aIndex )

//---------------------------------------------------------------------------//

Function aCalPedPrv()

   local aCalPedPrv  := {  { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPirDivPed",  "!empty( aTotIva[1,1] ) .and. lEnd" },;
                           { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPirDivPed",  "!empty( aTotIva[2,1] ) .and. lEnd" },;
                           { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPirDivPed",  "!empty( aTotIva[3,1] ) .and. lEnd" },;
                           { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPirDivPed",  "!empty( aTotIva[1,2] ) .and. lEnd" },;
                           { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPirDivPed",  "!empty( aTotIva[2,2] ) .and. lEnd" },;
                           { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPirDivPed",  "!empty( aTotIva[3,2] ) .and. lEnd" },;
                           { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "!empty( aTotIva[1,3] ) .and. lEnd" },;
                           { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "!empty( aTotIva[2,3] ) .and. lEnd" },;
                           { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "!empty( aTotIva[3,3] ) .and. lEnd" },;
                           { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "!empty( aTotIva[1,4] ) .and. lEnd" },;
                           { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "!empty( aTotIva[2,4] ) .and. lEnd" },;
                           { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "!empty( aTotIva[3,4] ) .and. lEnd" },;
                           { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDinDivPed )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPinDivPed",  "!empty( aTotIva[1,2] ) .and. lEnd" },;
                           { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDinDivPed )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPinDivPed",  "!empty( aTotIva[2,2] ) .and. lEnd" },;
                           { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDinDivPed )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPinDivPed",  "!empty( aTotIva[3,2] ) .and. lEnd" },;
                           { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDinDivPed )",    "N", 16,  6, "Importe primer RE",           "cPinDivPed",  "!empty( aTotIva[1,2] ) .and. lEnd" },;
                           { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDinDivPed )",    "N", 16,  6, "Importe segundo RE",          "cPinDivPed",  "!empty( aTotIva[2,2] ) .and. lEnd" },;
                           { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDinDivPed )",    "N", 16,  6, "Importe tercer RE",           "cPinDivPed",  "!empty( aTotIva[3,2] ) .and. lEnd" },;
                           { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPirDivPed",  "lEnd" },;
                           { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPirDivPed",  "lEnd" },;
                           { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPirDivPed",  "lEnd" },;
                           { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPirDivPed",  "lEnd" },;
                           { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),                   "cPirDivPed",  "lEnd" },;
                           { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPirDivPed",  "lEnd" },;
                           { "nTotPed",                                                   "N", 16,  6, "Total pedido",                "cPirDivPed",  "lEnd" },;
                           { "nImpEuros( nTotPed, (cDbf)->CDIVPED, cDbfDiv )",            "N", 16,  6, "Total pedido (Euros)",        "",            "lEnd" },;
                           { "nImpPesetas( nTotPed, (cDbf)->CDIVPED, cDbfDiv )",          "N", 16,  6, "Total pedido (Pesetas)",      "",            "lEnd" },;
                           { "nPagina",                                                   "N",  2,  0, "Número de página",            "'99'",        "" },;
                           { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" } }

return ( aCalPedPrv )

//---------------------------------------------------------------------------//

function aColPedPrv()

   local aColPedPrv  := {}

   aAdd( aColPedPrv,  { "cSerPed",   "C",  1,   0, "",                                 "Serie",                      "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nNumPed",   "N",  9,   0, "",                                 "Numero",                     "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cSufPed",   "C",  2,   0, "",                                 "Sufijo",                     "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cRef",      "C", 18,   0, "Referencia del artículo",          "Articulo",                   "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cRefPrv",   "C", 18,   0, "Referencia del proveedor",         "CodigoArticuloProveedor",    "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cDetalle",  "C",250,   0, "Nombre del artículo",              "DescripcionArticulo",        "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nIva",      "N",  6,   2, "Porcentaje de " + cImp(),          "PorcentajeImpuesto",         "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nCanPed",   "N", 16,   6, "Cantidad pedida",                  "Cajas",                      "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nUniCaja",  "N", 16,   6, "Unidades por caja",                "Unidades",                   "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nPreDiv",   "N", 16,   6, "Precio",                           "PrecioVenta",                "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nCanEnt",   "N", 16,   6, "Cajas recibidas",                  "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nUniEnt",   "N", 16,   6, "Unidades recibidas",               "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cUnidad",   "C",  2,   0, cNombreUnidades(),                  "UnidadMedicion",             "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "mLngDes",   "M", 10,   0, "Descripción larga",                "DescripcionAmpliada",        "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nDtoLin",   "N",  6,   2, "Descuento en lineas",              "DescuentoPorcentual",        "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nDtoPrm",   "N",  6,   2, "Descuento pormociones",            "DescuentoPromocion",         "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nDtoRap",   "N",  6,   2, "Descuento por rappels",            "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cCodPr1",   "C", 20,   0, "Código de la primera propiedad",   "CodigoPropiedad1",           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cCodPr2",   "C", 20,   0, "Código de la segunda propiedad",   "CodigoPropiedad2",           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cValPr1",   "C", 20,   0, "Valor de la primera propiedad",    "ValorPropiedad1",            "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cValPr2",   "C", 20,   0, "Valor de la segunda propiedad",    "ValorPropiedad2",            "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nFacCnv",   "N", 13,   4, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nCtlStk",   "N",  1,   0, "Control de stock (1,2,3)",         "ControlStock",               "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cAlmLin" ,  "C", 16,   0, "Código de almacén" ,               "Almacen",                    "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lLote",     "L",  1,   0, "",                                 "LogicoLote",                 "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nLote",     "N",  9,   0, "",                                 "",                           "", "(cDbfCol)", nil } ) 
   aAdd( aColPedPrv,  { "cLote",     "C", 14,   0, "Número de lote",                   "Lote",                       "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nNumLin",   "N",  4,   0, "Número de la línea",               "NumeroLinea",                "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nUndKit",   "N", 16,   6, "Unidades del producto kit",        "UnidadesKit",                "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lKitArt",   "L",  1,   0, "Línea con escandallo",             "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lKitChl",   "L",  1,   0, "Línea pertenciente a escandallo",  "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lKitPrc",   "L",  1,   0, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lImpLin",   "L",  1,   0, "Imprimir linea",                   "Imprimir",                   "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lControl",  "L",  1,   0, "" ,                                "Control",                    "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "mNumSer",   "M", 10,   0, "" ,                                "NumerosSerie",               "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lAnulado",  "L",  1,   0, "Anular linea",                     "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "dAnulado",  "D",  8,   0, "Fecha de anulación",               "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "mAnulado",  "M",100,   0, "Motivo anulación",                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cCodFam",   "C", 16,   0, "Código de familia",                "Familia",                    "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cGrpFam",   "C",  3,   0, "Código del grupo de familia",      "GrupoFamilia",               "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nReq",      "N", 16,   6, "Recargo de equivalencia",          "PorcentajeRecargo",          "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "mObsLin",   "M", 10,   6, "Observaciones de la linea",        "Observaciones",              "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cPedCli",   "C", 12,   0, "Número del pedido del cliente",    "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nPvpRec",   "N", 16,   6, "Precio de venta recomendado",      "PrecioVentaRecomendado",     "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nNumMed",   "N",  1,   0, "Número de mediciones",             "NumeroMediciones",           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nMedUno",   "N", 16,   6, "Primera unidad de medición",       "Medicion1",                  "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nMedDos",   "N", 16,   6, "Segunda unidad de medición",       "Medicion2",                  "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nMedTre",   "N", 16,   6, "Tercera unidad de medición",       "Medicion3",                  "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nStkAct",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nStkMin",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nPdtRec",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nConRea",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nConSem",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nConQui",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nConMes",   "N", 16,   6, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nEstado",   "N",  1,   0, "Estado del pedido",                "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lFromImp",  "L",  1,   0, "",                                 "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nBultos",   "N", 16,   6, "Numero de bultos en líneas",       "NumeroBultos",               "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cFormato",  "C",100,   0, "Formato de compra",                "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cCodImp",   "C",  3,   0, "Código de impuesto especial",      "ImpuestoEspecial",           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nValImp",   "N", 16,   6, "Importe de impuesto especial",     "ImporteImpuestoEspecial",    "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "lLabel",    "L",  1,   0, "Lógico para marca de etiqueta",    "LogicoEtiqueta",             "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nLabel",    "N",  6,   0, "Unidades de etiquetas a imprimir", "NumeroEtiqueta",             "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cRefAux",   "C", 18,   0, "Referencia auxiliar",              "CodigoAuxiliar1",            "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cRefAux2",  "C", 18,   0, "Segunda referencia auxiliar",      "CodigoAuxiliar2",            "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "nPosPrint", "N",  4,   0, "Posición de impresión",            "PosicionImpresion",          "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cCtrCoste", "C",  9,   0, "Codig del centro de coste" ,       "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cTipCtr",   "C", 20,   0, "Tipo tercero centro de coste",     "",                           "", "(cDbfCol)", nil } )
   aAdd( aColPedPrv,  { "cTerCtr",   "C", 20,   0, "Tercero centro de coste" ,         "",                           "", "(cDbfCol)", nil } )

Return ( aColPedPrv )

//---------------------------------------------------------------------------//

function aCocPedPrv()

   local aCocPedPrv  := {  { "Descrip( cDbfCol )",                                           "C", 50, 0, "Detalle del artículo",       "",            "Descripción", "" },;
                           { "nTotNPedPrv( cDbfCol )",                                       "N", 16, 6, "Total unidades",             "cPicUndPed",  cNombreUnidades(),    "" },;
                           { "nTotUPedPrv( cDbfCol, nDinDivPed, nVdvDivPed )",               "N", 16, 6, "Precio unitario de pedido",  "cPinDivPed",  "Precio",      "" },;
                           { "nTotLPedPrv( cDbfCol, nDinDivPed, nDirDivPed, nVdvDivPed )",   "N", 16, 6, "Total linea de pedido",      "cPirDivPed",  "Total",       "" } }

return ( aCocPedPrv )

//---------------------------------------------------------------------------//

Static Function nClrText( dbfTmpLin )

Return ( if ( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ) )

//----------------------------------------------------------------------------//

Function EdtNumSer( mNumSer, nTotUnd, nMode )

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

   if nTotUnd == 0
      MsgStop( "No hay unidades para asignar números de serie." )
      Return ( mNumSer )
   end if

   DEFAULT nMode  := APPD_MODE

   nTotUnd        := abs( nTotUnd )
   aNumSer        := Afill( Array( nTotUnd ), Space( 30 ) )

   if nMode != APPD_MODE
      aMem2Ser( mNumSer, nTotUnd )
   end if

   DEFINE DIALOG oDlg RESOURCE "VtaNumSer"

      REDEFINE GET nTotUnd ;
                  ID          100 ;
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
         ACTION   ( mNumSer   := mSer2Mem( aNumSer, nTotUnd ), oDlg:End() )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| mNumSer := mSer2Mem( aNumSer, nTotUnd ), oDlg:End() } )

   ACTIVATE DIALOG oDlg CENTER

Return ( mNumSer )

//----------------------------------------------------------------------------//

Function GenNumSer( cPreFix, aNumSer, nSerIni, nNumGen, oBrwSer )

   local n
   local nChg  := 1

   CursorWait()

   if empty( nNumGen )
      aEval( aNumSer, {| a, n | aNumSer[ n ] := Padr( Rtrim( cPreFix ) + Ltrim( Str( nSerIni + n - 1 ) ), 30 ) } )
   else
      for n := 1 to len( aNumSer )
         if empty( aNumSer[ n ] )
            aNumSer[ n ]                     := Padr( Rtrim( cPreFix ) + Ltrim( Str( nSerIni + nChg - 1 ) ), 30 )
            nChg++
         end if
         if nChg == nNumGen
            exit
         end if
      next
   end if

   CursorWE()

   if !empty( oBrwSer )
      oBrwSer:Refresh()
   end if

Return nil

//---------------------------------------------------------------------------//

Function aMem2Ser( mNumSer, nTotUnd )

   local n
   local nPosSer
   local aMemSer

   CursorWait()

   aMemSer           := Afill( Array( nTotUnd ), Space( 40 ) )

   for n := 1 to nTotUnd

      nPosSer        := At( ",", mNumSer )
      if nPosSer != 0
         aMemSer[ n ]:= Padr( SubStr( mNumSer, 1, nPosSer - 1 ), 40 )
         mNumSer     := SubStr( mNumSer, nPosSer + 1 )
      end if
   next

   CursorWE()

Return ( aMemSer )

//----------------------------------------------------------------------------//

Function SynPedPrv( cPath )

   local oError
   local oBlock      
   local aTotPed
   local nEstado

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "PedProvT.Dbf", cCheckArea( "PedPROVT", @dbfPedPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "PedProvT.Cdx" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PedProvL.Dbf", cCheckArea( "PedPROVL", @dbfPedPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "PedProvL.Cdx" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PedPrvI.Dbf", cCheckArea( "PedPRVI", @dbfPedPrvI ), .f. )
   if !lAIS(); ordListAdd( cPath + "PedPrvI.Cdx" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "FAMILIAS.DBF", cCheckArea( "FAMILIAS", @dbfFamilia ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "FAMILIAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "ARTICULO.DBF", cCheckArea( "ARTICULO", @dbfArticulo ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "ARTICULO.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "PROVART.DBF", cCheckArea( "PROVART", @dbfArtPrv ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "PROVART.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "TIVA.DBF", cCheckArea( "TIVA", @dbfIva ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "TIVA.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "DIVISAS.DBF", cCheckArea( "DIVISAS", @dbfDiv ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "DIVISAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   ( dbfPedPrvT )->( OrdSetFocus( 0 ) )
   ( dbfPedPrvT )->( dbGoTop() )

   while !( dbfPedPrvT )->( eof() )

      if empty( ( dbfPedPrvT )->cSufPed )
         ( dbfPedPrvT )->cSufPed    := "00"
      end if

      if empty( ( dbfPedPrvT )->cCodCaj )
         ( dbfPedPrvT )->cCodCaj    := "000"
      end if

      if !empty( ( dbfPedPrvT )->cNumPedCli ) .and. Len( AllTrim( ( dbfPedPrvT )->cNumPedCli ) ) != 12
         ( dbfPedPrvT )->cNumPedCli := AllTrim( ( dbfPedPrvT )->cNumPedCli ) + "00"
      end if

      if !empty( ( dbfPedPrvT )->cNumAlb ) .and. Len( AllTrim( ( dbfPedPrvT )->cNumAlb ) ) != 12
         ( dbfPedPrvT )->cNumAlb    := AllTrim( ( dbfPedPrvT )->cNumAlb ) + "00"
      end if

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      if ( dbfPedPrvT )->nTotPed == 0

         aTotPed                    := aTotPedPrv( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, ( dbfPedPrvT )->cDivPed )

         ( dbfPedPrvT )->nTotNet    := aTotPed[1]
         ( dbfPedPrvT )->nTotIva    := aTotPed[2]
         ( dbfPedPrvT )->nTotReq    := aTotPed[3]
         ( dbfPedPrvT )->nTotPed    := aTotPed[4]

      end if

      ( dbfPedPrvT )->( dbSkip() )

   end while

   ( dbfPedPrvT )->( OrdSetFocus( 1 ) )

   // Lineas ------------------------------------------------------------------

   ( dbfPedPrvL )->( OrdSetFocus( 0 ) )
   ( dbfPedPrvL )->( dbGoTop() )

   while !( dbfPedPrvL )->( eof() )

      if empty( ( dbfPedPrvL )->cSufPed )
         ( dbfPedPrvL )->cSufPed := "00"
      end if

      if !empty( ( dbfPedPrvL )->cPedCli ) .and. Len( AllTrim( ( dbfPedPrvL )->cPedCli ) ) != 12
         ( dbfPedPrvL )->cPedCli := AllTrim( ( dbfPedPrvL )->cPedCli ) + "00"
      end if

      if empty( ( dbfPedPrvL )->cLote ) .and. !empty( ( dbfPedPrvL )->nLote )
         ( dbfPedPrvL )->cLote   := AllTrim( Str( ( dbfPedPrvL )->nLote ) )
      end if

      if !empty( ( dbfPedPrvL )->cRef ) .and. empty( ( dbfPedPrvL )->cCodFam )
         ( dbfPedPrvL )->cCodFam := RetFamArt( ( dbfPedPrvL )->cRef, dbfArticulo )
      end if

      if !empty( ( dbfPedPrvL )->cRef ) .and. !empty( ( dbfPedPrvL )->cGrpFam )
         ( dbfPedPrvL )->cGrpFam := cGruFam( ( dbfPedPrvL )->cCodFam, dbfFamilia )
      end if

      if empty( ( dbfPedPrvL )->nReq )
         ( dbfPedPrvL )->nReq    := nPReq( dbfIva, ( dbfPedPrvL )->nIva )
      end if

      if empty( ( dbfPedPrvL )->cAlmLin )
         ( dbfPedPrvL )->cAlmLin := RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "cCodAlm" )
      end if

      nEstado     := RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "nEstado" )

      if nEstado == 3
         ( dbfPedPrvL )->nEstado := nEstado
      end if

      if empty( ( dbfPedPrvL )->nPosPrint )
         ( dbfPedPrvL )->nPosPrint    := ( dbfPedPrvL )->nNumLin
      end if

      ( dbfPedPrvL )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfPedPrvL )->( OrdSetFocus( 1 ) )

   // Incidencias -------------------------------------------------------------

   ( dbfPedPrvI )->( OrdSetFocus( 0 ) )
   ( dbfPedPrvI )->( dbGoTop() )

   while !( dbfPedPrvI )->( eof() )

      if empty( ( dbfPedPrvI )->cSufPed )
         ( dbfPedPrvI )->cSufPed := "00"
      end if

      ( dbfPedPrvI )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfPedPrvI )->( OrdSetFocus( 1 ) )

   RECOVER USING oError

      msgStop( "Imposible sincronizar pedidos de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !empty( dbfPedPrvT ) .and. ( dbfPedPrvT )->( Used() )
      ( dbfPedPrvT )->( dbCloseArea() )
   end if

   if !empty( dbfPedPrvL ) .and. ( dbfPedPrvL )->( Used() )
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfPedPrvI ) .and. ( dbfPedPrvI )->( Used() )
      ( dbfPedPrvI )->( dbCloseArea() )
   end if

   if !empty( dbfArticulo ) .and. ( dbfArticulo )->( Used() )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !empty( dbfFamilia ) .and. ( dbfFamilia )->( Used() )
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if !empty( dbfArtPrv ) .and. ( dbfArtPrv )->( Used() )
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if !empty( dbfIva ) .and. ( dbfIva )->( Used() )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !empty( dbfDiv ) .and. ( dbfDiv )->( Used() )
      ( dbfDiv )->( dbCloseArea() )
   end if

return nil

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

CLASS TPedidosProveedorSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   METHOD validateRecepcion()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TPedidosProveedorSenderReciver

   local oBlock
   local oError
   local lSnd        := .f.
   local cFileName
   local dbfPedPrvT
   local dbfPedPrvL
   local tmpPedPrvT
   local tmpPedPrvL

   if ::oSender:lServer
      cFileName         := "PedPrv" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "PedPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando pedidos a proveedores" )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PedProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "PedProvT.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "PedProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "PedProvL.Cdx" ) ADDITIVE

   // Creamos todas las bases de datos relacionadas con Articulos

   mkPedPrv( cPatSnd() )

   dbUseArea( .t., ( cLocalDriver() ), ( cPatSnd() + "PedProvT.Dbf" ), ( cCheckArea( "PEDPROVT", @tmpPedPrvT ) ), .t., .f. )
   ( tmpPedPrvT )->( ordListAdd( ( cPatSnd() + "PedProvT.Cdx" ) ) )

   dbUseArea( .t., ( cLocalDriver() ), ( cPatSnd() + "PedProvL.Dbf" ), ( cCheckArea( "PEDPROVL", @tmpPedPrvL ) ), .t., .f. )
   ( tmpPedPrvL )->( ordListAdd( ( cPatSnd() + "PedProvL.Cdx" ) ) )

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfPedPrvT )->( lastrec() )
   end if

   while !( dbfPedPrvT )->( eof() )

      if ( dbfPedPrvT )->lSndDoc

         lSnd  := .t.

         dbPass( dbfPedPrvT, tmpPedPrvT, .t. )

         ::oSender:SetText( ( dbfPedPrvT )->cSerPed + "/" + AllTrim( Str( ( dbfPedPrvT )->nNumPed ) ) + "/" + Alltrim( ( dbfPedPrvT )->cSufPed ) + "; " + Dtoc( ( dbfPedPrvT )->dFecPed ) + "; " + AllTrim( ( dbfPedPrvT )->cCodPrv ) + "; " + ( dbfPedPrvT )->cNomPrv )

         if ( dbfPedPrvL )->( dbSeek( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) )

            while ( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed ) == ( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) .AND. !( dbfPedPrvL )->( eof() )

               dbPass( dbfPedPrvL, tmpPedPrvL, .t. )

               ( dbfPedPrvL )->( dbSkip() )

            end do

         end if

      end if

      ( dbfPedPrvT )->( dbSkip() )

      if !empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfPedPrvT )->( OrdKeyNo() ) )
      end if

   end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfPedPrvT )
   CLOSE ( dbfPedPrvL )
   CLOSE ( tmpPedPrvT )
   CLOSE ( tmpPedPrvL )

   // Comprimir los archivos---------------------------------------------------

   if lSnd

      ::oSender:SetText( "Comprimiendo pedidos de proveedores" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay pedidos de proveedores para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//
/*
Retorna el valor anterior
*/

Method RestoreData() CLASS TPedidosProveedorSenderReciver

   local oBlock
   local oError
   local cPedPrvT

   if ::lSuccesfullSend


      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatEmp() + "PedProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @cPedPrvT ) )
         SET ADSINDEX TO ( cPatEmp() + "PedProvT.Cdx" ) ADDITIVE

         lSelectAll( nil, cPedPrvT, "lSndDoc", .f., .t., .f. )

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

         CLOSE ( cPedPrvT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TPedidosProveedorSenderReciver

   local cFileName

   if ::oSender:lServer
      cFileName         := "PedPrv" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "PedPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if File( cPatOut() + cFileName )

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

Method ReciveData() CLASS TPedidosProveedorSenderReciver

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   // Recibirlo de internet

   ::oSender:SetText( "Recibiendo pedidos de proveedores" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "PedPrv*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Pedidos de proveedores recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TPedidosProveedorSenderReciver

   local m
   local oBlock
   local oError
   local dbfPedPrvT
   local dbfPedPrvL 
   local tmpPedPrvT
   local tmpPedPrvL
   local aFiles      := Directory( cPatIn() + "PedPrv*.*" )

   // Procesamos los ficheros recibidos

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      // descomprimimos el fichero---------------------------------------------

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         dbUseArea(.t., cLocalDriver(), cPatSnd() + "PedProvT.Dbf", cCheckArea( "PEDPROVT", @tmpPedPrvT ), .f., .t. )
         ( tmpPedPrvT )->( ordListAdd( cPatSnd() + "PedProvT.Cdx"  ) )

         dbUseArea(.t., cLocalDriver(), cPatSnd() + "PedProvL.Dbf", cCheckArea( "PEDPROVL", @tmpPedPrvL ), .f., .t. )
         ( tmpPedPrvL )->( ordListAdd( cPatSnd() + "PedProvL.Cdx"  ) )

         USE ( cPatEmp() + "PedProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
         SET ADSINDEX TO ( cPatEmp() + "PedProvT.Cdx" ) ADDITIVE

         USE ( cPatEmp() + "PedProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
         SET ADSINDEX TO ( cPatEmp() + "PedProvL.Cdx" ) ADDITIVE

         ( tmpPedPrvT )->( dbGoTop() )
         while !( tmpPedPrvT )->( eof() )

            if ::validateRecepcion( tmpPedPrvT, dbfPedPrvT )

               while ( dbfPedPrvT )->( dbseek( ( tmpPedPrvT )->cSerPed + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) )
                  dbLockDelete( dbfPedPrvT )
               end if 

               while ( dbfPedPrvT )->( dbseek( ( tmpPedPrvT )->cSerPed + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) )
                  dbLockDelete( dbfPedPrvT )
               end if 

               dbPass( tmpPedPrvT, dbfPedPrvT, .t. )

               if dbLock( dbfPedPrvT )
                  ( dbfPedPrvT )->lSndDoc := .f.
                  ( dbfPedPrvT )->( dbUnLock() )
               end if

               ::oSender:SetText( "Añadido : " + ( tmpPedPrvT )->cSerPed + "/" + AllTrim( Str( ( tmpPedPrvT )->nNumPed ) ) + "/" + AllTrim( ( tmpPedPrvT )->cSufPed ) + "; " + Dtoc( ( tmpPedPrvT )->dFecPed ) + "; " + AllTrim( ( tmpPedPrvT )->cCodPrv ) + "; " + ( tmpPedPrvT )->cNomPrv )

               if ( tmpPedPrvL )->( dbSeek( ( tmpPedPrvT )->CSERPED + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) )

                  while ( ( tmpPedPrvL )->CSERPED + Str( ( tmpPedPrvL )->nNumPed ) + ( tmpPedPrvL )->cSufPed ) == ( ( tmpPedPrvT )->CSERPED + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) .AND. !( tmpPedPrvL )->( eof() )

                     dbPass( tmpPedPrvL, dbfPedPrvL, .t. )

                     ( tmpPedPrvL )->( dbSkip() )

                  end while

               end if

            else

               ::oSender:SetText( "Desestimado : " + ( tmpPedPrvT )->cSerPed + "/" + AllTrim( Str( ( tmpPedPrvT )->nNumPed ) ) + "/" + AllTrim( ( tmpPedPrvT )->cSufPed ) + "; " + Dtoc( ( tmpPedPrvT )->dFecPed ) + "; " + AllTrim( ( tmpPedPrvT )->cCodPrv ) + "; " + ( tmpPedPrvT )->cNomPrv )

            end if

            ( tmpPedPrvT )->( dbSkip() )

         end while

         CLOSE ( dbfPedPrvT )
         CLOSE ( dbfPedPrvL )
         CLOSE ( tmpPedPrvT )
         CLOSE ( tmpPedPrvL )

         ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      end if

      RECOVER USING oError

         CLOSE ( dbfPedPrvT )
         CLOSE ( dbfPedPrvL )
         CLOSE ( tmpPedPrvT )
         CLOSE ( tmpPedPrvL )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

METHOD validateRecepcion( tmpPedPrvT, dbfPedPrvT ) CLASS TPedidosProveedorSenderReciver

   ::cErrorRecepcion       := "Pocesando pedido de proveedor número " + ( dbfPedPrvT )->cSerPed + "/" + alltrim( Str( ( dbfPedPrvT )->nNumPed ) ) + "/" + alltrim( ( dbfPedPrvT )->cSufPed ) + " "

   if !( lValidaOperacion( ( tmpPedPrvT )->dFecPed, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpPedPrvT )->dFecPed ) + " no es valida en esta empresa"
      Return .f. 
   end if 

   if !( ( dbfPedPrvT )->( dbSeek( ( tmpPedPrvT )->cSerPed + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) ) )
      Return .t.
   end if 

   if dtos( ( dbfPedPrvT )->dFecChg ) + ( dbfPedPrvT )->cTimChg >= dtos( ( tmpPedPrvT )->dFecChg ) + ( tmpPedPrvT )->cTimChg 
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfPedPrvT )->dFecChg ) + " " + ( dbfPedPrvT )->cTimChg + " es más reciente que la recepción " + dtoc( ( tmpPedPrvT )->dFecChg ) + " " + ( tmpPedPrvT )->cTimChg 
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

/*
Selecciona todos los registros
*/

FUNCTION lSelAll( oBrw, dbf, lSel, lTop, lMeter )

   local nRecAct  := ( dbf )->( recno() )

   DEFAULT lSel   := .t.
   DEFAULT lTop   := .t.
   DEFAULT lMeter := .f.

   if lMeter
      CreateWaitMeter( nil, nil, ( dbf )->( OrdKeyCount() ) )
   else
      CursorWait()
   end if

   if lTop
      ( dbf )->( dbGoTop() )
   end if

   while !( dbf )->( eof() )

      if dbLock( dbf )
         ( dbf )->lSndDoc := lSel
         ( dbf )->( dbUnlock() )
      end if

      ( dbf )->( dbSkip() )

      if lMeter
         RefreshWaitMeter( ( dbf )->( OrdKeyNo() ) )
      else
         SysRefresh()
      end if

   end do

   ( dbf )->( dbGoTo( nRecAct ) )

   if lMeter
      EndWaitMeter()
   else
      CursorWE()
   end if

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION aDocumentsPedidoProveedor( cNumPed )

   local oBlock
   local oError
   local dbfAlbPrvT
   local aDocuments  := {}

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE
   ( dbfAlbPrvT )->( OrdSetFocus( "cNumPed" ) )

   if ( dbfAlbPrvT )->( dbSeek( cNumPed ) )
      while ( dbfAlbPrvT )->cNumPed == cNumPed .and. !( dbfAlbPrvT )->( eof() )
         aAdd( aDocuments, {  ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb,;
                              Dtoc( ( dbfAlbPrvT )->dFecAlb ),;
                              ( dbfAlbPrvT )->cCodPrv,;
                              Rtrim( ( dbfAlbPrvT )->cNomPrv ),;
                              ( dbfAlbPrvT )->cCodAlm } )
         ( dbfAlbPrvT )->( dbSkip() )
      end while
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfAlbPrvT )

Return ( aDocuments )

//---------------------------------------------------------------------------//

Function GetCodCli( cNumPed )

   local oBlock
   local oError
   local dbfPedCliT
   local cCodCli  := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   ( dbfPedCliT )->( OrdSetFocus( "NNUMPED" ) )

   if ( dbfPedCliT )->( dbSeek( cNumPed ) )
      cCodCli     := ( dbfPedCliT )->cCodCli
   end if 

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfPedCliT )

Return cCodCli

//---------------------------------------------------------------------------//

Function GetNomCli( cNumPed )

   local oBlock
   local oError
   local dbfPedCliT
   local cNomCli  := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   ( dbfPedCliT )->( OrdSetFocus( "NNUMPED" ) )

   if ( dbfPedCliT )->( dbSeek( cNumPed ) )
      cNomCli     := ( dbfPedCliT )->cNomCli
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfPedCliT )

Return cNomCli

//---------------------------------------------------------------------------//

function lChgImpDoc( dbfT )

   if dbSafeLock( dbfT )
      ( dbfT )->lImprimido := .t.
      ( dbfT )->dFecImp    := GetSysDate()
      ( dbfT )->cHorImp    := SubStr( Time(), 1, 5 )
      dbSafeUnLock( dbfT )
   end if

Return .t.

//---------------------------------------------------------------------------//

/*
Función que monta los diálogos para la generación de pedidos a proveedor
*/

Function Generador( oBrwPed )

   local oDlg
   local oPag
   local oBmp
   local oMtr
   local nMtr
   local oBrw
   local oCol
   local oBtnAnt
   local oBtnNxt
   local oProvee
   local cProvee
   local oSayPrv
   local cSayPrv
   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cArtOrg        := dbFirst ( D():Articulos( nView ), 1 )
   local cArtDes        := dbLast  ( D():Articulos( nView ), 1 )
   local cSayArtOrg     := dbFirst ( D():Articulos( nView ), 2 )
   local cSayArtDes     := dbLast  ( D():Articulos( nView ), 2 )
   local oCodAlm
   local oNomAlm
   local cCodAlm        := cDefAlm()
   local cNomAlm        := retAlmacen( cCodAlm, D():Almacen( nView ) )
   local nStockDis      := 4
   local nStockFin      := 1

   CreaTemporal()

   DEFINE DIALOG oDlg RESOURCE "ASS_PEDCLI" TITLE "Generar pedido a proveedor"

   REDEFINE BITMAP oBmp ;
      RESOURCE "gc_shopping_cart_48" ;
      ID       500 ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE PAGES oPag ;
      ID       110 ;
      OF       oDlg ;
      DIALOGS  "ASS_PEDPRV1", "ASS_PEDCLI2"

   REDEFINE GET oProvee VAR cProvee;
      ID       110;
      VALID    cProvee( oProvee, D():Proveedores( nView ), oSayPrv ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwProvee( oProvee, oSayPrv ) ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oSayPrv VAR cSayPrv ;
      ID       120;
      WHEN     .f.;
      OF       oPag:aDialogs[1]

   REDEFINE GET oArtOrg VAR cArtOrg;
      ID       150 ;
      VALID    cArticulo( oArtOrg, D():Articulos( nView ), oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtOrg, oSayArtOrg );
      OF       oPag:aDialogs[1]

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
      WHEN     .f.;
      ID       160 ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oArtDes VAR cArtDes;
      ID       170 ;
      VALID    cArticulo( oArtDes, D():Articulos( nView ), oSayArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtDes, oSayArtDes );
      OF       oPag:aDialogs[1]

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
      WHEN     .f.;
      ID       180 ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oCodAlm VAR cCodAlm ;
      ID       190 ;
      VALID    ( cAlmacen( oCodAlm, , oNomAlm ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAlmacen( oCodAlm, oNomAlm ) ) ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oNomAlm VAR cNomAlm ;
      WHEN     .f. ;
      ID       200 ;
      OF       oPag:aDialogs[1]

   REDEFINE RADIO nStockDis ;
      ID       201, 202, 203, 204 ;
      OF       oPag:aDialogs[1]

   REDEFINE RADIO nStockFin ;
      ID       212, 213 ;
      OF       oPag:aDialogs[ 1 ]

 REDEFINE APOLOMETER oMtr ;
      VAR      nMtr ;
      PROMPT   "Procesando" ;
      ID       220 ;
      TOTAL    ( ( D():Articulos( nView ) )->( LastRec() ) ) ;
      OF       oPag:aDialogs[ 1 ]

   // Browse de pedido---------------------------------------------------------

   oBrw                 := IXBrowse():New( oPag:aDialogs[ 2 ] )

   oBrw:lHScroll        := .t.
   oBrw:cAlias          := dbfTmpArt
   oBrw:nMarqueeStyle   := MARQSTYLE_HIGHLCELL
   oBrw:cName           := "Pedido a proveedores asistente"
   oBrw:bLDblClick   := {|| oCol:Edit() }

   with object ( oBrw:AddCol() )
      :cHeader       := "Se. Seleccionado"
      :bStrData      := {|| "" }
      :bEditValue    := {|| ( dbfTmpArt )->lSelArt }
      :nEditType     := 0
      :nWidth        := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( oBrw:AddCol() )
      :cHeader       := "Código"
      :bEditValue    := {|| ( dbfTmpArt )->cRef }
      :nEditType     := 0
      :nWidth        := 60
   end with

   with object ( oBrw:AddCol() )
      :cHeader       := "Detalle"
      :bEditValue    := {|| ( dbfTmpArt )->cDetalle }
      :nEditType     := 0
      :nWidth        := 200
   end with

   with object ( oBrw:AddCol() )
      :cHeader       := "Objetivo"
      :bEditValue    := {|| ( dbfTmpArt )->nObjUni }
      :cEditPicture  := MasUnd()
      :nEditType     := 0
      :nWidth        := 65
      :nDataStrAlign := AL_RIGHT
      :nHeadStrAlign := AL_RIGHT
   end with

   with object ( oCol := oBrw:AddCol() )
      :cHeader       := "A pedir"
      :bEditValue    := {|| ( dbfTmpArt )->nNumUni }
      :cEditPicture  := MasUnd()
      :nEditType     := 1
      :nWidth        := 65
      :bOnPostEdit   := {|o,x| if( x > 0, ( dbfTmpArt )->nNumUni := x, ), .t. }
      :nDataStrAlign := AL_RIGHT
      :nHeadStrAlign := AL_RIGHT
   end with

   with object ( oBrw:AddCol() )
      :cHeader       := "Stock actual"
      :bEditValue    := {|| ( dbfTmpArt )->nStkFis }
      :cEditPicture  := MasUnd()
      :nEditType     := 0
      :nWidth        := 65
      :nDataStrAlign := AL_RIGHT
      :nHeadStrAlign := AL_RIGHT
   end with

   with object ( oBrw:AddCol() )
      :cHeader       := "Stock disponible"
      :bEditValue    := {|| ( dbfTmpArt )->nStkDis }
      :cEditPicture  := MasUnd()
      :nEditType     := 0
      :nWidth        := 65
      :nDataStrAlign := AL_RIGHT
      :nHeadStrAlign := AL_RIGHT
   end with

   oBrw:CreateFromResource( 100 )

   REDEFINE BUTTON ;
      ID       110;
      OF       oPag:aDialogs[2] ;
      ACTION   ( oCol:Edit() )

   REDEFINE BUTTON ;
      ID       120;
      OF       oPag:aDialogs[2] ;
      ACTION   ( SelArt( dbfTmpArt, oBrw ) )

   REDEFINE BUTTON ;
      ID       130;
      OF       oPag:aDialogs[2] ;
      ACTION   ( SelAllArt( dbfTmpArt, oBrw, .t. ) )

   REDEFINE BUTTON ;
      ID       140;
      OF       oPag:aDialogs[2] ;
      ACTION   ( SelAllArt( dbfTmpArt, oBrw, .f. ) )

   REDEFINE BUTTON oBtnAnt ;
      ID       401 ;
      OF       oDlg;
      ACTION   ( BtnAnt( oPag, oBtnNxt, oBtnAnt ) )

   REDEFINE BUTTON oBtnNxt ;
      ID       402 ;
      OF       oDlg;
      ACTION   ( BtnNxt( oPag, oBtnNxt, oBtnAnt, oDlg, oProvee, cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, oMtr, oBrw, cCodAlm ) )

   REDEFINE BUTTON ;
      ID       403 ;
      OF       oDlg ;
      ACTION   ( KillTemporal(), oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT( oBtnAnt:Hide(), oBrw:Load() )

   oBmp:End()

   oBrwPed:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

function ShowKitCom( dbfMaster, dbfTmpLin, oBrw, cCodPrv, dbfTmpInc, aGet )

   if !empty( aGet )

      if lUsrMaster() .or. oUser():lCambiarPrecio()
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardEnable()
      else
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardDisable()
      end if

      if !empty( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:cText( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:lValid()
      end if

      aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:SetFocus()

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

Function IsPedPrv( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "PedProvT.Dbf" )
      dbCreate( cPath + "PedProvT.Dbf", aSqlStruct( aItmPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedProvL.Dbf" )
      dbCreate( cPath + "PedProvL.Dbf", aSqlStruct( aColPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedPrvI.Dbf" )
      dbCreate( cPath + "PedPrvI.Dbf", aSqlStruct( aIncPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedPrvD.Dbf" )
      dbCreate( cPath + "PedPrvD.Dbf", aSqlStruct( aPedPrvDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "PedProvT.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedProvL.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedPrvI.Cdx" )  .or. ;
      !lExistIndex( cPath + "PedPrvD.Cdx" )
      rxPedPrv( cPath )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function evalPedidosProveedor( cExpresion )

   local bExpresion  := &( "{||" + cExpresion + "}" )

   if hb_isblock( bExpresion )
      eval( bExpresion )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function viewPedidosProveedor()

Return ( nView )

//---------------------------------------------------------------------------//

FUNCTION cDesPedPrv( cPedPrvL )

   DEFAULT cPedPrvL  := D():PedidosProveedoresLineas( nView )

RETURN ( Descrip( cPedPrvL ) )

//---------------------------------------------------------------------------//

FUNCTION cDesPedPrvLeng( cPedPrvL, cPedPrvS, cArtLeng )

   DEFAULT cPedPrvL  := D():PedidosProveedoresLineas( nView )
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cPedPrvL, , cArtLeng ) )

//---------------------------------------------------------------------------//

Function DesignReportPedPrv( oFr, cDoc )

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
                                                   ";"                                                         + Chr(13) + Chr(10) + ;
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

Function mailReportPedPrv( cCodigoDocumento )

Return ( printReportPedPrv( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Function PrintReportPedPrv( nDevice, nCopies, cPrinter, cDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "PedidoProveedor" + StrTran( ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed, " ", "" ) + ".Pdf"
   local nOrd 

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   nOrd                 := ( D():PedidosProveedoresLineas( nView ) )->( ordSetFocus( "nPosPrint" ) )

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

   if lMemoDocumento( cDoc, D():Documentos( nView ) )

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

   ( D():PedidosProveedoresLineas( nView ) )->( ordSetFocus( nOrd ) )

Return cFilePdf

//---------------------------------------------------------------------------//

/*
Function getNumeroAlbaranProveedorLinea( nView )

Return ( substr( ( D():FacturasProveedoresLineas( nView ) )->iNumAlb, 1, 12 ) )

//---------------------------------------------------------------------------//
*/

FUNCTION nTotNDocumento( uDbf )
 
   local nTotUnd

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

Function designLabelPedidoProveedores( oFr, cDoc )

   local oLabel   
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorPedidoProveedores():New( nView )

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
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de pedidos" )
   end if

   // Diseño de report------------------------------------------------------

   oFr:DesignReport()
   oFr:DestroyFr()

   // Destruye el fichero temporal------------------------------------------------

   oLabel:DestroyTempReport()
   oLabel:End()

   if lOpenFiles
      closeFiles()
   end if 

Return .t.

//--------------------------------------------------------------------------//

Function nombrePrimeraPropiedad( view )

   DEFAULT view   := nView

Return ( nombrePrimeraPropiedadPedidosProveedoresLineas( view ) )

//--------------------------------------------------------------------------//

Function nombreSegundaPropiedad( view )

   DEFAULT view   := nView

Return ( nombreSegundaPropiedadPedidosProveedoresLineas( view ) )

//--------------------------------------------------------------------------//

Function getExtraFieldPedidoProveedor( cFieldName )

Return ( getExtraField( cFieldName, D():CamposExtraHeader( nView ), D():PedidosProveedoresId( nView ) ) )

//---------------------------------------------------------------------------//   

Function nombrePrimeraPropiedadPedidosProveedoresLineas( view )

   DEFAULT view   := nView

Return ( nombrePropiedad( ( D():PedidosProveedoresLineas( view ) )->cCodPr1, ( D():PedidosProveedoresLineas( view ) )->cValPr1, view ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadPedidosProveedoresLineas( view )

   DEFAULT view   := nView

Return ( nombrePropiedad( ( D():PedidosProveedoresLineas( view ) )->cCodPr2, ( D():PedidosProveedoresLineas( view ) )->cValPr2, view ) )

//---------------------------------------------------------------------------//

Function valorCampoExtra( cField, view )

   local id

   DEFAULT view   := nView

   id       := ( D():PedidosProveedoresLineas( view ) )->cSerPed
   id       += Str( ( D():PedidosProveedoresLineas( view ) )->nNumPed )
   id       += ( D():PedidosProveedoresLineas( view ) )->cSufPed
   id       += Str( ( D():PedidosProveedoresLineas( view ) )->nNumLin )

Return ( getCustomExtraField( cField, "Lineas pedidos a proveedores", id ) )

//---------------------------------------------------------------------------//

Function MenuEdtDet( oCodArt, oDlg, lOferta, nIdLin )

   DEFAULT lOferta      := .f.

   MENU oDetMenu

      MENUITEM    "&1. Rotor  " ;
         RESOURCE "Rotor16"

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( D():CamposExtraLine( nView ):Play( nIdLin ) )

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