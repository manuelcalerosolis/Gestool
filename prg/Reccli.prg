#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Print.ch"
#include "Report.ch"
#include "FastrepH.ch"
#include "Factu.ch" 
#include "DbInfo.ch"

#define _MENUITEM_               "01059"

#define NORMAL_MODE               0
#define COMPENSAR_MODE            1
#define LIBRE_MODE                2

/*
Defines para las lineas de Pago
*/

#define _CSERIE                   1      //   C      1     0
#define _NNUMFAC                  2      //   N      9     0
#define _CSUFFAC                  3      //   C      2     0
#define _NNUMREC                  4      //   N      2     0
#define _GUID                     5      //   C     40     0
#define _CTIPREC                  6      //   N      2     0
#define _CCODPGO                  7      //   C      2     0
#define _CCODCAJ                  8      //   C      6     0
#define _CTURREC                  9      //   C     12     0
#define _CCODCLI                 10      //   D      8     0
#define _CNOMCLI                 11      //   D      8     0
#define _DENTRADA                12      //   N     10     0
#define _NIMPORTE                13      //   C    100     0
#define _CDESCRIP                14      //   C      8     0
#define _DPRECOB                 15      //   D     50     0
#define _CPGDOPOR                16      //   D     50     0
#define _CDOCPGO                 17      //   L      1     0
#define _LCOBRADO                18      //   C      3     0
#define _CDIVPGO                 19      //
#define _NVDVPGO                 20      //   L      1     0
#define _LCONPGO                 21      //   C     12     0
#define _CCONGUID                22
#define _CCTAREC                 23      //   N     16     6
#define _NIMPEUR                 24      //   L      1     0
#define _LIMPEUR                 25      //   N      9     0 Numero de la remesas
#define _NNUMREM                 26      //   C      2     0 Sufijo de remesas
#define _CSUFREM                 27      //   C      3     0 Cuenta de remesa
#define _CCTAREM                 28      //   L      1     0 Marca para impreso
#define _LRECIMP                 29      //   L      1     0 Recibo descontado
#define _LRECDTO                 30      //   D      8     0 Fecha del descuento
#define _DFECDTO                 31      //   D      8     0 Fecha de vencimiento
#define _DFECVTO                 32      //   C      3     0 Codigo del agente
#define _CCODAGE                 33      //   C      3     0 Numero de cobro
#define _NNUMCOB                 34      //   C      2     0 Sufijo de cobro
#define _CSUFCOB                 35      //   N     16     6 Importe de cobro
#define _NIMPCOB                 36      //   N     16     6 Importe de gastos
#define _NIMPGAS                 37      //   C     12     0 Subcuenta de gastos
#define _CCTAGAS                 38
#define _LESPERADOC              39
#define _LCLOPGO                 40
#define _DFECIMP                 41      //   D      8     0
#define _CHORIMP                 42      //   C      5     0
#define _LNOTARQUEO              43
#define _CCODBNC                 44
#define _DFECCRE                 45      //   D      8     0
#define _CHORCRE                 46      //   C      5     0
#define _CCODUSR                 47      //   C      3     0
#define _LDEVUELTO               48      //   L      1     0
#define _DFECDEV                 49      //   D      8     0
#define _CMOTDEV                 50      //   C    250     0
#define _CRECDEV                 51      //   C     14     0
#define _LSNDDOC                 52      //   L      1     0
#define _CBNCEMP                 53
#define _CBNCCLI                 54
#define _CEPAISIBAN              55
#define _CECTRLIBAN              56
#define _CENTEMP                 57
#define _CSUCEMP                 58
#define _CDIGEMP                 59
#define _CCTAEMP                 60
#define _CPAISIBAN               61
#define _CCTRLIBAN               62
#define _CENTCLI                 63
#define _CSUCCLI                 64
#define _CDIGCLI                 65
#define _CCTACLI                 66
#define _LREMESA                 67
#define _CNUMMTR                 68
#define _LPASADO                 69
#define _CCENTROCOSTE            70
#define _NIMPREL                 71

memvar cDbfRec
memvar cDbf
memvar cDbfCol
memvar cCliente
memvar cDbfCli
memvar cFPago
memvar cDbfPgo
memvar cDbfDiv
memvar cDbfAge
memvar cPorDivRec
memvar nPagina
memvar lEnd
memvar nTotFac

static oWndBrw

static nView

static oCtaRem
static oCentroCoste

static lPgdOld
static nImpOld

static oTotalRelacionados
static nTotalRelacionados        := 0

static aRecibosRelacionados      := {}
static aRecibosMatriz            := {}

static oClienteCompensar

static oMenu

static oMailing

static lOpenFiles                := .f.
static cFiltroUsuario            := ""

static cOldCodCli                := ""

static lOldDevuelto              := .f.

static lActualizarEstadoFactura  := .t.

static dbfMatriz

static bEdit                     := { |aTmp, aGet, dbf, oBrw, lRectificativa, nSpecialMode, nMode, aTmpFac| EdtCob( aTmp, aGet, dbf, oBrw, lRectificativa, nSpecialMode, nMode, aTmpFac ) }

static hEstadoRecibo             := {  "Pendiente"             => "GC_DELETE_12",;
                                       "Cobrado"               => "GC_CHECK_12",;
                                       "Devuelto"              => "SIGN_WARNING_12",;
                                       "Remesado"              => "GC_FOLDER_OPEN_CHECK_12",;
                                       "Espera documentación"  => "GC_CLOCK_12" }

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Los ficheros de recibos de clientes ya estan abiertos.' )
      RETURN ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles        := .t.

      nView             := D():CreateView()

      D():FacturasClientesCobros( nView )

      D():Agentes( nView )

      D():Cajas( nView )

      D():FormasPago( nView )

      D():Divisas( nView )

      D():FacturasClientes( nView )

      D():FacturasClientesLineas( nView )

      D():AnticiposClientes( nView )

      D():FacturasRectificativas( nView )

      D():FacturasRectificativasLineas( nView )

      D():Empresa( nView )

      D():ClientesBancos( nView )
      ( D():ClientesBancos( nView ) )->( OrdSetFocus( "cBncDef" ) )

      D():Turnos( nView )

      D():TiposIva( nView )

      D():Clientes( nView )

      D():Documentos( nView )

      D():Contadores( nView )

      D():ClientesBancos( nView )

      USE ( cPatEmp() + "FacCliP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @dbfMatriz ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.CDX" ) ADDITIVE
      SET TAG TO "cNumMtr"

      oCtaRem              := TCtaRem():Create( cPatCli() )
      oCtaRem:OpenFiles()

      oCentroCoste         := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles        := .f.
      end if

      oMailing             := TGenmailingDatabaseRecibosClientes():New( nView )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de recibos de clientes" + CRLF + ErrorMessage( oError ) )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   D():DeleteView( nView )

   if oCtaRem != nil
      oCtaRem:CloseFiles()
      oCtaRem:End()
   end if

   if !empty( oCentroCoste )
      oCentroCoste:CloseFiles()
   end if

   if !empty( dbfMatriz )
      ( dbfMatriz )->( dbCloseArea() )
   end if

   if !empty(oMailing)
      oMailing:end()
   end if 

   oWndBrw     := nil
   dbfMatriz   := nil

   lOpenFiles  := .f.

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION RecCli( oMenuItem, oWnd, aNumRec )

   local oImp
   local oPrv
   local oFlt
   local nLevel
   local oBtnEur
   local lEur           := .f.
   local oPdf
   local oMail
   local oRotor
   local nOrdAnt
   local lFound
   local oSnd
   local oCobrado

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  aNumRec     := Array( 1 )

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      RETURN nil
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      RETURN .f.
   end if

   /*
   Anotamos el movimiento para el navegador------------------------------------
   */

   AddMnuNext( "Recibos de facturas de clientes", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Recibos de facturas de clientes" ;
      MRU      "gc_briefcase2_user_16" ;
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():FacturasClientesCobros( nView ) );
      PROMPTS  "Número",;
               "Código",;
               "Nombre",;
               "Expedición",;
               "Vencimiento",;
               "Cobro",;
               "Importe",;
               "Matriz" ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, D():FacturasClientesCobros( nView ), , , aNumRec ) ) ;
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdit, D():FacturasClientesCobros( nView ) ) ) ;
      DELETE   ( DelCobCli( oWndBrw:oBrw, D():FacturasClientesCobros( nView ) ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->lCloPgo }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 6
         :bstrData         := {|| cEstadoRecibo( D():FacturasClientesCobros( nView ) ) }
         :bBmpData         := {|| nEstadoRecibo( D():FacturasClientesCobros( nView ) ) }
         :nWidth           := 20
         heval( hEstadoRecibo, {|k,v,i| :AddResource( v ) } )
         :AddResource( "gc_money2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Compensado"
         :nHeadBmpNo       := 2
         :bStrData         := {|| cEstadoMatriz() }
         :bBmpData         := {|| nEstadoMatriz() }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Nil16" )
         :AddResource( "gc_folder_cubes_16" )
         :AddResource( "Sel16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->lConPgo }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_folder2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->lRecImp }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :cSortOrder       := "cTipRec"
         :bEditValue       := {|| cTipoRecibo( ( D():FacturasClientesCobros( nView ) )->cTipRec ) }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cSerie + "/" + alltrim( str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) ) + "-" + alltrim( str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cSufFac  }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cTurRec }
         :nWidth           := 40
         :nDatastrAlign    := 1
         :nHeadstrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cCodCli }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Expedición"
         :cSortOrder       := "dPreCob"
         :bEditValue       := {|| Dtoc( ( D():FacturasClientesCobros( nView ) )->dPreCob ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Vencimiento"
         :cSortOrder       := "dFecVto"
         :bEditValue       := {|| Dtoc( ( D():FacturasClientesCobros( nView ) )->dFecVto ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobro"
         :cSortOrder       := "dEntrada"
         :bEditValue       := {|| Dtoc( ( D():FacturasClientesCobros( nView ) )->dEntrada ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Descripción"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cDescrip }
         :nWidth           := 180
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Importe"
         :cSortOrder       := "nImporte"
         :bEditValue       := {|| nTotRecCli( D():FacturasClientesCobros( nView ), D():Divisas( nView ), if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDatastrAlign    := 1
         :nHeadstrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :bEditValue       := {|| nTotCobCli( D():FacturasClientesCobros( nView ), D():Divisas( nView ), if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDatastrAlign    := 1
         :nHeadstrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Gasto"
         :bEditValue       := {|| nTotGasCli( D():FacturasClientesCobros( nView ), D():Divisas( nView ), if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDatastrAlign    := 1
         :nHeadstrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div"
         :bEditValue       := {|| cSimDiv( ( D():FacturasClientesCobros( nView ) )->cDivPgo, D():Divisas( nView ) ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cCodAge }
         :lHide            := .t.
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Remesa"
         :cSortOrder       := "nNumRem"
         :bEditValue       := {|| Alltrim( str( ( D():FacturasClientesCobros( nView ) )->nNumRem ) ) + "/" + ( D():FacturasClientesCobros( nView ) )->cSufRem }
         :lHide            := .t.
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pagado por"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cPgdoPor }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cDocPgo }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Matriz"
         :cSortOrder       := "cNumMtr"
         :bEditValue       := {|| if( !empty( ( D():FacturasClientesCobros( nView ) )->cNumMtr ), Trans( ( D():FacturasClientesCobros( nView ) )->cNumMtr, "@R #/999999999/##-99" ), "" ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cuenta"
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->cPaisIBAN + ( D():FacturasClientesCobros( nView ) )->cCtrlIBAN + ( D():FacturasClientesCobros( nView ) )->cEntCli + ( D():FacturasClientesCobros( nView ) )->cSucCli + ( D():FacturasClientesCobros( nView ) )->cDigCli + ( D():FacturasClientesCobros( nView ) )->cCtaCli }
         :nWidth           := 200
         :lHide            := .t.
      end with

      oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B"

   oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinAppRec( oWndBrw:oBrw, bEdit, D():FacturasClientesCobros( nView ), , LIBRE_MODE ) );
      TOOLTIP  "(A)ñadir";
      HOTKEY   "A";
      BEGIN GROUP ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      BEGIN GROUP;
      HOTKEY   "M";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL RESOURCE "GC_FOLDER_CUBES_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( CompensarReciboCliente( oWndBrw:oBrw ) );
      TOOLTIP  "(C)ompensar";
      BEGIN GROUP;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_SCREEN ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

    //  lGenRecCli( oWndBrw:oBrw, oMail, IS_MAIL )

   DEFINE BTNSHELL oCobrado RESOURCE "gc_money2_" OF oWndBrw GROUP ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Cobrar" ;
      LEVEL    ACC_EDIT

      if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "Del" OF oWndBrw GROUP ;
         NOBORDER ;
         ACTION   ( lLiquida( oWndBrw:oBrw, .f. ) ) ;
         TOOLTIP  "Pendiente" ;
         FROM     oCobrado ;
         LEVEL    ACC_EDIT

      end if 

   DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( if( validRunReport( "01120" ), TFastVentasRecibos():New():Play(), ) );
      TOOLTIP  "(R)eporting";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( dlgContabilizaReciboCliente( oWndBrw:oBrw ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( dlgContabilizaReciboCliente( oWndBrw:oBrw, "Cambiar estado de recibos", "Contabilizado", .t. ) ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

#ifndef __PDA__

if oUser():lAdministrador()

   DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ReplaceCreator( oWndBrw, D():FacturasClientesCobros( nView ), aItmRecCli() ) ) ;
      TOOLTIP  "Cambiar campos" ;
      LEVEL    ACC_APPD

end if

#endif

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
         ACTION   ( EdtCli( ( D():FacturasClientesCobros( nView ) )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Info" OF oWndBrw ;
         ACTION   ( InfCliente( ( D():FacturasClientesCobros( nView ) )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
         ACTION   ( EdtFacCli( ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "End" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmrecCli() )
      oWndBrw:oActiveFilter:SetFilterType( REC_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   if !empty(oWndBrw)
      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if
   end if 

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION EdtCob( aTmp, aGet, cFacCliP, oBrw, lRectificativa, nSpecialMode, nMode, aNumRec )

	local oDlg
   local oFld
   local oBmpDiv
   local oGetAge
   local cGetAge
   local oGetCaj
   local cGetCaj
   local oGetPgo
   local cGetPgo
   local oGetSubCta
   local cGetSubCta
   local oGetCtaRem
   local cGetCtaRem
   local oGetSubGas
   local cGetSubGas
   local cPorDiv
   local oBmpGeneral
   local oBmpContabilidad
   local oBmpDevolucion
   local oBmpBancos
   local oBmpAsociados
   local oBrwRec
   local oSayTotal
   local oGroup
   local oBrwCompensado

   if empty( nSpecialMode )
      nSpecialMode         := NORMAL_MODE
   end if

   if !IsLogic( lRectificativa )
      lRectificativa       := .f.
   end if

   if empty( cFacCliP )
      cFacCliP             := D():FacturasClientesCobros( nView )
   end if

   cGetAge                 := cNbrAgent( ( cFacCliP )->cCodAge, D():Agentes( nView ) )
   cGetCaj                 := RetFld( ( cFacCliP )->cCodCaj, D():Cajas( nView ), "cNomCaj" )
   cGetPgo                 := RetFld( ( cFacCliP )->cCodPgo, D():FormasPago( nView ), "cDesPago" )
   cPorDiv                 := cPorDiv( ( cFacCliP )->cDivPgo, D():Divisas( nView ) )

   do case
      case nMode == APPD_MODE

         if lRectificativa
            aTmp[ _CTIPREC ]     := "R"
         end if

         if nSpecialMode == LIBRE_MODE
            
            aTmp[ _CTIPREC ]              := "L"
            aTmp[ _CTURREC ]              := cCurSesion( nil, .f. )
            aTmp[ _LSNDDOC ]              := .t.

            if !empty( oClienteCompensar )

               aTmp[ _CDESCRIP ]          := "Recibo matriz para compensar"
               aTmp[ _CCODCLI  ]          := oClienteCompensar:VarGet()
               aTmp[ _NIMPORTE ]          := nTotalRelacionados

               if ( D():Clientes( nView ) )->( dbSeek( aTmp[ _CCODCLI ] ) )

                  aTmp[ _CNOMCLI ]        := ( D():Clientes( nView ) )->Titulo
                  aTmp[ _CCODPGO ]        := ( D():Clientes( nView ) )->CodPago
                  aTmp[ _CCODAGE ]        := ( D():Clientes( nView ) )->cAgente
                  aTmp[ _CCTAREM ]        := ( D():Clientes( nView ) )->cCodRem

                  if !empty( ( D():Clientes( nView ) )->CodPago )
                     aTmp[ _CCTAREC ]     := RetFld( ( D():Clientes( nView ) )->CodPago, D():FormasPago( nView ), "cCtaCobro" )
                     aTmp[ _CCTAGAS ]     := RetFld( ( D():Clientes( nView ) )->CodPago, D():FormasPago( nView ), "cCtaGas" )
                  end if

                  if lBancoDefecto( ( D():Clientes( nView ) )->Cod, D():ClientesBancos( nView ) )

                     aTmp[ _CBNCCLI ]     := ( D():ClientesBancos( nView ) )->cCodBnc
                     aTmp[ _CPAISIBAN ]   := ( D():ClientesBancos( nView ) )->cPaisIBAN
                     aTmp[ _CCTRLIBAN ]   := ( D():ClientesBancos( nView ) )->cCtrlIBAN
                     aTmp[ _CENTCLI ]     := ( D():ClientesBancos( nView ) )->cEntBnc
                     aTmp[ _CSUCCLI ]     := ( D():ClientesBancos( nView ) )->cSucBnc
                     aTmp[ _CDIGCLI ]     := ( D():ClientesBancos( nView ) )->cDigBnc
                     aTmp[ _CCTACLI ]     := ( D():ClientesBancos( nView ) )->cCtaBnc

                  end if

               end if

            end if

         end if

      case nMode == EDIT_MODE

         if aTmp[ _LCONPGO ] .and. !ApoloMsgNoYes( 'La modificación de este recibo puede provocar descuadres contables.' + CRLF + '¿Desea continuar?', 'Recibo ya contabilizado' )
            RETURN .f.
         end if

         if aTmp[ _LCLOPGO ] .and. !oUser():lAdministrador()
            msgStop( "Solo pueden modificar los recibos cerrados los administradores." )
            RETURN .f.
         end if

         if !empty( aTmp[ _CNUMMTR ] )
            nMode       := ZOOM_MODE
         end if

         if aTmp[ _CTIPREC ] == "L" .and. nEstadoMatriz( cFacCliP ) == 2
            aRecibosAgrupados( cFacCliP )
         end if

   end case

   if empty( aTmp[ _CCODCAJ ] )
      aTmp[ _CCODCAJ ]     := oUser():cCaja()
   end if

   lOldDevuelto            := aTmp[ _LDEVUELTO ]

   cOldCodCli              := aTmp[ _CCODCLI ]

   lPgdOld                 := ( cFacCliP )->lCobrado .or. ( cFacCliP )->lRecDto
   nImpOld                 := ( cFacCliP )->nImporte

   DEFINE DIALOG  oDlg ;
      RESOURCE "Recibos" ;
      TITLE    LblTitle( nMode ) + "recibos de clientes"

   if Len( aRecibosMatriz ) <= 0

      REDEFINE FOLDER oFld ;
         ID       500;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Bancos",;
                  "Devolución",;
                  "Contablidad";
         DIALOGS  "Recibos_1",;
                  "Recibos_Bancos",;
                  "Recibos_2",;
                  "Recibos_3"

   else

      REDEFINE FOLDER oFld ;
         ID       500;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Bancos",;
                  "Devolución",;
                  "Contablidad",;
                  "Recibos compensados";
         DIALOGS  "Recibos_1",;
                  "Recibos_Bancos",;
                  "Recibos_2",;
                  "Recibos_3",;
                  "Recibos_5"
   end if

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_money2_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DPRECOB ] VAR aTmp[ _DPRECOB ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         ON HELP  aGet[ _DPRECOB ]:cText( Calendario( aTmp[ _DPRECOB ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DFECVTO ] VAR aTmp[ _DFECVTO ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DFECVTO ]:cText( Calendario( aTmp[ _DFECVTO ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LNOTARQUEO ] VAR aTmp[ _LNOTARQUEO ];
         ID       200 ;
			WHEN 		nMode != ZOOM_MODE ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CTURREC ] VAR aTmp[ _CTURREC ] ;
         ID       335 ;
         PICTURE  "999999" ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       120 ;
         VALID    ( loadCliente( aGet, aTmp ) ) ;
         WHEN     nMode != ZOOM_MODE ;
         ON HELP  ( BrwClient( aGet[ _CCODCLI ], aGet[ _CNOMCLI ] ) );
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ];
         ID       121 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       130 ;
			WHEN 		nMode != ZOOM_MODE ;
         VALID    ( cAgentes( aGet[ _CCODAGE ], D():Agentes( nView ), oGetAge ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oGetAge ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetAge VAR cGetAge ;
         ID       131 ;
         WHEN     .f.;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
         ID       290 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ _CCODPGO ], D():FormasPago( nView ), oGetPgo ), lUpdateSubCta( aGet, aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], oGetPgo ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetPgo VAR cGetPgo ;
         ID       291 ;
         WHEN     .f.;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDESCRIP ] VAR aTmp[ _CDESCRIP ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE GET aGet[ _CPGDOPOR ] VAR aTmp[ _CPGDOPOR ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet [ _CDOCPGO ] VAR aTmp[ _CDOCPGO ] ;
         ID       155 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDIVPGO ] VAR aTmp[ _CDIVPGO ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], nil, nil, @cPorDiv, nil, nil, nil, nil, D():Divisas( nView ) ) );
         PICTURE  "@!";
         ID       170 ;
         IDSAY    172 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], D():Divisas( nView ) ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       171;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GROUP oGroup ID 161 OF oFld:aDialogs[ 1 ] TRANSPARENT

      REDEFINE GET aGet[ _NIMPORTE ] VAR aTmp[ _NIMPORTE ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aGet[ _NIMPCOB ]:cText( aTmp[ _NIMPORTE ] ), .t. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NIMPCOB ] VAR aTmp[ _NIMPCOB ] ;
         ID       190 ;
         IDSAY    191 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ValCobro( aGet, aTmp ) ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NIMPGAS ] VAR aTmp[ _NIMPGAS ] ;
         ID       260 ;
         IDSAY    261 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LCOBRADO ] VAR aTmp[ _LCOBRADO ];
         ID       220 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
			WHEN 		( nMode != ZOOM_MODE .and. empty( aTmp[ _CNUMMTR ] ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DENTRADA ] VAR aTmp[ _DENTRADA ] ;
         ID       230 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. empty( aTmp[ _CNUMMTR ] ) ) ;
         ON HELP  aGet[ _DENTRADA ]:cText( Calendario( aTmp[ _DENTRADA ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      /*
      Cajas____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], D():Cajas( nView ), oGetCaj ) ;
         ID       280 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oGetCaj ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetCaj VAR cGetCaj ;
         ID       281 ;
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

      REDEFINE GET aGet[ _CBNCEMP ] VAR aTmp[ _CBNCEMP ];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ _CBNCEMP], aGet[ _CEPAISIBAN ], aGet[ _CECTRLIBAN ], aGet[ _CENTEMP], aGet[ _CSUCEMP], aGet[ _CDIGEMP], aGet[ _CCTAEMP] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CEPAISIBAN ] VAR aTmp[ _CEPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CECTRLIBAN ] VAR aTmp[ _CECTRLIBAN ] ;
         ID       280 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTEMP] VAR aTmp[ _CENTEMP];
         ID       110 ;
         PICTURE  "9999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP], aTmp[ _CSUCEMP], aTmp[ _CDIGEMP], aTmp[ _CCTAEMP], aGet[ _CDIGEMP] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCEMP] VAR aTmp[ _CSUCEMP];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "9999" ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP], aTmp[ _CSUCEMP], aTmp[ _CDIGEMP], aTmp[ _CCTAEMP], aGet[ _CDIGEMP] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGEMP] VAR aTmp[ _CDIGEMP];
         ID       130 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAEMP ] VAR aTmp[ _CCTAEMP ];
         ID       140 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() )  ;
         OF       oFld:aDialogs[2]

      /*
       Banco del cliente--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBNCCLI] VAR aTmp[ _CBNCCLI];
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ _CBNCCLI], aGet[ _CPAISIBAN], aGet[ _CCTRLIBAN], aGet[ _CENTCLI], aGet[ _CSUCCLI], aGet[ _CDIGCLI], aGet[ _CCTACLI], aTmp[ _CCODCLI] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CPAISIBAN] VAR aTmp[ _CPAISIBAN] ;
         PICTURE  "@!" ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN], aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CCTRLIBAN] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTRLIBAN] VAR aTmp[ _CCTRLIBAN] ;
         ID       260 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN], aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CCTRLIBAN] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTCLI] VAR aTmp[ _CENTCLI];
         ID       210 ;
         PICTURE  "9999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCCLI] VAR aTmp[ _CSUCCLI];
         ID       220 ;
         PICTURE  "9999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGCLI] VAR aTmp[ _CDIGCLI];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99";
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTACLI] VAR aTmp[ _CCTACLI];
         ID       240 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      /*
      Recibo remesado----------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ _LREMESA ] VAR aTmp[ _LREMESA ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NNUMREM ] VAR aTmp[ _NNUMREM ];
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUFREM ] VAR aTmp[ _CSUFREM ];
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAREM ] VAR aTmp[ _CCTAREM ] ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oGetCtaRem:cText( oRetFld( aTmp[ _CCTAREM ], oCtaRem:oDbf ) ), .t. );
         ON HELP  ( oCtaRem:Buscar( aGet[ _CCTAREM ] ) ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET oGetCtaRem VAR cGetCtaRem ;
         ID       291 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Segunda caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpDevolucion ;
         ID       500 ;
         RESOURCE "gc_money2_delete_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE CHECKBOX aGet[ _LDEVUELTO ] VAR aTmp[ _LDEVUELTO ];
         ID       100 ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( lChangeDevolucion( aGet, aTmp, .f. ) ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _DFECDEV ] VAR aTmp[ _DFECDEV ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CMOTDEV ] VAR aTmp[ _CMOTDEV ] ;
         ID       120 ;
         WHEN     ( aTmp[ _LCOBRADO ] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CRECDEV ] VAR aTmp[ _CRECDEV ] ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 3 ]

      /*
      Cuentas contables--------------------------------------------------------
      */

      REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "gc_folders2_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[ _LCONPGO ] VAR aTmp[ _LCONPGO ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CCTAREC ] VAR aTmp[ _CCTAREC ] ;
         ID       240 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAREC ], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAREC ], nil, oGetSubCta ) ) ;
         OF       oFld:aDialogs[ 4 ]

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CCTAGAS ] VAR aTmp[ _CCTAGAS ] ;
         ID       270 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAGAS ], oGetSubGas ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAGAS ], nil, oGetSubGas ) );
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET oGetSubGas VAR cGetSubGas ;
         ID       271 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 4 ]

      /*
      Remesa___________________________________________________________________
		*/

      REDEFINE CHECKBOX aGet[_LRECIMP] VAR aTmp[_LRECIMP];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       161 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       162 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[ _LESPERADOC ] VAR aTmp[ _LESPERADOC ];
         ID       165 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 4 ]

      /*
      Centro de coste______________________________________________________________
      */

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       280 ;
         IDTEXT   281 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _DFECCRE ] VAR aTmp[ _DFECCRE ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CHORCRE ] VAR aTmp[ _CHORCRE ] ;
         ID       310 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 4 ]

      /*
      Montamos la pestaña si somos un recibo compensado
      */

      if Len( aRecibosMatriz ) > 0

         REDEFINE BITMAP oBmpGeneral ;
            ID       500 ;
            RESOURCE "gc_folder_cubes_48" ;
            TRANSPARENT ;
            OF       oFld:aDialogs[ 5 ]

         oBrwCompensado                   := IXBrowse():New( oFld:aDialogs[ 5 ] )
         oBrwCompensado:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwCompensado:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         oBrwCompensado:nMarqueeStyle     := 6
         oBrwCompensado:lRecordSelector   := .f.

         oBrwCompensado:SetArray( aRecibosMatriz, , , .f. )

         oBrwCompensado:CreateFromResource( 200 )

         with object ( oBrwCompensado:AddCol() )
            :cHeader          := "Estado"
            :nHeadBmpNo       := 1
            :bEditValue       := {|| hGet( aRecibosMatriz[ oBrwCompensado:nArrayAt ], "Estado" ) }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( oBrwCompensado:AddCol() )
            :cHeader          := "Numero"
            :bstrData         := {|| hGet( aRecibosMatriz[ oBrwCompensado:nArrayAt ], "Número" ) }
            :nWidth           := 100
         end with

         with object ( oBrwCompensado:AddCol() )
            :cHeader          := "Fecha"
            :bstrData         := {|| hGet( aRecibosMatriz[ oBrwCompensado:nArrayAt ], "Fecha" ) }
            :nWidth           := 65
         end with

         with object ( oBrwCompensado:AddCol() )
            :cHeader          := "Vencimiento"
            :bstrData         := {|| hGet( aRecibosMatriz[ oBrwCompensado:nArrayAt ], "Vencimiento" ) }
            :nWidth           := 65
         end with

         with object ( oBrwCompensado:AddCol() )
            :cHeader          := "Pago"
            :bstrData         := {|| hGet( aRecibosMatriz[ oBrwCompensado:nArrayAt ], "Pago" ) }
            :nWidth           := 65
         end with

         with object ( oBrwCompensado:AddCol() )
            :cHeader          := "Importe"
            :bstrData         := {|| hGet( aRecibosMatriz[ oBrwCompensado:nArrayAt ], "Importe" ) }
            :nWidth           := 65
            :nDatastrAlign    := 1
            :nHeadstrAlign    := 1
         end with

      end if

      /*
      Botones__________________________________________________________________
		*/

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, cFacCliP, oBrw, oDlg, nMode, nSpecialMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( KillTrans( oDlg ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, cFacCliP, oBrw, oDlg, nMode, nSpecialMode ) } )
      end if

      oDlg:bStart          := {|| StartEdtRec( aTmp, aGet, nMode ) }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( EdtRecMenu( aTmp, oDlg ) )

   aRecibosMatriz          := {}

   EndEdtRecMenu()

   if !empty( oBmpDiv )
      oBmpDiv:End()
   end if

   if !empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !empty( oBmpDevolucion )
      oBmpDevolucion:End()
   end if

   if !empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

   if !empty( oBmpBancos )
      oBmpBancos:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION StartEdtRec( aTmp, aGet, nMode )

   cursorWait()

   aGet[ _CDIVPGO       ]:lValid()
   aGet[ _CCTAREC       ]:lValid()
   aGet[ _CCTAGAS       ]:lValid()
   aGet[ _CCTAREM       ]:lValid()
   aGet[ _CCENTROCOSTE  ]:lValid()
   aGet[ _DPRECOB       ]:SetFocus()
   aGet[ _CCODPGO       ]:lValid()
   aGet[ _CCODAGE       ]:lValid()

   if nMode != ZOOM_MODE
      lChangeDevolucion( aGet, aTmp, .t. )
   end if

   cursorWE()

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oDlg )

   oDlg:End()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Cambia el estado de un recibo
*/

STATIC FUNCTION ChgState( lState )

   DEFAULT lState := !( D():FacturasClientesCobros( nView ) )->lConPgo

   if ( D():FacturasClientesCobros( nView ) )->lConPgo != lState .and. dbLock( D():FacturasClientesCobros( nView ) )
      ( D():FacturasClientesCobros( nView ) )->lConPgo := lState
      ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
   end if

RETURN NIL

//-------------------------------------------------------------------------//

STATIC FUNCTION GetReciboCliente( cCodCli, oBrwRec )

   local lResult  := .t.
   local cNumRec  := ""
   local aRecibosSeleccionados

   if empty( cCodCli )
      MsgStop( "Tiene que seleccionar un cliente." )
      RETURN nil
   end if

   aRecibosSeleccionados      := browseRecCli( cCodCli, D():FacturasClientesCobros( nView ), D():Divisas( nView ) )

   if isArray( aRecibosSeleccionados ) .and. Len( aRecibosSeleccionados ) > 0

      for each cNumRec in aRecibosSeleccionados

         if lResult .and. RetFld( cNumRec, D():FacturasClientesCobros( nView ), "lCobrado", "nNumFac" )
            msgStop( "Recibo ya cobrado.", "Recibo: " + cNumRec )
            lResult := .f.
         end if

         if lResult .and. RetFld( cNumRec, D():FacturasClientesCobros( nView ), "lRemesa", "nNumFac" )
            msgStop( "Recibo ya remesado.", "Recibo: " + cNumRec )
            lResult := .f.
         end if 

         if lResult .and. !empty( RetFld( cNumRec, D():FacturasClientesCobros( nView ), "cNumMtz", "nNumFac" ) )
            msgStop( "Recibo ya pertenece a otra matriz.", "Recibo: " + cNumRec )
            lResult := .f.
         end if 

         if lResult .and. aScan( aRecibosRelacionados, cNumRec ) != 0
            msgStop( "Recibo ya incluido.", "Recibo: " + cNumRec )
            lResult := .f.
         end if

         if lResult
            aadd( aRecibosRelacionados, cNumRec )
         end if

         lResult := .t.

      next

      oBrwRec:Refresh()
       
   end if

   setTotalRelacionados()

RETURN nil

//-------------------------------------------------------------------------//

STATIC FUNCTION DelReciboCliente( oBrwRec )
   
   local n
   local aDelete  := {}
   local nRecDel

   for each nRecDel in oBrwRec:aSelected
      aAdd( aDelete, aRecibosRelacionados[ nRecDel ] )
   end if

   for each nRecDel in aDelete

      n := aScan( aRecibosRelacionados, nRecDel )

      if n != 0

         aDel( aRecibosRelacionados, n )
         aSize( aRecibosRelacionados, Len( aRecibosRelacionados ) - 1 )

      end if

   end if

   setTotalRelacionados()
   
   if !empty( oBrwRec )
      oBrwRec:Refresh()
   end if

RETURN nil

//-------------------------------------------------------------------------//

/*
Contabiliza los recibos
*/

STATIC FUNCTION dlgContabilizaReciboCliente( oBrw, cTitle, cOption, lChgState )

	local oDlg
   local oBrwCon
   local cSerIni
   local cSerFin
   local oDocIni
   local oDocFin
   local nDocIni
   local nDocFin
   local cSufIni
   local cSufFin
   local nNumIni
   local nNumFin
   local oMtrInf
   local nMtrInf
   local oSerIni
   local oSerFin
   local oBtnCancel
   local nRad        := 1
   local oSimula
   local lSimula     := .t.
   local dDesde      := CtoD( "01/01/" + str( Year( Date() ) ) )
   local dHasta      := Date()
   local nRecFac     := ( D():FacturasClientes( nView ) )->( Recno() )
   local nOrdFac     := ( D():FacturasClientes( nView ) )->( OrdSetFocus( 1 ) )
   local nRecRec     := ( D():FacturasClientesCobros( nView ) )->( Recno() )
   local nOrdRec     := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( 1 ) )
   local cTipo       := "Todas"
   local oTree
   local oImageList

   DEFAULT cTitle    := "Contabilizar recibos"
   DEFAULT cOption   := "Simular resultados"
   DEFAULT lChgState := .f.

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ),     Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ),   Rgb( 255, 0, 255 ) )

   cSerIni           := ( D():FacturasClientesCobros( nView ) )->cSerie
   cSerFin           := ( D():FacturasClientesCobros( nView ) )->cSerie
   nDocIni           := ( D():FacturasClientesCobros( nView ) )->nNumFac
   nDocFin           := ( D():FacturasClientesCobros( nView ) )->nNumFac
   cSufIni           := ( D():FacturasClientesCobros( nView ) )->cSufFac
   cSufFin           := ( D():FacturasClientesCobros( nView ) )->cSufFac
   nNumIni           := ( D():FacturasClientesCobros( nView ) )->nNumRec
   nNumFin           := ( D():FacturasClientesCobros( nView ) )->nNumRec

   if len( oBrw:aSelected ) > 1
      nRad           := 1
   else
      nRad           := 3
   end if 

   DEFINE DIALOG oDlg ;
      RESOURCE "CONTABILIZA_RECIBOS_CLIENTES" ;
      TITLE    ( cTitle )

   REDEFINE COMBOBOX cTipo ;
      ITEMS    { "Todas", "Facturas", "Rectificativas" } ;
      ID       80 ;
      OF       oDlg

   REDEFINE RADIO nRad ;
      ID       90, 91, 92, 93 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      WHEN     ( nRad == 3 );
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      WHEN     ( nRad == 3 );
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      WHEN     ( nRad == 3 ) ;
      PICTURE  "999999999" ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
      WHEN     ( nRad == 3 ) ;
      PICTURE  "999999999" ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      WHEN     ( nRad == 3 ) ;
      PICTURE  "##" ;
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      WHEN     ( nRad == 3 ) ;
      PICTURE  "##" ;
		OF 		oDlg

   REDEFINE GET nNumIni ;
      ID       160 ;
      WHEN     ( nRad == 3 ) ;
      PICTURE  "99" ;
		OF 		oDlg

   REDEFINE GET nNumFin ;
      ID       170 ;
      WHEN     ( nRad == 3 ) ;
      PICTURE  "99" ;
		OF 		oDlg

   REDEFINE GET dDesde ;
      ID       310 ;
      WHEN     ( nRad == 4 ) ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET dHasta ;
      ID       320 ;
      WHEN     ( nRad == 4 ) ;
      SPINNER ;
      OF       oDlg

   REDEFINE CHECKBOX oSimula VAR lSimula;
      ID       190 ;
		OF 		oDlg

   oTree             := TTreeView():Redefine( 180, oDlg )
   oTree:bLDblClick  := {|| TreeChanged( oTree ) }

   REDEFINE APOLOMETER oMtrInf ;
      VAR      nMtrInf ;
      NOPERCENTAGE ;
      ID       200;
      OF       oDlg

   oMtrInf:SetTotal( ( D():FacturasClientesCobros( nView ) )->( OrdKeyCount() ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( initContabilizaReciboCliente( cSerIni + str( nDocIni, 9 ) + cSufIni + str( nNumIni ), cSerFin + str( nDocFin, 9 ) + cSufFin + str( nNumFin ), dDesde, dHasta, nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| initContabilizaReciboCliente( cSerIni + str( nDocIni, 9 ) + cSufIni + str( nNumIni ), cSerFin + str( nDocFin, 9 ) + cSufFin + str( nNumFin ), dDesde, dHasta, nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf ) } )

   oDlg:bStart := {|| startContabilizaReciboCliente( oSerIni, oSimula, cOption ) }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( D():FacturasClientes( nView ) )->( dbGoTo( nRecFac ) )
   ( D():FacturasClientes( nView ) )->( OrdSetFocus( nOrdFac ) )
   ( D():FacturasClientesCobros( nView ) )->( dbGoTo( nRecRec ) )
   ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrdRec ) )

   oImageList:End()

   oTree:Destroy()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION startContabilizaReciboCliente( oSerIni, oSimula, cOption )

   oSerIni:SetFocus()

   setWindowText( oSimula:hWnd, cOption )

   oSimula:Refresh()

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !empty( oItemTree ) .and. !empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION initContabilizaReciboCliente( cDocIni, cDocFin, dDesde, dHasta, nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf )

   local aPos
   local bWhile
   local lWhile         := .t.
   local aSimula        := {}
   local nRecord
   local nRecno         := ( D():FacturasClientesCobros( nView ) )->( Recno() )
   local nOrden         := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "nNumFac" ) )
   local lErrorFound    := .f.
   local lReturn

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lSimula
      aPos              := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   /*
   Desabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oDlg:Disable()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   oTree:Enable()
   oTree:DeleteAll()

   do case
      case ( nRad == 1 )

         for each nRecord in oWndBrw:aSelected 

            ( D():FacturasClientesCobros( nView ) )->( dbgoto( nRecord ) )
         
            makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, nil )

            oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( ordkeyno() ) )
         
         next

      case ( nRad == 2 )

         ( D():FacturasClientesCobros( nView ) )->( dbGoTop() )
         while ( lWhile .and. !( D():FacturasClientesCobros( nView ) )->( eof() ) )

            makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, nil )

            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

            oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( ordkeyno() ) )

         end do

      case ( nRad == 3 )

         ( D():FacturasClientesCobros( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile .and. (  ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) >= cDocIni .and. ;
                                 ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) <= cDocFin .and. ;
                                 !( D():FacturasClientesCobros( nView ) )->( eof() ) ) )

            makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, nil )

            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

            oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( OrdKeyNo() ) )

         end do

      case ( nRad == 4 )

         ( D():FacturasClientesCobros( nView ) )->( dbGoTop() )
         while ( lWhile .and. !( D():FacturasClientesCobros( nView ) )->( eof() ) )

            if ( D():FacturasClientesCobros( nView ) )->lCobrado           .and. ;
               ( D():FacturasClientesCobros( nView ) )->dEntrada >= dDesde .and. ;
               ( D():FacturasClientesCobros( nView ) )->dEntrada <= dHasta

               makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, nil )

            end if 

            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

            oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( OrdKeyNo() ) )

         end do

   end if

   /*
   Creamos el fichero de A3----------------------------------------------------
   */

   if lAplicacionA3()
      EnlaceA3():GetInstance():Render():WriteASCII()
      EnlaceA3():DestroyInstance()
   end if

   oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( OrdKeyCount() ) )

   /*
   Vamos a mostrar el resultado------------------------------------------------
   */

   ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrden ) )
   ( D():FacturasClientesCobros( nView ) )->( dbGoTo( nRecno ) )

   oBtnCancel:bAction   := {|| oDlg:End() }

   if lSimula
      WndCenter( oDlg:hWnd ) 
   end if

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, aSimula )

   local lRETURN     := .f.

   do case
      case ( cTipo == "Facturas" .or. cTipo == "Todas" ) .and. empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )

         if lChgState
            lRETURN  := ChgState( lSimula )
         else
            lRETURN  := ContabilizaReciboCliente( nil, oTree, lSimula, aSimula, D():FacturasClientes( nView ), D():FacturasClientesCobros( nView ), D():FormasPago( nView ), D():Clientes( nView ), D():Divisas( nView ), .f. )
         end if

      case ( cTipo == "Rectificativas" .or. cTipo == "Todas" ) .and. !empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )

         if lChgState
            lRETURN  := ChgState( lSimula )
         else
            lRETURN  := ContabilizaReciboCliente( nil, oTree, lSimula, aSimula, D():FacturasRectificativas( nView ), D():FacturasClientesCobros( nView ), D():FormasPago( nView ), D():Clientes( nView ), D():Divisas( nView ), .f. )
         end if

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

Function nTotRecCli( uFacCliP, cDbfDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec

   if !empty( nView )
      DEFAULT uFacCliP  := D():FacturasClientesCobros( nView )
      DEFAULT cDbfDiv   := D():Divisas( nView )
   end if

   DEFAULT cDivRet      := cDivEmp()
   DEFAULT lPic         := .f.

   if IsObject( uFacCliP )
      nTotRec           := uFacCliP:nImporte
      cDivPgo           := uFacCliP:cDivPgo
   else
      nTotRec           := ( uFacCliP )->nImporte
      cDivPgo           := ( uFacCliP )->cDivPgo
   end if

   nRouDiv              := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv              := cPorDiv( cDivPgo, cDbfDiv )
   nTotRec              := Round( nTotRec, nRouDiv )

   if cDivRet != cDivPgo
      nRouDiv           := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv           := cPorDiv( cDivRet, cDbfDiv )
      nTotRec           := nCnv2Div( nTotRec, cDivPgo, cDivRet )
   end if

RETURN ( if( lPic, Trans( nTotRec, cPorDiv ), nTotRec ) )

//------------------------------------------------------------------------//

STATIC FUNCTION nTotalArrayRelacionados()

   local nImporte       := 0
   local cRecibo        := ""

   if isArray( aRecibosRelacionados ) .and.;
      len( aRecibosRelacionados ) > 0
      
      for each cRecibo in aRecibosRelacionados
         nImporte       += RetFld( cRecibo, D():FacturasClientesCobros( nView ), "nImporte", "nNumFac" )
      next

   end if

RETURN nImporte

//------------------------------------------------------------------------//

function setTotalRelacionados()

   nTotalRelacionados   := nTotalArrayRelacionados()

   if !empty( oTotalRelacionados )
      oTotalRelacionados:Refresh()
   end if 

RETURN .t.

//------------------------------------------------------------------------//

function nTotCobCli( uFacCliP, uDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec
   local nTotCob
   local lRecCob
   local cDbfDiv

   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uFacCliP ) == "O"
      cDivPgo        := uFacCliP:cDivPgo
      nTotRec        := uFacCliP:nImporte
      nTotCob        := uFacCliP:nImpCob
      lRecCob        := uFacCliP:lCobrado
   else
      cDivPgo        := ( uFacCliP )->cDivPgo
      nTotRec        := ( uFacCliP )->nImporte
      nTotCob        := ( uFacCliP )->nImpCob
      lRecCob        := ( uFacCliP )->lCobrado
   end if

   if ValType( uDiv ) == "O"
      cDbfDiv        := uDiv:cAlias
   else
      cDbfDiv        := uDiv
   end id

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   if lRecCob

      if nTotCob == 0
         nTotCob     := Round( nTotRec, nRouDiv )
      else
         nTotCob     := Round( nTotCob, nRouDiv )
      end if

   else

      nTotCob        := 0

   end if

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotCob        := nCnv2Div( nTotRec, cDivPgo, cDivRet )
   end if

RETURN if( lPic, Trans( nTotCob, cPorDiv ), nTotCob )

//------------------------------------------------------------------------//

function nTotGasCli( uFacCliP, uDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec
   local nTotCob
   local lRecCob
   local cDbfDiv

   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uFacCliP ) == "O"
      cDivPgo        := uFacCliP:cDivPgo
      nTotRec        := uFacCliP:nImporte
      nTotCob        := uFacCliP:nImpCob
      lRecCob        := uFacCliP:lCobrado
   else
      cDivPgo        := ( uFacCliP )->cDivPgo
      nTotRec        := ( uFacCliP )->nImporte
      nTotCob        := ( uFacCliP )->nImpCob
      lRecCob        := ( uFacCliP )->lCobrado
   end if

   if ValType( uDiv ) == "O"
      cDbfDiv        := uDiv:cAlias
   else
      cDbfDiv        := uDiv
   end if

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   if lRecCob

      if nTotCob != 0
         nTotRec     -= nTotCob
         nTotRec     := Round( nTotRec, nRouDiv )
      else
         nTotRec     := 0
      end if

   else

      nTotRec        := 0

   end if

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet )
   end if

RETURN if( lPic, Trans( nTotRec, cPorDiv ), nTotRec )

//------------------------------------------------------------------------//

function nImpRecCli( cFacCliP, cDbfDiv )

   local cImp

   DEFAULT cFacCliP     := D():FacturasClientesCobros( nView )
   DEFAULT cDbfDiv      := D():Divisas( nView )

   if ( cFacCliP )->lImpEur
      cImp           := nTotRecCli( cFacCliP, cDbfDiv, "EUR", .t. )
   else
      cImp           := nTotRecCli( cFacCliP, cDbfDiv, cDivEmp(), .t. )
   end if

RETURN ( cImp )

//------------------------------------------------------------------------//

function cTxtRecCli( cFacCliP, cDbfDiv )

   local cImp
   local lMas        := .t.

   DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )

   if ( cFacCliP )->lImpEur
      lMas           := lMasDiv( "EUR", cDbfDiv )
      cImp           := Num2Text( nTotRecCli( cFacCliP, cDbfDiv, "EUR", .f. ), lMas )
   else
      lMas           := lMasDiv( ( cFacCliP )->cDivPgo, cDbfDiv )
      cImp           := Num2Text( nTotRecCli( cFacCliP, cDbfDiv, ( cFacCliP )->cDivPgo, .f. ), lMas )
   end if

RETURN ( cImp )

//------------------------------------------------------------------------//

Function cCtaRecCli( cFacCliP, cBncCli )

   DEFAULT cFacCliP     := D():FacturasClientesCobros( nView )
   DEFAULT cBncCli      := D():ClientesBancos( nView )

RETURN ( cClientCuenta( ( cFacCliP )->cCodCli, cBncCli ) )

//------------------------------------------------------------------------//
//
// Sincroniza los recibos con las facturas de clientes
//

function SynRecCli( cPath )

   local cDiv
   local cIva
   local cFPago
   local oBlock
   local oError
   local nTotFac
   local nTotRec
   local cClient
   local cFacCliT
   local cFacCliP
   local cFacCliL
   local cAntCliT
   local cFacRecT
   local cFacRecL

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliT", @cFacCliT ) ) EXCLUSIVE
   if !lAIS() ; ( cFacCliT )->( ordListAdd( cPath + "FACCLIT.CDX" ) ); else ; ordSetFocus( 1 ) ; end 

   USE ( cPath + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliL", @cFacCliL ) ) EXCLUSIVE
   if !lAIS() ; ( cFacCliL )->( ordListAdd( cPath + "FACCLIL.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliP", @cFacCliP ) ) EXCLUSIVE
   if !lAIS() ; ( cFacCliP )->( ordListAdd( cPath + "FACCLIP.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "AntCliT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "AntCliT", @cAntCliT ) )
   if !lAIS() ; ( cAntCliT )->( ordListAdd( cPath + "AntCliT.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACRECT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecT", @cFacRecT ) ) EXCLUSIVE
   if !lAIS() ; ( cFacRecT )->( ordListAdd( cPath + "FacRecT.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACRECL.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecL", @cFacRecL ) ) EXCLUSIVE
   if !lAIS() ; ( cFacRecL )->( ordListAdd( cPath + "FacRecL.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "Client", @cClient ) )
   if !lAIS() ; ( cClient )->( ordListAdd( cPatCli() + "CLIENT.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FPago", @cFPago ) )
   if !lAIS() ; ( cFPago )->( ordListAdd( cPatEmp() + "FPAGO.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "Divisas", @cDiv ) )
   if !lAIS() ; ( cDiv )->( ordListAdd( cPatDat() + "DIVISAS.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIva", @cIva ) )
   if !lAIS() ; ( cIva )->( ordListAdd( cPatDat() + "TIVA.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   ( cFacCliP )->( OrdSetFocus( 0 ) )
   ( cFacCliP )->( dbGoTop() )

   while !( cFacCliP )->( eof() )

      if empty( ( cFacCliP )->cSufFac )
         ( cFacCliP )->cSufFac      := "00"
      end if

      // Casos raros ----------------------------------------------------------

      if ( cFacCliP )->nImpCob == 0 .and. ( cFacCliP )->lCobrado
         ( cFacCliP )->nImpCob      := ( cFacCliP )->nImporte
      end if

      if ( cFacCliP )->nImpCob > ( cFacCliP )->nImporte
         ( cFacCliP )->nImpCob      := ( cFacCliP )->nImporte
      end if      

      // Valores por defecto --------------------------------------------------

      if empty( ( cFacCliP )->cTurRec )
         ( cFacCliP )->cTurRec      := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "cTurFac" )
      end if

      if empty( ( cFacCliP )->cNomCli )
         ( cFacCliP )->cNomCli      := retClient( ( cFacCliP )->cCodCli, cClient )
      end if

      if empty( ( cFacCliP )->cCodCaj )
         if ( cFacCliP )->cTipRec == "R"
            ( cFacCliP )->cCodCaj   := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacRecT, "CCODCAJ" )
         else
            ( cFacCliP )->cCodCaj   := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "CCODCAJ" )
         end if
      end if

      if empty( ( cFacCliP )->cCodUsr )
         if ( cFacCliP )->cTipRec == "R"
            ( cFacCliP )->cCodUsr   := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacRecT, "CCODUSR" )
         else
            ( cFacCliP )->cCodUsr   := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "CCODUSR" )
         end if
      end if

      if empty( ( cFacCliP )->cCodPgo )
         if ( cFacCliP )->cTipRec == "R"
            ( cFacCliP )->cCodPgo   := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacRecT, "cCodPago" )
         else
            ( cFacCliP )->cCodPgo   := RetFld( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "cCodPago" )
         end if
      end if

      if empty( ( cFacCliP )->cCtaRec )
         ( cFacCliP )->cCtaRec      := RetFld( ( cFacCliP )->cCodPgo, cFPago, "cCtaCobro" )
      end if

      if empty( ( cFacCliP )->cCtaGas )
         ( cFacCliP )->cCtaGas      := RetFld( ( cFacCliP )->cCodPgo, cFPago, "cCtaGas" )
      end if

      if empty( ( cFacCliP )->cCtaCli )
         ( cFacCliP )->cCtaCli      := RetFld( ( cFacCliP )->cCodCli, cClient, "SubCta" )
      end if

      /*
      Comprobamos que los números de cuenta tenga bien los cálculos de control
      */

      if !( cFacCliP )->lCobrado
         ( cFacCliP )->cDigCli      := cDgtControl( ( cFacCliP )->cEntCli, ( cFacCliP )->cSucCli, ( cFacCliP )->cDigCli, ( cFacCliP )->cCtaCli )
         ( cFacCliP )->cCtrlIBAN    := IbanDigit( ( cFacCliP )->cPaisIBAN, ( cFacCliP )->cEntCli, ( cFacCliP )->cSucCli, ( cFacCliP )->cDigCli, ( cFacCliP )->cCtaCli )
      end if

      ( cFacCliP )->( dbSkip() )

   end while

   ( cFacCliP )->( OrdSetFocus( 1 ) )

   // Calculo de totales----------------------------------------------------

   ( cFacCliT )->( OrdSetFocus( 0 ) )
   ( cFacCliT )->( dbGoTop() )

   while !( cFacCliT )->( eof() )

      nTotFac  := nTotFacCli( ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, cAntCliT, nil, nil, .f. )
      nTotRec  := nTotalRecibosGeneradosFacturasCliente( ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliP, cIva, cDiv )

      // Si el importe de la factura es mayor q el de registros----------------

      if abs( nTotFac ) > abs( nTotRec )
         GenPgoFacCli( ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliL, cFacCliP, cAntCliT, cClient, cFPago, cDiv, cIva, APPD_MODE, .f. )
      end if

      ChkLqdFacCli( nil, cFacCliT, cFacCliL, cFacCliP, cAntCliT, cIva, cDiv )

      ( cFacCliT )->( dbSkip() )

      SysRefresh()

   end while

   ( cFacCliT )->( OrdSetFocus( 1 ) )

   /*
   Facturas Rectificativas-----------------------------------------------------
   */

   ( cFacRecT )->( OrdSetFocus( 0 ) )
   ( cFacRecT )->( dbGoTop() )

   while !( cFacRecT )->( eof() )

      // Calculo de totales----------------------------------------------------

      nTotFac  := nTotFacRec( ( cFacRecT )->cSerie + str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, cFacRecL, cIva, cDiv )
      nTotRec  := nTotalRecibosGeneradosRectificativasCliente( ( cFacRecT )->cSerie + str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, cFacCliP, cIva, cDiv )

      // Si el importe de la factura es mayor q el de registros----------------

      if abs( nTotFac ) > abs( nTotRec )
         GenPgoFacRec( ( cFacRecT )->cSerie + str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, cFacRecL, cFacCliP, cClient, cFPago, cDiv, cIva, APPD_MODE, .f. )
      end if

      ChkLqdFacRec( nil, cFacRecT, cFacRecL, cFacCliP, cIva, cDiv )

      ( cFacRecT )->( dbSkip() )

      SysRefresh()

   end while

   ( cFacRecT )->( OrdSetFocus( 1 ) )

   /*
   Pagos-----------------------------------------------------------------------
   */

   ( cFacCliP )->( ordSetFocus( 0 ) )
   ( cFacCliP )->( dbGoTop() )

   while !( cFacCliP )->( eof() )

      if !( ( cFacCliP )->cSerie >= "A" .and. ( cFacCliP )->cSerie <= "Z" )
         ( cFacCliP )->( dbDelete() )
      end if

      ( cFacCliP )->( dbSkip() )

   end while 

   ( cFacCliP )->( ordSetFocus( 1 ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cFacCliT )
   CLOSE ( cFacCliL )
   CLOSE ( cFacCliP )
   CLOSE ( cAntCliT )
   CLOSE ( cFacRecT )
   CLOSE ( cFacRecL )
   CLOSE ( cDiv     )
   CLOSE ( cIva     )
   CLOSE ( cClient  )
   CLOSE ( cFPago   )

RETURN nil

//------------------------------------------------------------------------//

STATIC FUNCTION lGenRecCli( oBrw, oBtn, nDevice )

   local bAction
   local nOrdAnt     := ( D():Documentos( nView ) )->( OrdSetFocus( "cTipo" ) )

   DEFAULT nDevice   := IS_PRINTER

   IF !( D():Documentos( nView ) )->( dbSeek( "RF" ) )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay recibos de clientes predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->CTIPO == "RF" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenRecCli( nDevice, ( D():Documentos( nView ) )->CODIGO, "Imprimiendo recibos de clientes" )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      END DO

   END IF

   ( D():Documentos( nView ) )->( OrdSetFocus( nOrdAnt ) )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION bGenRecCli( nDevice, cCodDoc, cTitle )

   local nDev  := by( nDevice )
   local cCod  := by( cCodDoc   )
   local cTit  := by( cTitle    )

RETURN {|| ImpPago( nil, nDev, cCod, cTit ) }

//---------------------------------------------------------------------------//

FUNCTION BrwRecCli( uGet, cFacCliP, cClient, cDiv )

	local oDlg
	local oBrw
   local nOrd        
	local aGet1
	local cGet1
   local cNumRec
   local nRecAnt
	local nOrdAnt
	local oCbxOrd
   local cCbxOrd
   local aCbxOrd     := {  "Número",;
                           "Código cliente",;
                           "Nombre cliente",;
                           "Fecha expedición",;
                           "Fecha vencimiento",;
                           "Fecha cobro",;
                           "Importe",;
                           "Forma pago",;
                           "Agente" }

   nOrd              := GetBrwOpt( "BrwRecCli" )
   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   cNumRec           := ""

   nRecAnt           := ( cFacCliP )->( Recno() )
   nOrdAnt           := ( cFacCliP )->( OrdSetFocus( nOrd ) )                         

   ( cFacCliP )->( dbSetFilter( {|| !Field->lCobrado }, "!lCobrado" ) )
   ( cFacCliP )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Recibos de clientes"

		REDEFINE GET aGet1 VAR cGet1;
			ID          104 ;
			PICTURE     "@!" ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, cFacCliP, .f., , , , , 10 ) );
         VALID       ( OrdClearScope( oBrw, cFacCliP ) );
         BITMAP      "FIND" ;
         OF          oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR         cCbxOrd ;
			ID          102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( cFacCliP )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), aGet1:SetFocus() ) ;
         OF          oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias             := cFacCliP
      oBrw:cName              := "Browse de recibos de cliente"
      oBrw:bLDblClick         := {|| oDlg:end( IDOK ) }

      oBrw:nMarqueeStyle      := 6

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Cn. Contabilizado"
         :bstrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lConPgo }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Co. Cobrado"
         :bstrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lCobrado }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Tipo"
         :bEditValue          := {|| if( !empty( ( cFacCliP )->cTipRec ), "Rectificativa", "" ) }
         :nWidth              := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumFac"
         :bEditValue          := {|| ( cFacCliP )->cSerie + "/" + AllTrim( str( ( cFacCliP )->nNumFac ) ) + "-" + Alltrim( str( ( cFacCliP )->nNumRec ) ) }
         :nWidth              := 95
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Delegación"
         :bEditValue          := {|| ( cFacCliP )->cSufFac }
         :nWidth              := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Código cliente"
         :cSortOrder          := "cCodCli"
         :bEditValue          := {|| ( cFacCliP )->cCodCli }
         :nWidth              := 80
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre cliente"
         :cSortOrder          := "cNomCli"
         :bEditValue          := {|| ( cFacCliP )->cNomCli }
         :nWidth              := 280
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Forma pago"
         :cSortOrder          := "cCodPgo"
         :bEditValue          := {|| ( cFacCliP )->cCodPgo + " - " + cNbrFPago( ( cFacCliP )->cCodPgo ) }
         :nWidth              := 200
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Agente"
         :cSortOrder          := "cCodAge"
         :bEditValue          := {|| ( cFacCliP )->cCodAge + " - " + RetNbrAge( ( cFacCliP )->cCodAge ) }
         :nWidth              := 280
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Importe"
         :cSortOrder          := "nImporte"
         :bEditValue          := {|| nTotRecCli( cFacCliP, cDiv, cDivEmp(), .t. ) }
         :nWidth              := 100
         :nDatastrAlign       := 1
         :nHeadstrAlign       := 1
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( cFacCliP )->cDivPgo, cDiv ) }
         :nWidth              := 30
         :nDatastrAlign       := 1
         :nHeadstrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( cFacCliP )->cDescrip }
         :nWidth              := 150
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha expedición"
         :bEditValue          := {|| Dtoc( ( cFacCliP )->dPreCob ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha vencimiento"
         :bEditValue          := {|| Dtoc( ( cFacCliP )->dFecVto ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha cobro"
         :bEditValue          := {|| Dtoc( ( cFacCliP )->dEntrada ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( .f. );

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. );

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT oBrw:Load()

   SetBrwOpt( "BrwRecCli", ( cFacCliP )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      cNumRec     := ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac + str( ( cFacCliP )->nNumRec ) + ( cFacCliP )->cTipRec

      do case
         case IsObject( uGet )

            uGet:cText( cNumRec )
            uGet:lValid()
            uGet:SetFocus()
         
         case IsChar( uGet )

            uGet  := cNumRec

         case IsArray( uGet )

            uGet  := oBrw:aSelected

      end case 

   end if

   /*
   Limpiamos la tabla antes de marcharnos--------------------------------------
   */

   OrdClearScope( nil, cFacCliP )

   ( cFacCliP )->( dbClearFilter() )

   ( cFacCliP )->( OrdSetFocus( nOrdAnt ) )
   ( cFacCliP )->( dbGoTo( nRecAnt ) )

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION browseRecCli( cCodCli, cFacCliP, cDiv )

   local cDbfRecCli     := getDatabaseRecibosClientes( cCodCli, cFacCliP )

RETURN resourceBrowseRecCli( cDbfRecCli, cDiv )
   
//---------------------------------------------------------------------------//

STATIC FUNCTION getDatabaseRecibosClientes( cCodCli, cFacCliP )
   
   if lAIS()
      RETURN getAdsFilterRecibosClientes( cCodCli )
   else
      RETURN getDbfFilterRecibosClientes( cCodCli, cFacCliP )
   end if

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION getAdsFilterRecibosClientes( cCodCli )

   local cStm

   cStm           := "SELECT * "           
   cStm           += "FROM " + cPatEmp() + "FacCliP RecibosClientes "
   cStm           += "WHERE RecibosClientes.cNumMtr IS NULL AND RecibosClientes.lCobrado=false AND RecibosClientes.lRemesa=false  "
   cStm           += "AND RecibosClientes.cCodCli='" + alltrim( cCodCli ) + "' "
   
   TDataCenter():ExecuteSqlStatement( cStm, "RecibosFacturasClientes" )

RETURN ( "RecibosFacturasClientes" )

//---------------------------------------------------------------------------//

STATIC FUNCTION getDbfFilterRecibosClientes( cCliente, cFacCliP )

   ( cFacCliP )->( dbSetFilter( {|| !Field->lCobrado .and. Field->cCodCli == cCliente }, "!lCobrado .and. cCodCli == cCliente" ) )
   ( cFacCliP )->( dbGoTop() )

RETURN cFacCliP

//---------------------------------------------------------------------------//

STATIC FUNCTION resourceBrowseRecCli( cFacCliP, cDiv )

   local oDlg
   local oBrw
   local nOrd        
   local aGet1
   local cGet1
   local cNumRec
   local aRecCli     := {}
   local nSelect
   local oCbxOrd
   local cCbxOrd
   local aCbxOrd     := {  "Número",;
                           "Código cliente",;
                           "Nombre cliente",;
                           "Fecha expedición",;
                           "Fecha vencimiento",;
                           "Fecha cobro",;
                           "Importe",;
                           "Forma pago",;
                           "Agente" }

   nOrd              := GetBrwOpt( "BrwRecCli" )
   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   cNumRec           := ""

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Recibos de clientes"

      REDEFINE GET aGet1 VAR cGet1;
         ID          104 ;
         PICTURE     "@!" ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, cFacCliP, .f., , , , , 10 ) );
         VALID       ( OrdClearScope( oBrw, cFacCliP ) );
         BITMAP      "FIND" ;
         OF          oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR         cCbxOrd ;
         ID          102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( cFacCliP )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), aGet1:SetFocus() ) ;
         OF          oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias             := cFacCliP
      oBrw:cName              := "Browse de recibos de cliente"
      oBrw:bLDblClick         := {|| oDlg:end( IDOK ) }

      oBrw:nMarqueeStyle      := 6

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Cn. Contabilizado"
         :bstrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lConPgo }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Co. Cobrado"
         :bstrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lCobrado }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Tipo"
         :bEditValue          := {|| cTipoRecibo( ( cFacCliP )->cTipRec ) }
         :nWidth              := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumFac"
         :bEditValue          := {|| ( cFacCliP )->cSerie + "/" + AllTrim( str( ( cFacCliP )->nNumFac ) ) + "-" + Alltrim( str( ( cFacCliP )->nNumRec ) ) }
         :nWidth              := 95
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Delegación"
         :bEditValue          := {|| ( cFacCliP )->cSufFac }
         :nWidth              := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Código cliente"
         :cSortOrder          := "cCodCli"
         :bEditValue          := {|| ( cFacCliP )->cCodCli }
         :nWidth              := 80
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre cliente"
         :cSortOrder          := "cNomCli"
         :bEditValue          := {|| ( cFacCliP )->cNomCli }
         :nWidth              := 280
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Forma pago"
         :cSortOrder          := "cCodPgo"
         :bEditValue          := {|| ( cFacCliP )->cCodPgo + " - " + cNbrFPago( ( cFacCliP )->cCodPgo ) }
         :nWidth              := 200
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Agente"
         :cSortOrder          := "cCodAge"
         :bEditValue          := {|| ( cFacCliP )->cCodAge + " - " + RetNbrAge( ( cFacCliP )->cCodAge ) }
         :nWidth              := 280
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Importe"
         :cSortOrder          := "nImporte"
         :bEditValue          := {|| nTotRecCli( cFacCliP, cDiv, cDivEmp(), .t. ) }
         :nWidth              := 100
         :nDatastrAlign       := 1
         :nHeadstrAlign       := 1
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( cFacCliP )->cDescrip }
         :nWidth              := 150
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha expedición"
         :bEditValue          := {|| Dtoc( ( cFacCliP )->dPreCob ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha vencimiento"
         :bEditValue          := {|| Dtoc( ( cFacCliP )->dFecVto ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha cobro"
         :bEditValue          := {|| Dtoc( ( cFacCliP )->dEntrada ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
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
         WHEN     ( .f. );

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. );

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT oBrw:Load()

   SetBrwOpt( "BrwRecCli", ( cFacCliP )->( OrdNumber() ) )

   OrdClearScope( nil, cFacCliP )

   ( cFacCliP )->( dbClearFilter() )

   oBrw:CloseData()

   if ( oDlg:nResult == IDOK )

      for each nSelect in oBrw:aSelected
      
         ( cFacCliP )->( dbGoTo( nSelect ) )

         aAdd( aRecCli, ( ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac + str( ( cFacCliP )->nNumRec ) + ( cFacCliP )->cTipRec ) )

      next

   end if

RETURN ( aRecCli )

//---------------------------------------------------------------------------//

FUNCTION aCalRecCli()

   local aCalRecCli  := {}

   aAdd( aCalRecCli, {"nImpRecCli( cDbfRec, cDbfDiv )", "N", 16, 6, "Importe del recibo", "cPorDivRec",  "", "" } )
   aAdd( aCalRecCli, {"cTxtRecCli( cDbfRec, cDbfDiv )", "C",100, 0, "Importe en letras",  "",            "", "" } )
   aAdd( aCalRecCli, {"nTotFac",                        "N", 16, 6, "Total factura",      "cPorDivRec",  "", "" } )

RETURN ( aCalRecCli )

//---------------------------------------------------------------------------//

FUNCTION aDocRecCli()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Recibo",          "RF" } )
   aAdd( aDoc, { "Factura",         "FC" } )
   aAdd( aDoc, { "Cliente",         "CL" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//----------------------------------------------------------------------------//

STATIC FUNCTION lLiquida( oBrw, lCobrado )

   local nRec

   DEFAULT lCobrado  := .t.

   if len( oBrw:aSelected ) > 0

      for each nRec in ( oBrw:aSelected )

         ( D():FacturasClientesCobros( nView ) )->( dbgoto( nRec ) )

         if ( ( D():FacturasClientesCobros( nView ) )->lCobrado != lCobrado )

            if ( lCobrado ) .or. ( !lCobrado .and. empty( ( D():FacturasClientesCobros( nView ) )->nNumRem ) )

               if ( D():FacturasClientesCobros( nView ) )->( dbrlock() )
                  ( D():FacturasClientesCobros( nView ) )->lCobrado   := lCobrado
                  ( D():FacturasClientesCobros( nView ) )->dEntrada   := GetSysDate()
                  ( D():FacturasClientesCobros( nView ) )->cTurRec    := cCurSesion()
                  ( D():FacturasClientesCobros( nView ) )->( dbunlock() )
               end if

            end if 

         end if

         if ( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac ) )

            ChkLqdFacCli(  nil,;
                           D():FacturasClientes( nView ),; 
                           D():FacturasClientesLineas( nView ),; 
                           D():FacturasClientesCobros( nView ),; 
                           D():AnticiposClientes( nView ),; 
                           D():TiposIva( nView ),; 
                           D():Divisas( nView ),; 
                           .f. )
         end if

      next

   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN nil

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/

FUNCTION GenPgoFacRec( cNumFac, cFacRecT, cFacRecL, cFacCliP, dbfCli, cFPago, cDiv, cIva, nMode, lMessage )

   local cCodPgo
   local cSerFac
   local nNumFac
   local cSufFac
   local cDivFac
   local nVdvFac
   local dFecFac
   local cCodCli
   local cNomCli
   local cCodAge
   local cCodCaj
   local cCodUsr
   local cCtaRem     := ""
   local nCobro      := 0
   local nTotal      := 0
   local nTotCob     := 0
   local nDec        := 0
   local nInc        := 0
   local nTotAcu     := 0
   local n           := 0
   local nPlazos     := 0
   local nRecCli
   local cBanco
   local cPaisIBAN
   local cCtrlIBAN
   local cEntidad
   local cSucursal
   local cControl
   local cCuenta

   DEFAULT nMode     := APPD_MODE
   DEFAULT lMessage  := .t.

   DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cFPago    := D():FormasPago( nView )
   DEFAULT cDiv      := D():Divisas( nView )
   DEFAULT cFacRecT  := D():FacturasRectificativas( nView )
   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT cIva      := D():TiposIva( nView )

   cSerFac           := ( cFacRecT )->cSerie
   nNumFac           := ( cFacRecT )->nNumFac
   cSufFac           := ( cFacRecT )->cSufFac
   cDivFac           := ( cFacRecT )->cDivFac
   nVdvFac           := ( cFacRecT )->nVdvFac
   dFecFac           := ( cFacRecT )->dFecFac
   cCodPgo           := ( cFacRecT )->cCodPago
   cCodCli           := ( cFacRecT )->cCodCli
   cNomCli           := ( cFacRecT )->cNomCli
   cCodAge           := ( cFacRecT )->cCodAge
   cCodCaj           := ( cFacRecT )->cCodCaj
   cCodUsr           := ( cFacRecT )->cCodUsr
   cBanco            := ( cFacRecT )->cBanco
   cPaisIBAN         := ( cFacRecT )->cPaisIBAN
   cCtrlIBAN         := ( cFacRecT )->cCtrlIBAN
   cEntidad          := ( cFacRecT )->cEntBnc
   cSucursal         := ( cFacRecT )->cSucBnc
   cControl          := ( cFacRecT )->cDigBnc
   cCuenta           := ( cFacRecT )->cCtaBnc

   /*
   Cuenta de remesas-----------------------------------------------------------
   */

   nRecCli           := ( dbfCli )->( Recno() )

   if ( dbfCli )->( dbSeek( cCodCli ) )
      cCtaRem        := ( dbfCli )->cCodRem
   end if

   /*
   Decimales para el redondeo--------------------------------------------------
   */

   nDec              := nRouDiv( cDivFac, cDiv ) // Decimales de la divisa redondeada

   /*
   Comprobar q el total de factura  no es igual al de pagos--------------------
   */

   nTotal            := nTotFacRec( cNumFac, cFacRecT, cFacRecL, cIva, cDiv, nil, nil, .f. )
   nTotCob           := nTotalRecibosGeneradosRectificativasCliente( cNumFac, cFacRecT, cFacCliP, cIva, cDiv )

   if nTotal != nTotCob

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar--
      */

      if ( cFacCliP )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) )

         while cSerFac + str( nNumFac ) + cSufFac == ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac .and. !( cFacCliP )->( eof() )

            if !empty( ( cFacCliP )->cTipRec )

               if !( cFacCliP )->lCobrado .and. dbLock( cFacCliP )
                  ( cFacCliP )->( dbDelete() )
                  ( cFacCliP )->( dbUnLock() )
               else
                  nInc  := ( cFacCliP )->nNumRec
               end if

            end if

            ( cFacCliP )->( dbSkip() )

         end while

      end if

      /*
      Vamos a relizar pagos por la diferencia entre el total y lo cobrado
      */

      nTotal         -= nTotalRecibosPagadosRectificativasCliente( cSerFac + str( nNumFac ) + cSufFac, cFacRecT, cFacCliP, cIva, cDiv )

      /*
      Genera pagos----------------------------------------------------------
      */

      if ( cFPago )->( dbSeek( cCodPgo ) )

         nTotAcu        := nTotal
         nPlazos        := Max( ( cFPago )->nPlazos, 1 )

         for n := 1 to nPlazos

            if n != nPlazos
               nTotAcu  -= Round( nTotal / nPlazos, nDec )
            end if

            ( cFacCliP )->( dbAppend() )

            ( cFacCliP )->cSerie        := cSerFac
            ( cFacCliP )->nNumFac       := nNumFac
            ( cFacCliP )->cSufFac       := cSufFac
            ( cFacCliP )->nNumRec       := ++nInc
            ( cFacCliP )->cTipRec       := "R"
            ( cFacCliP )->cCodCaj       := cCodCaj
            ( cFacCliP )->cCodUsr       := cCodUsr
            ( cFacCliP )->cTurRec       := cCurSesion()
            ( cFacCliP )->cCodCli       := cCodCli
            ( cFacCliP )->cNomCli       := cNomCli

            if ( cFPago )->lUtlBnc
               ( cFacCliP )->cBncEmp    := ( cFPago )->cBanco
               ( cFacCliP )->cEntEmp    := ( cFPago )->cEntBnc
               ( cFacCliP )->cSucEmp    := ( cFPago )->cSucBnc
               ( cFacCliP )->cDigEmp    := ( cFPago )->cDigBnc
               ( cFacCliP )->cCtaEmp    := ( cFPago )->cCtaBnc
            end if

            ( cFacCliP )->cBncCli       := cBanco
            ( cFacCliP )->cEntCli       := cEntidad
            ( cFacCliP )->cSucCli       := cSucursal
            ( cFacCliP )->cDigCli       := cControl
            ( cFacCliP )->cCtaCli       := cCuenta

            ( cFacCliP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cFacCliP )->nImpCob       := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cFacCliP )->cDescrip      := "Recibo nº" + AllTrim( str( nInc ) ) + " de factura rectificativa " + cSerFac  + '/' + allTrim( str( nNumFac )  ) + '/' + cSufFac
            ( cFacCliP )->cDivPgo       := cDivFac
            ( cFacCliP )->nVdvPgo       := nVdvFac
            ( cFacCliP )->dPreCob       := dFecFac
            ( cFacCliP )->cCtaRec       := ( cFPago )->cCtaCobro
            ( cFacCliP )->cCtaGas       := ( cFPago )->cCtaGas
            ( cFacCliP )->cCtaRem       := cCtaRem
            ( cFacCliP )->cCodAge       := cCodAge
            ( cFacCliP )->lEsperaDoc    := ( cFPago )->lEsperaDoc
            ( cFacCliP )->lSndDoc       := .t.
            ( cFacCliP )->dFecVto       := dNextDayPago( dFecFac, n, nPlazos, cFPago, dbfCli )

            if !empty( ( cFacRecT )->cCtrCoste )
               ( cFacCliP )->cCtrCoste  := ( cFacRecT )->cCtrCoste
            endif

            if ( cFPago )->nCobRec == 1 .and. nMode == APPD_MODE
               ( cFacCliP )->lCobrado   := .t.
               ( cFacCliP )->cTurRec    := cCurSesion()
               ( cFacCliP )->dEntrada   := dNextDayPago( dFecFac, n, nPlazos, cFPago, dbfCli )

            end if

            ( cFacCliP )->dFecCre       := GetSysDate()
            ( cFacCliP )->cHorCre       := Substr( Time(), 1, 5 )

            ( cFacCliP )->( dbUnLock() )

            /*
            Actualizamos el riesgo---------------------------------------------
            */

            if ( cFacCliP )->lCobrado
               delRiesgo( ( cFacCliP )->nImporte, ( cFacCliP )->cCodCli, dbfCli )
            end if

         next

      else

         if lMessage
            MsgStop( "Forma de pago no encontrada" )
         end if

      end if

   end if

   ( dbfCli )->( dbGoTo( nRecCli ) )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar factura";
               MESSAGE  "Modificar la factura que creó el recibo" ;
               RESOURCE "gc_document_text_user_16" ;
               ACTION   ( EdtFacCli( aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] ) )

            SEPARATOR

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndEdtRecMenu()

RETURN( oMenu:End() )

//---------------------------------------------------------------------------//

Function EdtRecCli( cNumFac, lOpenBrowse, lRectificativa )

   local lEdit             := .f.
   local nLevel            := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse     := .f.
   DEFAULT lRectificativa  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            lEdit          := WinEdtRec( nil, bEdit, D():FacturasClientesCobros( nView ), lRectificativa )
         else
            MsgStop( "No se encuentra recibo" + str( len( cNumFac ) ) )
         end if

         CloseFiles()

      end if

   end if

RETURN ( lEdit )

//----------------------------------------------------------------------------//

FUNCTION ZooRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            WinZooRec( nil, bEdit, D():FacturasClientesCobros( nView ) )
         end if
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION DelRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            oWndBrw:RecDel()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            DelCobCli( nil, D():FacturasClientesCobros( nView ) )
         end if

         CloseFiles()

      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION PrnRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            ImpPago( nil, IS_PRINTER )
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            ImpPago( nil, IS_PRINTER )
         end if

         CloseFiles()

      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION VisRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            ImpPago( nil, IS_SCREEN )
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
            ImpPago( nil, IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION IntEdtRecCli( cNumFac )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
      WinEdtRec( nil, bEdit, D():FacturasClientesCobros( nView ) )
   else
      MsgStop( "No se encuentra recibo" )
   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION ExtEdtRecCli( cFacCliP, nVista, lRectificativa, oCta, oCtrCoste )

   local nLevel               := nLevelUsr( _MENUITEM_ )

   lActualizarEstadoFactura   := .f.

   nView                      := nVista
   oCtaRem                    := oCta
   oCentroCoste               := oCtrCoste

   DEFAULT lRectificativa     := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   WinEdtRec( nil, bEdit, cFacCliP, lRectificativa )

   lActualizarEstadoFactura   := .t.

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION ExtDelRecCli( cFacCliP )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   DelCobCli( nil, cFacCliP )

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oRad
   local nRad        := 1
   local nCopPrn     := 1
   local oSerIni
   local oSerFin
   local oFmtRec
   local cFmtRec     := cSelPrimerDoc( "RF" )
   local oSayRec
   local cSayRec
   local lNotRem     := .f.
   local lNotImp     := .f.
   local lNotCob     := .f.
   local oCodPgo
   local cCodPgo     := space( 3 )
   local oTxtPgo
   local cTxtPgo     := ""
   local nRecno      := ( D():FacturasClientesCobros( nView ) )->( recno() )
   local nOrdAnt     := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( 1 ) )
   local dFecIni     := CtoD( "01/" + str( Month( GetSysDate() ), 2 ) + "/" + str( Year( Date() ) ) )
   local dFecFin     := GetSysDate()
   local cSerIni     := ( D():FacturasClientesCobros( nView ) )->CSERIE
   local cSerFin     := ( D():FacturasClientesCobros( nView ) )->CSERIE
   local nDocIni     := ( D():FacturasClientesCobros( nView ) )->NNUMFAC
   local nDocFin     := ( D():FacturasClientesCobros( nView ) )->NNUMFAC
   local cSufIni     := ( D():FacturasClientesCobros( nView ) )->CSUFFAC
   local cSufFin     := ( D():FacturasClientesCobros( nView ) )->CSUFFAC
   local nNumIni     := ( D():FacturasClientesCobros( nView ) )->NNUMREC
   local nNumFin     := ( D():FacturasClientesCobros( nView ) )->NNUMREC
   local oPrinter
   local cPrinter    := PrnGetName()

   cSayRec           := cNombreDoc( cFmtRec )

   DEFINE DIALOG oDlg RESOURCE "IMPSERREC"

   REDEFINE RADIO oRad VAR nRad ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE GET oFmtRec VAR cFmtRec ;
      ID       100 ;
      VALID    ( cDocumento( oFmtRec, oSayRec, D():Documentos( nView ) ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtRec, oSayRec, "RF" ) );
      OF       oDlg

   REDEFINE GET oSayRec VAR cSayRec ;
      ID       101 ;
      WHEN     ( .f. );
      OF       oDlg

   TBtnBmp():ReDefine( 92, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( cFmtRec ) }, oDlg, .f., , .f.,  )

   REDEFINE GET dFecIni ;
      ID       110 ;
      SPINNER ;
      WHEN     ( nRad == 1 ) ;
      OF       oDlg

   REDEFINE GET dFecFin ;
      ID       120 ;
      SPINNER ;
      WHEN     ( nRad == 1 ) ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       130 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( nRad == 2 ) ;
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       170 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( nRad == 2 ) ;
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       140 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET nDocFin;
      ID       180 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       190 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET nNumIni ;
      ID       160 ;
      PICTURE  "99" ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET nNumFin ;
      ID       200 ;
      PICTURE  "99" ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       320 ;
      OF       oDlg

   TBtnBmp():ReDefine( 321, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   // Formas de pago_____________________________________________________________________

   REDEFINE GET oCodPgo VAR cCodPgo;
      ID       210 ;
      PICTURE  "@!" ;
      VALID    ( cFPago( oCodPgo, D():FormasPago( nView ), oTxtPgo ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFPago( oCodPgo, oTxtPgo ) );
      OF       oDlg

   REDEFINE GET oTxtPgo VAR cTxtPgo;
      ID       220 ;
      WHEN     .f. ;
      OF       oDlg

   REDEFINE CHECKBOX lNotRem;
      ID       230 ;
		OF 		oDlg

   REDEFINE CHECKBOX lNotImp;
      ID       240 ;
		OF 		oDlg

   REDEFINE CHECKBOX lNotCob;
      ID       250 ;
		OF 		oDlg

   REDEFINE GET nCopPrn;
      ID       260 ;
      VALID    nCopPrn > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  StartPrint( Substr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + str( nDocIni, 9 ) + cSufIni + str( nNumIni, 2 ), cSerFin + str( nDocFin, 9 ) + cSufFin + str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( Substr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + str( nDocIni, 9 ) + cSufIni + str( nNumIni, 2 ), cSerFin + str( nDocFin, 9 ) + cSufFin + str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   ( D():FacturasClientesCobros( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasClientesCobros( nView ) )->( ordSetFocus( nOrdAnt ) )

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cCodDoc, nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg )

   local oInf
   local nOrd
   local oDevice
   local cCaption       := 'Imprimiendo recibos'

   if empty( cCodDoc )
      RETURN nil
   end if

   private cDbfRec      := D():FacturasClientesCobros( nView )
   private cDbf         := D():FacturasClientes( nView )
   private cCliente     := D():Clientes( nView )
   private cDbfCli      := D():Clientes( nView )
   private cFPago       := D():FormasPago( nView )
   private cDbfPgo      := D():FormasPago( nView )
   private cDbfAge      := D():Agentes( nView )
   private cDbfDiv      := D():Divisas( nView )
   private cPorDivRec   := cPorDiv( ( D():FacturasClientesCobros( nView ) )->cDivPgo, D():Divisas( nView ) )

   oDlg:Disable()

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )

      if nRad == 1
         nOrd           := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "dPreCob" ) )
         ( D():FacturasClientesCobros( nView ) )->( dbSeek( dFecIni, .t. ) )
      else
         nOrd           := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "nNumFac" ) )
         ( D():FacturasClientesCobros( nView ) )->( dbSeek( cDocIni, .t. ) )
      end if

      while !( D():FacturasClientesCobros( nView ) )->( eof() )

         if (  if( nRad == 1, ( ( D():FacturasClientesCobros( nView ) )->dPreCob >= dFecIni .and. ( D():FacturasClientesCobros( nView ) )->dPreCob <= dFecFin ), .t. )                 .and. ;
               if( nRad == 2, ( ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) >= cDocIni .and. ;
                                ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) <= cDocFin ), .t. )  .and. ;
               if( !empty( cCodPgo ), cCodPgo == cPgoFacCli( ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC, 9 ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC, D():FacturasClientes( nView ) ), .t. ) .and.;
               if( lNotRem, ( D():FacturasClientesCobros( nView ) )->nNumRem == 0 .and. empty( ( D():FacturasClientesCobros( nView ) )->cSufRem ), .t. )                                 .and. ;
               if( lNotImp, !( D():FacturasClientesCobros( nView ) )->lRecImp, .t. )                                                                            .and. ;
               if( lNotCob, !( D():FacturasClientesCobros( nView ) )->lCobrado, .t. ) )

            // Posicionamos en ficheros auxiliares

            if dbLock( D():FacturasClientesCobros( nView ) )
               ( D():FacturasClientesCobros( nView ) )->lRecImp    := .t.
               ( D():FacturasClientesCobros( nView ) )->dFecImp    := GetSysDate()
               ( D():FacturasClientesCobros( nView ) )->cHorImp    := Substr( Time(), 1, 5 )
               ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
            end if

            ( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC ) )
            ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->CCODCLI ) )
            ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->CCODPAGO ) )

            // Imprimir el documento

            PrintReportRecCli( IS_PRINTER, nCopPrn, nil, cCodDoc )

         end if

         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

      end while

   else

      if !empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      // Cabeceras del listado

      if !empty( oInf ) .and. oInf:lCreated
         oInf:lFinish      := .f.
         oInf:lAutoland    := .t.
         oInf:lNoCancel    := .t.
         oInf:bSkip        := {|| Skipping( nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodDoc, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, oInf ) }

         oInf:oDevice:lPrvModal  := .t.

         oInf:bPreview     := {| oDevice | PrintPreview( oDevice ) }

      end if

      SetMargin(  cCodDoc, oInf )
      PrintColum( cCodDoc, oInf )

      END REPORT

      if !empty( oInf )

         ACTIVATE REPORT oInf WHILE ( !( D():FacturasClientesCobros( nView ) )->( eof() ) ) // ON STARTPAGE ( eItems( cCodDoc, oInf ) )

         oInf:oDevice:end()

      end if

      oInf                          := nil

   end if

   oDlg:Enable()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION Skipping( nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodDoc, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, oInf )

   local nOrd
   local nCopYet  := 0
   local nImpYet  := 0
   local nDocPag  := 0
   local nLenPag  := 0
   local nLenDoc  := 0
   local nOffset  := 0

   if ( D():Documentos( nView ) )->( dbSeek( cCodDoc ) )
      nLenPag     := ( D():Documentos( nView ) )->nLenPag
      nLenDoc     := ( D():Documentos( nView ) )->nLenDoc
      if nLenPag != 0 .and. nLenDoc != 0
         nDocPag  := Int( nLenPag / nLenDoc )
      end if
   end if

   if nRad == 1
      nOrd        := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "dPreCob" ) )
      ( D():FacturasClientesCobros( nView ) )->( dbSeek( dFecIni, .t. ) )
   else
      nOrd        := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "nNumFac" ) )
      ( D():FacturasClientesCobros( nView ) )->( dbSeek( cDocIni, .t. ) )
   end if

   while !( D():FacturasClientesCobros( nView ) )->( eof() )

      if (  if( nRad == 1, ( ( D():FacturasClientesCobros( nView ) )->dPreCob >= dFecIni .and. ( D():FacturasClientesCobros( nView ) )->dPreCob <= dFecFin ), .t. )                 .and. ;
            if( nRad == 2, ( ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) >= cDocIni .and. ;
                             ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) <= cDocFin ), .t. )  .and. ;
            if( !empty( cCodPgo ), cCodPgo == cPgoFacCli( ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC, 9 ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC, D():FacturasClientes( nView ) ), .t. ) .and.;
            if( lNotRem, ( D():FacturasClientesCobros( nView ) )->nNumRem == 0 .and. empty( ( D():FacturasClientesCobros( nView ) )->cSufRem ), .t. )                                 .and. ;
            if( lNotImp, !( D():FacturasClientesCobros( nView ) )->lRecImp, .t. )                                                                            .and. ;
            if( lNotCob, !( D():FacturasClientesCobros( nView ) )->lCobrado, .t. ) )

         // Posicionamos en ficheros auxiliares

         if dbLock( D():FacturasClientesCobros( nView ) )
            ( D():FacturasClientesCobros( nView ) )->lRecImp    := .t.
            ( D():FacturasClientesCobros( nView ) )->dFecImp    := GetSysDate()
            ( D():FacturasClientesCobros( nView ) )->cHorImp    := Substr( Time(), 1, 5 )
            ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
         end if

         ( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->CSERIE + str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC ) )
         ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->CCODCLI ) )
         ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->CCODPAGO ) )

         nImpYet++
         if nImpYet > nDocPag
            oInf:EndPage()
            nImpYet  := 1
         end if

         nOffSet     := ( nImpYet - 1 ) * nLenDoc

         PrintItems( cCodDoc, oInf, nil, nOffSet )

      end if

      nCopYet++

      if nCopYet >= nCopPrn
         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )
         nCopYet     := 0
      end if

   end while

RETURN NIL

//--------------------------------------------------------------------------//


STATIC FUNCTION ImpPago( cNumRec, nDevice, cCodDoc, cCaption, nCopies )

   local oInf
   local cPrinter

   DEFAULT cNumRec      := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo recibos"
   DEFAULT nCopies      := 1
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():FacturasClientesCobros( nView ) )->cSerie, "nRecCli", D():Contadores( nView ) )

   if empty( cCodDoc )
      cCodDoc           := cFirstDoc( "RF", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      RETURN nil
   end if

   /*
   Continuamos con la impresion------------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )

      PrintReportRecCli( nDevice, nCopies, cPrinter, cCodDoc )

   else

      private cDbfRec      := D():FacturasClientesCobros( nView )
      private cDbf         := D():FacturasClientes( nView )
      private cCliente     := D():Clientes( nView )
      private cDbfCli      := D():Clientes( nView )
      private cFPago       := D():FormasPago( nView )
      private cDbfPgo      := D():FormasPago( nView )
      private cDbfDiv      := D():Divisas( nView )
      private cDbfAge      := D():Agentes( nView )
      private cPorDivRec   := cPorDiv( ( D():FacturasClientesCobros( nView ) )->cDivPgo, D():Divisas( nView ) )
      private nTotFac      := nTotFacCli( cNumRec, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), , , .f. )

      // Posicionamos en ficheros auxiliares

      if empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )
         ( D():FacturasClientes( nView ) )->( dbSeek( cNumRec ) )
         ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cCodCli ) )
         ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cCodPago ) )
      else
         ( D():FacturasRectificativas( nView ))->( dbSeek( cNumRec ) )
         ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cCodCli ) )
         ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasRectificativas( nView ) )->cCodPago ) )
      end if

      if empty( cPrinter )
         REPORT oInf CAPTION cCaption PREVIEW
      else
         REPORT oInf CAPTION cCaption NAME cPrinter PREVIEW
      end if

      // Cabeceras del listado

      if oInf:lCreated
         oInf:lFinish      := .f.
         oInf:lAutoland    := .t.
         oInf:bSkip        := {|| ( D():FacturasClientesCobros( nView ) )->( dbSkip() ) }

         do case
            case nDevice == IS_PRINTER
               oInf:bPreview  := {| oDevice | PrintPreview( oDevice ) }

            case nDevice == IS_PDF
               oInf:bPreview  := {| oDevice | PrintPdf( oDevice ) }

         end case

         SetMargin(  cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )
      end if

      END REPORT

      ACTIVATE REPORT oInf WHILE ( .f. ) ON ENDPAGE ( eItems( cCodDoc, oInf ) )

      // oInf:End()

      if nDevice == IS_PRINTER
         oInf:oDevice:end()
      end if

      oInf                 := nil

   end if

   // Marcamos para impreso

   if dbLock( D():FacturasClientesCobros( nView ) )
      ( D():FacturasClientesCobros( nView ) )->lRecImp    := .t.
      ( D():FacturasClientesCobros( nView ) )->dFecImp    := GetSysDate()
      ( D():FacturasClientesCobros( nView ) )->cHorImp    := Substr( Time(), 1, 5 )
      ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
   end if

   /*
   Refrescamos la pantalla principal-------------------------------------------
   */

   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION eItems( cCodDoc, oInf )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

   // Reposicionamos en las distintas areas

   PrintItems( cCodDoc, oInf )

RETURN NIL

//-------------------------------------------------------------------------//

Function bGenEdtRecCli( cDocumento, lFromFactura )

   local bGen
   local cDoc           := by( cDocumento )

   DEFAULT lFromFactura := .f.

   if lFromFactura
      bGen              := {|| EdtRecCli( cDoc, .f. ) }
   else
      bGen              := {|| IntEdtRecCli( cDoc ) }
   end if

RETURN ( bGen )

//-------------------------------------------------------------------------//

STATIC FUNCTION DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Recibos", ( D():FacturasClientesCobros( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Recibos", cItemsToReport( aItmRecCli() ) )

   oFr:SetWorkArea(     "Facturas", ( D():FacturasClientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacCli() ) )

   oFr:SetWorkArea(     "Facturas rectificativas", ( D():FacturasRectificativas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Facturas rectificativas", cItemsToReport( aItmFacRec() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Agentes", ( D():Agentes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Bancos", ( D():ClientesBancos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aCliBnc() ) )

   oFr:SetWorkArea(     "Compensaciones", ( dbfMatriz )->( Select() ) )
   oFr:SetFieldAliases( "Compensaciones", cItemsToReport( aItmRecCli() ) )

   oFr:SetMasterDetail( "Recibos", "Facturas",                 {|| ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Facturas rectificativas",  {|| ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Empresa",                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Recibos", "Clientes",                 {|| ( D():FacturasClientesCobros( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Recibos", "Formas de pago",           {|| ( D():FacturasClientesCobros( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Recibos", "Agentes",                  {|| ( D():FacturasClientesCobros( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Recibos", "Bancos",                   {|| ( D():FacturasClientesCobros( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Recibos", "Compensaciones",           {|| ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec } )

   oFr:SetResyncPair(   "Recibos", "Facturas" )
   oFr:SetResyncPair(   "Recibos", "Facturas rectificativas" )
   oFr:SetResyncPair(   "Recibos", "Empresa" )
   oFr:SetResyncPair(   "Recibos", "Clientes" )
   oFr:SetResyncPair(   "Recibos", "Formas de pago" )
   oFr:SetResyncPair(   "Recibos", "Agentes" )
   oFr:SetResyncPair(   "Recibos", "Bancos" )
   oFr:SetResyncPair(   "Recibos", "Compensaciones" )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION VariableReport( oFr )

   oFr:DeleteCategory(  "Recibos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Recibos", "Importe del recibo",       "CallHbFunc('nImpRecCli')" )
   oFr:AddVariable(     "Recibos", "Importe formato texto",    "CallHbFunc('cTxtRecCli')" )
   oFr:AddVariable(     "Recibos", "Total factura",            "CallHbFunc('nTotFactura')" )
   oFr:AddVariable(     "Recibos", "Total cobros factura",     "CallHbFunc('nTotCobros')" )
   oFr:AddVariable(     "Recibos", "Total rectificativa",      "CallHbFunc('nTotRectificativa')" )
   oFr:AddVariable(     "Recibos", "Cuenta bancaria cliente",  "CallHbFunc('cCtaRecCli')" )

RETURN nil

//---------------------------------------------------------------------------//

Function DesignReportRecCli( oFr, cDbfDoc )

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

      if !empty( ( cDbfDoc )->mReport )

         oFr:LoadFromBlob( ( cDbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )
         oFr:SetProperty(     "Report.ScriptText", "Text",;
                                                   + ;
                                                   "procedure DetalleOnMasterDetail(Sender: TfrxComponent);"   + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "CallHbFunc('nTotRecCli');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CuerpoDocumento",   "MainPage", frxPageHeader )
         oFr:SetProperty(     "CuerpoDocumento",   "Top", 0 )
         oFr:SetProperty(     "CuerpoDocumento",   "Height", 300 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 300 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Recibos" )

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

Function mailReportRecCli( cCodigoDocumento )

RETURN ( PrintReportRecCli( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION PrintReportRecCli( nDevice, nCopies, cPrinter, cCodigoDocumento )

   local oFr
   local cFilePdf             := cPatTmp() + "RecibosCliente" + strTran( ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac, " ", "" ) + ".Pdf"

   DEFAULT nDevice            := IS_SCREEN
   DEFAULT nCopies            := 1
   DEFAULT cPrinter           := PrnGetName()
   DEFAULT cCodigoDocumento   := cFormatoRecibosClientes()

   if empty( cCodigoDocumento )
      msgStop( "El código del documento esta vacio" )
      RETURN ( nil )
   end if 

   if !lMemoDocumento( cCodigoDocumento, D():Documentos( nView ) )
      msgStop( "El formato " + cCodigoDocumento + " no se encuentra, o no es un formato visual." )
      RETURN ( nil )
   end if 

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

RETURN ( cFilePdf )

//---------------------------------------------------------------------------//

Function nTotFactura( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT )

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT cFacCliT  := D():FacturasClientes( nView )
   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT cDbfIva   := D():TiposIva( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )
   DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cAntCliT  := D():AnticiposClientes( nView )

RETURN ( nTotFacCli( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT, , , .f. ) )

//---------------------------------------------------------------------------//

Function nTotCobros( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT )

   local sTotCobros  

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT cFacCliT  := D():FacturasClientes( nView )
   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT cDbfIva   := D():TiposIva( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )
   DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cAntCliT  := D():AnticiposClientes( nView )

   sTotCobros        := sTotFacCli( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT )

RETURN ( sTotCobros:nTotalCobrado )

//---------------------------------------------------------------------------//

function nTotRectificativa( cNumRec, cFacRecT, cFacRecL, cDbfIva, cDbfDiv )

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT cFacRecT  := D():FacturasRectificativas( nView )
   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT cDbfIva   := D():TiposIva( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )

RETURN ( nTotFacRec( cNumRec, cFacRecT, cFacRecL, cDbfIva, cDbfDiv, nil, nil, .f. ) )

//---------------------------------------------------------------------------//

function nTotRecibo( cNumRec, cFacCliP, cDiv )

   local hStatus
   local nTotRec     := 0

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec
   DEFAULT cDiv      := D():Divisas( nView )

   hStatus           := hGetStatus( cFacCliP )

   if hSeekInOrd( { "Value" => cNumRec, "Order" => "nNumFac", "Alias" => cFacCliP } )
      nTotRec        := nTotRecCli( cFacCliP, cDiv )
   end if

   hSetStatus( hStatus )

RETURN ( nTotRec )

//---------------------------------------------------------------------------//
/*
Regenera indices
*/

Function rxRecCli( cPath, cDriver )

   local cFacCliT
   local dbfFacCliG

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   mkRecCli( cPath, nil, .f. )

   fEraseIndex( cPath + "FacCliP.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliG.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "FACCLIP.DBF", cCheckArea( "FACCLIP", @cFacCliT ), .f. )
   if !( cFacCliT )->( neterr() )

      ( cFacCliT )->( __dbPack() )

      // "Número"

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec ) + cTipRec", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumRec ) + Field->cTipRec } ) )

      // "Código"

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodCli", "cCodCli + cSerie + str( nNumFac ) + cSufFac + str( nNumRec ) + cTipRec", {|| Field->cCodCli + Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumRec ) + Field->cTipRec } ) )

      // "Nombre",;

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cNomCli", "cNomCli + cSerie + str( nNumFac ) + cSufFac + str( nNumRec ) + cTipRec", {|| Field->cNomCli + Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumRec ) + Field->cTipRec } ) )

      // "Expedición",;

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dPreCob", "dPreCob", {|| Field->dPreCob } ) )

      // "Vencimiento",;

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dFecVto", "dFecVto", {|| Field->dFecVto } ) )

      // "Cobro",;

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dEntrada", "dEntrada", {|| Field->dEntrada } ) )

      // "Importe",;

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , , , .t. ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nImporte", "nImporte", {|| Field->nImporte }, ) )

      //Forma de Pago

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodPgo", "cCodPgo", {|| Field->cCodPgo } ) )
      
      //Agente,;

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      // Codigo de clientes no cobrados

      ( cFacCliT )->( ordCondSet("!Deleted() .and. !Field->lCobrado", {|| !Deleted() .and. !Field->lCobrado } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lCodCli", "cCodCli", {|| Field->cCodCli } ) )

      // Numero de remesas

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumRem", "str( nNumRem ) + cSufRem", {|| str( Field->nNumRem ) + Field->cSufRem } ) )

      // Cuentas de remesas----------------------------------------------------

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCtaRem", "cCtaRem", {|| Field->cCtaRem }, ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumCob", "str( nNumCob ) + cSufCob", {|| str( Field->nNumCob ) + Field->cSufCob } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cTurRec", "cTurRec + cSufFac + cCodCaj", {|| Field->cTurRec + Field->cSufFac + Field->cCodCaj } ) )

      // Orden para recibos facturas-------------------------------------------

      ( cFacCliT )->( ordCondSet("!Deleted() .and. empty( cTipRec )", {|| !Deleted() .and.  empty( Field->cTipRec ) } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "fNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec )", {|| Field->CSERIE + str( Field->NNUMFAC ) + Field->CSUFFAC + str( Field->NNUMREC ) } ) )

      // Orden para recibos rectificativas-------------------------------------

      ( cFacCliT )->( ordCondSet("!Deleted() .and. Field->cTipRec == 'R'", {|| !Deleted() .and. Field->cTipRec == 'R' } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "rNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec )", {|| Field->CSERIE + str( Field->NNUMFAC ) + Field->CSUFFAC + str( Field->NNUMREC ) } ) )

      // Orden para recibos libres---------------------------------------------

      ( cFacCliT )->( ordCondSet("!Deleted() .and. Field->cTipRec == 'L'", {|| !Deleted() .and. Field->cTipRec == 'L'} ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec )", {|| Field->CSERIE + str( Field->NNUMFAC ) + Field->CSUFFAC + str( Field->NNUMREC ) } ) )

      // Orden para recibos por tipos---------------------------------------------

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cTipRec", "cTipRec + cSerie + str( nNumFac ) + cSufFac + str( nNumRec )", {|| Field->cTipRec +  Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumRec ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cRecDev", "cRecDev", {|| Field->CRECDEV } ) )

      ( cFacCliT )->( ordCondSet("!Deleted() .and. Field->lCobrado", {|| !Deleted() .and. Field->lCobrado } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lCtaBnc", "Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp", {|| Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cNumMtr", "Field->cNumMtr", {|| Field->cNumMtr } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliP.Cdx", "iNumFac", "'18' + cSerie + str( nNumFac ) + space( 1 ) + cSufFac + str( nNumRec )", {|| '18' + Field->cSerie + str( Field->nNumFac ) + space( 1 ) + Field->cSufFac + str( Field->nNumRec ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dFecDes", "dPreCob", {|| Field->dPreCob } ) )

      ( cFacCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de recibos de clientes" )

   end if

   // Tabla de grupos de recibos-----------------------------------------------

   dbUseArea( .t., cDriver, cPath + "FacCliG.Dbf", cCheckArea( "FACCLIG", @dbfFacCliG ), .f. )

   if !( dbfFacCliG )->( neterr() )

      ( dbfFacCliG )->( __dbPack() )

      ( dbfFacCliG )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliG )->( ordCreate( cPath + "FacCliG.Cdx", "cNumMtr", "cNumMtr", {|| Field->cNumMtr } ) )

      ( dbfFacCliG )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliG )->( ordCreate( cPath + "FacCliG.Cdx", "cNumRec", "cNumRec", {|| Field->cNumRec } ) )

      ( dbfFacCliG )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliG )->( ordCreate( cPath + "FacCliG.Cdx", "cNumRel", "cNumMtr + cNumRec", {|| Field->cNumMtr + Field->cNumRec } ) )

      ( dbfFacCliG )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de grupos de recibos de clientes" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Crea los ficheros de la facturaci¢n
*/

FUNCTION mkRecCli( cPath, oMeter, lReindex )

   DEFAULT lReindex  := .t.

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   if !lExistTable( cPath + "FacCliP.Dbf", cLocalDriver() )
      dbCreate( cPath + "FacCliP.Dbf", aSqlstruct( aItmRecCli() ), cLocalDriver() )
   end if 

   if !lExistTable( cPath + "FacCliG.Dbf", cLocalDriver() )
      dbCreate( cPath + "FacCliG.Dbf", aSqlstruct( aItmGruposRecibos() ), cLocalDriver() )
   end if

   if lReindex
      rxRecCli( cPath, cLocalDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aItmRecCli()

   local aBasRecCli  := {}

   aAdd( aBasRecCli, {"cSerie"      ,"C",  1, 0, "Serie de factura",                                     "Serie",                "", "( cDbfRec )", {|| "A" } } )
   aAdd( aBasRecCli, {"nNumFac"     ,"N",  9, 0, "Número de factura",                                    "Numero",               "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cSufFac"     ,"C",  2, 0, "Sufijo de factura",                                    "Sufijo",               "", "( cDbfRec )", {|| RetSufEmp() } } )
   aAdd( aBasRecCli, {"nNumRec"     ,"N",  2, 0, "Número del recibo",                                    "NumeroRecibo",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cGuid"       ,"C", 40, 0, "Guid de recibo",                                       "GUID",                 "", "( cDbfRec )", {|| win_uuidcreatestring() } } )
   aAdd( aBasRecCli, {"cTipRec"     ,"C",  1, 0, "Tipo de recibo",                                       "TipoRecibo",           "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCodPgo"     ,"C",  2, 0, "Código de forma de pago",                              "Pago",                 "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCodCaj"     ,"C",  3, 0, "Código de caja",                                       "Caja",                 "", "( cDbfRec )", {|| oUser():cCaja() } } )
   aAdd( aBasRecCli, {"cTurRec"     ,"C",  6, 0, "Sesión del recibo",                                    "Turno",                "", "( cDbfRec )", {|| cCurSesion( nil, .f.) } } )
   aAdd( aBasRecCli, {"cCodCli"     ,"C", 12, 0, "Código de cliente",                                    "Cliente",              "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cNomCli"     ,"C", 80, 0, "Nombre de cliente",                                    "NombreCliente",        "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dEntrada"    ,"D",  8, 0, "Fecha de cobro",                                       "FechaCobro",           "", "( cDbfRec )", {|| Date() } } )
   aAdd( aBasRecCli, {"nImporte"    ,"N", 16, 6, "Importe",                                              "TotalDocumento",       "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cDescrip"    ,"C",100, 0, "Concepto del pago",                                    "Concepto",             "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dPreCob"     ,"D",  8, 0, "Fecha de expedición",                                  "FechaExpedicion",      "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cPgdoPor"    ,"C", 50, 0, "Pagado por",                                           "PagadoPor",            "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cDocPgo"     ,"C", 50, 0, "Documento de pago",                                    "DocumentoPago",        "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lCobrado"    ,"L",  1, 0, "Lógico de cobrado",                                    "LogicoCobrado",        "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cDivPgo"     ,"C",  3, 0, "Código de la divisa",                                  "Divisa",               "", "( cDbfRec )", {|| cDivEmp() } } )
   aAdd( aBasRecCli, {"nVdvPgo"     ,"N", 10, 6, "Cambio de la divisa",                                  "ValorDivisa",          "", "( cDbfRec )", {|| nChgDiv() } } )
   aAdd( aBasRecCli, {"lConPgo"     ,"L",  1, 0, "Lógico de contabilizado",                              "Contabilizada",        "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cConGuid"    ,"C", 40, 0, "Guid de apunte contable",                              "GuidApunteContable",   "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtaRec"     ,"C", 12, 0, "Cuenta de contabilidad",                               "CuentaContable",       "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"nImpEur"     ,"N", 16, 6, "Importe del pago en Euros",                            "ImporteEuros",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lImpEur"     ,"L",  1, 0, "Lógico cobrar en Euros",                               "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"nNumRem"     ,"N",  9, 0, "Número de la remesas",                                 "NumeroRemesa",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cSufRem"     ,"C",  2, 0, "Sufijo de remesas",                                    "SufijoRemesa",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtaRem"     ,"C",  3, 0, "Cuenta de remesa",                                     "CuentaRemesa",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lRecImp"     ,"L",  1, 0, "Lógico ya impreso",                                    "LogicoImpreso",        "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lRecDto"     ,"L",  1, 0, "Lógico descontado",                                    "LogicoDescontado",     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dFecDto"     ,"D",  8, 0, "Fecha del descuento",                                  "FechaDescuento",       "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dFecVto"     ,"D",  8, 0, "Fecha de vencimiento",                                 "FechaVencimiento",     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCodAge"     ,"C",  3, 0, "Código del agente",                                    "Agente",               "", "( cDbfRec )", {|| AccessCode():cAgente } } )
   aAdd( aBasRecCli, {"nNumCob"     ,"N",  9, 0, "Número de cobro",                                      "NumeroCobro",          "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cSufCob"     ,"C",  2, 0, "Sufijo del cobro",                                     "SufijoCobro",          "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"nImpCob"     ,"N", 16, 6, "Importe del cobro",                                    "ImporteCobro",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"nImpGas"     ,"N", 16, 6, "Importe de gastos",                                    "ImporteGastos",        "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtaGas"     ,"C", 12, 0, "Subcuenta de gastos",                                  "SubcuentaGastos",      "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lEsperaDoc"  ,"L",  1, 0, "Lógico a la espera de documentación",                  "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lCloPgo"     ,"L",  1, 0, "Lógico de turno cerrado",                              "DocumentoCerrado",     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dFecImp"     ,"D",  8, 0, "Última fecha de impresión" ,                           "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cHorImp"     ,"C",  5, 0, "Hora de la última impresión" ,                         "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lNotArqueo"  ,"L",  1, 0, "Lógico de no incluir en arqueo",                       "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCodBnc"     ,"C",  4, 0, "Código del banco",                                     "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dFecCre"     ,"D",  8, 0, "Fecha de creación del registro" ,                      "FechaCreacion",        "", "( cDbfRec )", {|| Date() } } )
   aAdd( aBasRecCli, {"cHorCre"     ,"C",  5, 0, "Hora de creación del registro" ,                       "HoraCreacion",         "", "( cDbfRec )", {|| Time() } } )
   aAdd( aBasRecCli, {"cCodUsr"     ,"C",  3, 0, "Código del usuario" ,                                  "Usuario",              "", "( cDbfRec )", {|| Auth():Codigo() } } )
   aAdd( aBasRecCli, {"lDevuelto"   ,"L",  1, 0, "Lógico recibo devuelto" ,                              "LogicoDevuelto",       "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"dFecDev"     ,"D",  8, 0, "Fecha devolución" ,                                    "FechaDevolucion",      "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cMotDev"     ,"C",250, 0, "Motivo devolución" ,                                   "MotivoDevolucion",     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cRecDev"     ,"C", 14, 0, "Recibo de procedencia",                                "ReciboProcedencia",    "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lSndDoc"     ,"L",  1, 0, "Lógico para envio",                                    "Envio",                "", "( cDbfRec )", {|| .t. } } )
   aAdd( aBasRecCli, {"cBncEmp"     ,"C", 50, 0, "Banco de la empresa para el recibo",                   "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo",                     "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cEPaisIBAN"  ,"C",  2, 0, "País IBAN de la empresa para el recibo",               "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cECtrlIBAN"  ,"C",  2, 0, "Dígito de control IBAN de la empresa para el recibo",  "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",                   "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",                  "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa",         "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",                        "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cPaisIBAN"   ,"C",  2, 0, "País IBAN del cliente para el recibo" ,                "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtrlIBAN"   ,"C",  2, 0, "Dígito de control IBAN del cliente para el recibo" ,   "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",                     "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",                    "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cDigCli"     ,"C",  2, 0, "Dígito de control de la cuenta del cliente",           "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",                          "",                     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lRemesa"     ,"L",  1, 0, "Lógico de incluido en una remesa",                     "IncluidoEnRemesa",     "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cNumMtr"     ,"C", 15, 0, "Número del recibo matriz",                             "NumeroMatriz",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"lPasado"     ,"L",  1, 0, "Lógico pasado",                                        "LogicoPasado",         "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"cCtrCoste"   ,"C",  9, 0, "Código del centro de coste",                           "CentroCoste",          "", "( cDbfRec )", nil } )
   aAdd( aBasRecCli, {"nImpRel"     ,"N", 16, 6, "Importe relacionados",                                 "ImporteRelacionados",  "", "( cDbfRec )", nil } )

RETURN ( aBasRecCli )

//---------------------------------------------------------------------------//

FUNCTION aItmGruposRecibos()

   local aBasRecCli  := {}

   aAdd( aBasRecCli, {"cNumMtr"     ,"C", 14, 0, "Número de recibo matriz",         "",                "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cNumRec"     ,"C", 14, 0, "Número de recibo relacionado",    "",                "", "( cDbfRec )" } )

RETURN ( aBasRecCli )

//---------------------------------------------------------------------------//
// 
// Fachada para vistas
//

FUNCTION generatePagosFacturaCliente( Id, nView, nMode )

   sysrefresh()

RETURN ( genPgoFacCli( Id, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():Clientes( nView ), D():FormasPago( nView ), D():Divisas( nView ), D():TiposIva( nView ), nMode, .f. ) )   

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/

FUNCTION genPgoFacCli( cNumFac, cFacCliT, cFacCliL, cFacCliP, cAntCliT, cClient, cFPago, cDiv, cIva, nMode, lMessage ) 

   local cCodPgo
   local cSerFac
   local nNumFac
   local cSufFac
   local cDivFac
   local nVdvFac
   local dFecFac
   local cCodCli
   local cNomCli
   local cCodAge
   local cCodCaj
   local cCodUsr
   local cCtaRem     := ""
   local nCobro      := 0
   local nTotal      := 0
   local nTotCob     := 0
   local nDec        := 0
   local nInc        := 0
   local n           := 0
   local nTotAcu     := 0
   local nPlazos     := 1
   local nRecCli
   local cPaisIBAN
   local cCtrlIBAN
   local cEntidad
   local cSucursal
   local cControl
   local cCuenta
   local cBanco
   local lAlert

   DEFAULT nMode        := APPD_MODE
   DEFAULT lMessage     := .t.

   if !empty( nView )
      DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
      DEFAULT cFPago    := D():FormasPago( nView )
      DEFAULT cDiv      := D():Divisas( nView )
      DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
      DEFAULT cFacCliT  := D():FacturasClientes( nView )
      DEFAULT cAntCliT  := D():AnticiposClientes( nView )
   end if

   lAlert               := ( nMode == APPD_MODE )

   cSerFac              := ( cFacCliT )->cSerie
   nNumFac              := ( cFacCliT )->nNumFac
   cSufFac              := ( cFacCliT )->cSufFac
   cDivFac              := ( cFacCliT )->cDivFac
   nVdvFac              := ( cFacCliT )->nVdvFac
   dFecFac              := ( cFacCliT )->dFecFac
   cCodPgo              := ( cFacCliT )->cCodPago
   cCodCli              := ( cFacCliT )->cCodCli
   cNomCli              := ( cFacCliT )->cNomCli
   cCodAge              := ( cFacCliT )->cCodAge
   cCodCaj              := ( cFacCliT )->cCodCaj
   cCodUsr              := ( cFacCliT )->cCodUsr
   cBanco               := ( cFacCliT )->cBanco
   cPaisIBAN            := ( cFacCliT )->cPaisIBAN 
   cCtrlIBAN            := ( cFacCliT )->cCtrlIBAN
   cEntidad             := ( cFacCliT )->cEntBnc
   cSucursal            := ( cFacCliT )->cSucBnc
   cControl             := ( cFacCliT )->cDigBnc
   cCuenta              := ( cFacCliT )->cCtaBnc

//   if ( nMode == APPD_MODE .and. nMode == DUPL_MODE )
//      generaRecibosFacturasClientes( cNumFac, cFacCliT, cFacCliL, cFacCliP, cAntCliT, cClient, cFPago, cDiv, cIva, nMode, lMessage )

   /*
   Cuenta de remesas-----------------------------------------------------------
   */

   nRecCli           := ( cClient )->( Recno() )

   if ( cClient )->( dbSeek( cCodCli ) )
      cCtaRem        := ( cClient )->cCodRem
   end if

   /*
   Decimales para el redondeo--------------------------------------------------
   */

   nDec              := nRouDiv( cDivFac, cDiv ) // Decimales de la divisa redondeada

   /*
   Comprobar q el total de factura  no es igual al de pagos--------------------
   */

   nTotal            := nTotFacCli( cNumFac, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, cAntCliT, nil, nil, .f. )

   nTotCob           := nTotalRecibosGeneradosFacturasCliente( cNumFac, cFacCliT, cFacCliP, cIva, cDiv )

   /*
   Ya nos viene sin los anticipos
   */

   if lDiferencia( nTotal, nTotCob, 0.001 )

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar
      */

      if ( cFacCliP )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) )

         while cSerFac + str( nNumFac ) + cSufFac == ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac

            if !( cFacCliP )->lCobrado .and. !( cFacCliP )->lDevuelto .and. empty( ( cFacCliP )->cTipRec ) .and. dbLock( cFacCliP )
               ( cFacCliP )->( dbDelete() )
               ( cFacCliP )->( dbUnLock() )
            else
               nInc  := ( cFacCliP )->nNumRec
            end if

            ( cFacCliP )->( dbSkip() )

         end while

      end if

      /*
      Vamos a relizar pagos por la diferencia entre el total y lo cobrado------
      */

      nTotal         -= nTotalRecibosPagadosFacturasCliente( cSerFac + str( nNumFac ) + cSufFac, cFacCliT, cFacCliP, cIva, cDiv )

      /*
      Genera pagos-------------------------------------------------------------
      */

      if ( dbSeekInOrd( cCodPgo, "cCodPago", cFPago ) )

         nTotAcu        := nTotal
         nPlazos        := Max( ( cFPago )->nPlazos, 1 )

         for n := 1 to nPlazos

            if n != nPlazos
               nTotAcu  -= Round( nTotal / nPlazos, nDec )
            end if

            ( cFacCliP )->( dbAppend() )

            ( cFacCliP )->cTurRec       := cCurSesion()
            ( cFacCliP )->cSerie        := cSerFac
            ( cFacCliP )->nNumFac       := nNumFac
            ( cFacCliP )->cSufFac       := cSufFac
            ( cFacCliP )->nNumRec       := ++nInc
            ( cFacCliP )->cCodCaj       := cCodCaj
            ( cFacCliP )->cCodUsr       := cCodUsr
            ( cFacCliP )->cCodPgo       := cCodPgo
            ( cFacCliP )->cCodCli       := cCodCli
            ( cFacCliP )->cNomCli       := cNomCli

            if ( cFPago )->lUtlBnc
               ( cFacCliP )->cPaisIBAN  := ( cFPago )->cPaisIBAN
               ( cFacCliP )->cCtrlIBAN  := ( cFPago )->cCtrlIBAN
               ( cFacCliP )->cBncEmp    := ( cFPago )->cBanco
               ( cFacCliP )->cEntEmp    := ( cFPago )->cEntBnc
               ( cFacCliP )->cSucEmp    := ( cFPago )->cSucBnc
               ( cFacCliP )->cDigEmp    := ( cFPago )->cDigBnc
               ( cFacCliP )->cCtaEmp    := ( cFPago )->cCtaBnc
            end if

            ( cFacCliP )->cPaisIBAN     := cPaisIBAN
            ( cFacCliP )->cCtrlIBAN     := cCtrlIBAN
            ( cFacCliP )->cBncCli       := cBanco
            ( cFacCliP )->cEntCli       := cEntidad
            ( cFacCliP )->cSucCli       := cSucursal
            ( cFacCliP )->cDigCli       := cControl
            ( cFacCliP )->cCtaCli       := cCuenta

            ( cFacCliP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cFacCliP )->nImpCob       := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cFacCliP )->cDescrip      := "Recibo nº" + AllTrim( str( nInc ) ) + " de factura " + cSerFac  + '/' + allTrim( str( nNumFac ) ) + '/' + cSufFac

            ( cFacCliP )->cDivPgo       := cDivFac
            ( cFacCliP )->nVdvPgo       := nVdvFac
            ( cFacCliP )->dPreCob       := dFecFac
            ( cFacCliP )->dFecVto       := dNextDayPago( dFecFac, n, nPlazos, cFPago, cClient )
            
            ( cFacCliP )->cCtaRec       := ( cFPago )->cCtaCobro
            ( cFacCliP )->cCtaGas       := ( cFPago )->cCtaGas

            ( cFacCliP )->cCtaRem       := cCtaRem
            ( cFacCliP )->cCodAge       := cCodAge
            ( cFacCliP )->lEsperaDoc    := ( cFPago )->lEsperaDoc
            ( cFacCliP )->lSndDoc       := .t.

            if !empty( ( cFacCliT )->cCtrCoste )
                ( cFacCliP )->cCtrCoste := ( cFacCliT )->cCtrCoste
            endif

            if !( "TABLET" $ appParamsMain() )

               if ( cFPago )->nCobRec == 1 .and. nMode == APPD_MODE
                  ( cFacCliP )->cTurRec    := cCurSesion()
                  ( cFacCliP )->lCobrado   := .t.
                  ( cFacCliP )->dEntrada   := dNextDayPago( dFecFac, n, nPlazos, cFPago, cClient )
               end if

            else
            
               if ( cFPago )->nCobRec == 1
                  ( cFacCliP )->cTurRec    := cCurSesion()
                  ( cFacCliP )->lCobrado   := .t.
                  ( cFacCliP )->dEntrada   := dNextDayPago( dFecFac, n, nPlazos, cFPago, cClient )
               end if

            end if

            ( cFacCliP )->dFecCre          := GetSysDate()
            ( cFacCliP )->cHorCre          := Substr( Time(), 1, 5 )

            lAlert                         := .f.

            ( cFacCliP )->( dbunlock() )

            // Insertar vencimiento en contaplus-------------------------------

            if ConfiguracionEmpresasRepository():getLogic( 'sincronizar_vencimientos', .f. )
               insertVencimientoContaplus( cFacCliP, cClient )
            end if 

         next

      else

         if lMessage
            MsgStop( "Forma de pago " + cCodPgo + " no encontrada, generando recibos" )
         end if

      end if

   end if

   ( cClient )->( dbGoTo( nRecCli ) )

   if ( lAlert .and. lMessage )
      msgWait( "Factura " + cSerFac  + '/' + allTrim( str( nNumFac ) ) + '/' + cSufFac + " no se generaron recibos.", "Atención", 1 )
   end if

RETURN NIL

//---------------------------------------------------------------------------//
/*
STATIC FUNCTION generaRecibosFacturasClientes( cNumFac, cFacCliT, cFacCliL, cFacCliP, cAntCliT, cClient, cFPago, cDiv, cIva, nMode, lMessage )

   local nPlazo
   local nPlazos                 := 0
   local nDecimales              := nRouDiv( ( cFacCliT )->cDivFac, cDiv )
   local cCuentaRemesa           := retFld( ( cFacCliT )->cCodCli, cClient, "cCodRem", "Cod" )
   local nTotalGenerado          := 0
   local nTotalFactura           := nTotFacCli( cNumFac, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, cAntCliT, nil, nil, .f. )
   local nTotalRecibosGenerados  := nTotalRecibosGeneradosFacturasCliente( cNumFac, cFacCliT, cFacCliP, cIva, cDiv )
   local nTotalRecibosPagados    := nTotalRecibosPagadosFacturasCliente( cNumFac, cFacCliT, cFacCliP, cIva, cDiv )

   // Elimnamos recibos existentes pero no deberia si es nueva----------------

   deleteRecibosFacturasClientes( cNumFac, dbfFacCliP )

   // comprobamos q exista la forma de pago-----------------------------------

   if !( dbSeekInOrd( cCodPgo, "cCodPago", cFPago ) )
      msgStop( "Forma de pago no econtrada, imposible generar recibos" )
      RETURN .f.
   end if

   nPlazos                       := max( ( cFPago )->nPlazos, 1 )

   for nPlazo := 1 to nPlazos

      if nPlazo != nPlazos
         generaReciboFacturaCliente( cNumFac, nImporteRecibo, nPlazo, cFacCliT, cFacCliP )

         nTotAcu                 = Round( nTotal / nPlazos, nDec )
            end if

            ( cFacCliP )->( dbAppend() )



STATIC FUNCTION generaReciboFacturaCliente( cNumFac, nImporteRecibo, nPlazo, cFacCliT, cFacCliP )

   local nRecno   := ( cFacCliT )->( recno() )

   if dbSeekInOrd( cNumFac, "nNumFac", cFacCliT )

      ( cFacCliP )->( dbAppend() )

      ( cFacCliP )->cTurRec       := cCurSesion()
      ( cFacCliP )->cSerie        := ( cFacCliT )->cSerie
      ( cFacCliP )->nNumFac       := ( cFacCliT )->nNumFac
      ( cFacCliP )->cSufFac       := ( cFacCliT )->cSufFac
      ( cFacCliP )->nNumRec       := nPlazo
            ( cFacCliP )->cCodCaj       := cCodCaj
            ( cFacCliP )->cCodUsr       := cCodUsr
            ( cFacCliP )->cCodPgo       := cCodPgo
            ( cFacCliP )->cCodCli       := cCodCli
            ( cFacCliP )->cNomCli       := cNomCli

            if ( cFPago )->lUtlBnc
               ( cFacCliP )->cPaisIBAN  := ( cFPago )->cPaisIBAN
               ( cFacCliP )->cCtrlIBAN  := ( cFPago )->cCtrlIBAN
               ( cFacCliP )->cBncEmp    := ( cFPago )->cBanco
               ( cFacCliP )->cEntEmp    := ( cFPago )->cEntBnc
               ( cFacCliP )->cSucEmp    := ( cFPago )->cSucBnc
               ( cFacCliP )->cDigEmp    := ( cFPago )->cDigBnc
               ( cFacCliP )->cCtaEmp    := ( cFPago )->cCtaBnc
            end if

            ( cFacCliP )->cPaisIBAN     := cPaisIBAN
            ( cFacCliP )->cCtrlIBAN     := cCtrlIBAN
            ( cFacCliP )->cBncCli       := cBanco
            ( cFacCliP )->cEntCli       := cEntidad
            ( cFacCliP )->cSucCli       := cSucursal
            ( cFacCliP )->cDigCli       := cControl
            ( cFacCliP )->cCtaCli       := cCuenta

            ( cFacCliP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cFacCliP )->nImpCob       := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cFacCliP )->cDescrip      := "Recibo nº" + AllTrim( str( nInc ) ) + " de factura " + cSerFac  + '/' + allTrim( str( nNumFac ) ) + '/' + cSufFac

            ( cFacCliP )->cDivPgo       := cDivFac
            ( cFacCliP )->nVdvPgo       := nVdvFac
            ( cFacCliP )->dPreCob       := dFecFac
            ( cFacCliP )->dFecVto       := dNextDayPago( dFecFac, n, nPlazos, cFPago, dbfCli )
            
            ( cFacCliP )->cCtaRec       := ( cFPago )->cCtaCobro
            ( cFacCliP )->cCtaGas       := ( cFPago )->cCtaGas

            ( cFacCliP )->cCtaRem       := cCtaRem
            ( cFacCliP )->cCodAge       := cCodAge
            ( cFacCliP )->lEsperaDoc    := ( cFPago )->lEsperaDoc

            if !empty( ( cFacCliT )->cCtrCoste )
                ( cFacCliP )->cCtrCoste := ( cFacCliT )->cCtrCoste
            endif

            if !( "TABLET" $ appParamsMain() )

               if ( cFPago )->nCobRec == 1 .and. nMode == APPD_MODE
                  ( cFacCliP )->cTurRec    := cCurSesion()
                  ( cFacCliP )->lCobrado   := .t.
                  ( cFacCliP )->dEntrada   := dNextDayPago( dFecFac, n, nPlazos, cFPago, dbfCli )
                  
               end if

            else
            
               if ( cFPago )->nCobRec == 1
                  ( cFacCliP )->cTurRec    := cCurSesion()
                  ( cFacCliP )->lCobrado   := .t.
                  ( cFacCliP )->dEntrada   := dNextDayPago( dFecFac, n, nPlazos, cFPago, dbfCli )
                  
               end if

            end if

            ( cFacCliP )->dFecCre          := GetSysDate()
            ( cFacCliP )->cHorCre          := Substr( Time(), 1, 5 )

            lAlert                           := .f.

            ( cFacCliP )->( dbUnLock() )

         next

*/

FUNCTION dNexDay( dFecPgo, dbfCli )

   local nDay
   local nMon
   local nYea

   if empty( dbfCli )
      RETURN ( dFecPgo )
   end if

   nDay        := Day( dFecPgo )
   nYea        := Year( dFecPgo )
   nMon        := Month( dFecPgo )

   if ( dbfCli )->DiaPago != 0

      /*
      Si el dia de vencimiento es mayor que el dia de pago summos un mes
      */

      if nDay > ( dbfCli )->DiaPago

         if nDay > ( dbfCli )->DiaPago2

            if nMon == 12
               nMon := 1
               nYea++
            else
               nMon++
            end if

            nDay := ( dbfCli )->DiaPago

         else

            nDay := ( dbfCli )->DiaPago2

         end if

      else

         nDay := ( dbfCli )->DiaPago

      end if

   end if

   /*
   Comporbar q el recibo no va en el mes de vacaciones
   */

   if ( ( dbfCli )->nMesVac - 1 ) == nMon

      if nMon == 12
         nMon := 1
         nYea++
      else
         nMon++
      end if

   end if

RETURN ( Ctod( str( nDay, 2 ) + "/" + str( nMon, 2 ) + "/" + str( nYea, 4 ) ) )

//----------------------------------------------------------------------------//

Function ValCobro( aGet, aTmp )

   if aTmp[ _NIMPCOB ] <= aTmp[ _NIMPORTE ]

      if ( aTmp[ _NIMPCOB ] != 0 ) .and. ( aTmp[ _NIMPORTE ] != aTmp[ _NIMPCOB ] )
         aGet[ _NIMPGAS ]:cText( aTmp[ _NIMPORTE ] - aTmp[ _NIMPCOB ] )
      end if

      RETURN .t.

   else

      msgStop( "El importe del cobro excede al importe del recibo" )

   end if

RETURN .f.

//---------------------------------------------------------------------------//

Function ValCheck( aGet, aTmp )

   if aTmp[ _LCOBRADO ]

      aGet[ _DENTRADA ]:cText( GetSysDate() )
      aGet[ _CTURREC  ]:cText( cCurSesion( nil, .f. ) )
      aGet[ _CCODCAJ  ]:cText( oUser():cCaja() )
      aGet[ _CCODCAJ  ]:lValid()

      if aTmp[ _NIMPCOB ] == 0
         aGet[ _NIMPCOB ]:cText( aTmp[ _NIMPORTE ] )
      end if

   else

      aGet[ _DENTRADA ]:cText( Ctod( "" ) )

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function lChangeDevolucion( aGet, aTmp, lIntro )

   DEFAULT lIntro := .f.

   if aTmp[ _LDEVUELTO ]

      if !lIntro
         aGet[ _DFECDEV ]:cText( GetSysDate() )
      end if

      aGet[ _DPRECOB    ]:HardDisable()
      aGet[ _DFECVTO    ]:HardDisable()
      aGet[ _NIMPORTE   ]:HardDisable()
      aGet[ _NIMPCOB    ]:HardDisable()
      aGet[ _LCOBRADO   ]:HardDisable()
      aGet[ _DENTRADA   ]:HardDisable()
      aGet[ _CCODAGE    ]:HardDisable()
      aGet[ _CCODPGO    ]:HardDisable()
      aGet[ _CDESCRIP   ]:HardDisable()
      aGet[ _CPGDOPOR   ]:HardDisable()
      aGet[ _CDOCPGO    ]:HardDisable()
      aGet[ _NIMPGAS    ]:HardDisable()
      aGet[ _CCTAREC    ]:HardDisable()
      aGet[ _CCTAREM    ]:HardDisable()
      aGet[ _CCODCAJ    ]:HardDisable()
      aGet[ _LNOTARQUEO ]:HardDisable()
      aGet[ _LRECIMP    ]:HardDisable()
      aGet[ _DFECIMP    ]:HardDisable()
      aGet[ _CHORIMP    ]:HardDisable()
      aGet[ _LESPERADOC ]:HardDisable()
      aGet[ _CTURREC    ]:HardDisable()
      aGet[ _CBNCEMP    ]:HardDisable()
      aGet[ _CBNCCLI    ]:HardDisable()
      aGet[ _CEPAISIBAN ]:HardDisable()
      aGet[ _CECTRLIBAN ]:HardDisable()      
      aGet[ _CENTEMP    ]:HardDisable()
      aGet[ _CSUCEMP    ]:HardDisable()
      aGet[ _CDIGEMP    ]:HardDisable()
      aGet[ _CCTAEMP    ]:HardDisable()
      aGet[ _CPAISIBAN  ]:HardDisable()
      aGet[ _CCTRLIBAN  ]:HardDisable()      
      aGet[ _CENTCLI    ]:HardDisable()
      aGet[ _CSUCCLI    ]:HardDisable()
      aGet[ _CDIGCLI    ]:HardDisable()
      aGet[ _CCTACLI    ]:HardDisable()

   else

      if !lIntro
         aGet[ _DFECDEV ]:cText( Ctod( "" ) )
         aGet[ _CMOTDEV ]:cText( space( 250 ) )
      end if

      aGet[ _DPRECOB    ]:HardEnable()
      aGet[ _DFECVTO    ]:HardEnable()
      aGet[ _NIMPORTE   ]:HardEnable()
      aGet[ _NIMPCOB    ]:HardEnable()
      aGet[ _LCOBRADO   ]:HardEnable()
      aGet[ _DENTRADA   ]:HardEnable()
      aGet[ _CCODAGE    ]:HardEnable()
      aGet[ _CCODPGO    ]:HardEnable()
      aGet[ _CDESCRIP   ]:HardEnable()
      aGet[ _CPGDOPOR   ]:HardEnable()
      aGet[ _CDOCPGO    ]:HardEnable()
      aGet[ _NIMPGAS    ]:HardEnable()
      aGet[ _CCTAREC    ]:HardEnable()
      aGet[ _CCTAREM    ]:HardEnable()
      aGet[ _CCODCAJ    ]:HardEnable()
      aGet[ _LNOTARQUEO ]:HardEnable()
      aGet[ _LRECIMP    ]:HardEnable()
      aGet[ _DFECIMP    ]:HardEnable()
      aGet[ _CHORIMP    ]:HardEnable()
      aGet[ _LESPERADOC ]:HardEnable()
      aGet[ _CTURREC    ]:HardEnable()
      aGet[ _CBNCEMP    ]:HardEnable()
      aGet[ _CBNCCLI    ]:HardEnable()
      aGet[ _CENTEMP    ]:HardEnable()
      aGet[ _CSUCEMP    ]:HardEnable()
      aGet[ _CDIGEMP    ]:HardEnable()
      aGet[ _CCTAEMP    ]:HardEnable()
      aGet[ _CENTCLI    ]:HardEnable()
      aGet[ _CSUCCLI    ]:HardEnable()
      aGet[ _CDIGCLI    ]:HardEnable()
      aGet[ _CCTACLI    ]:HardEnable()

   end if

   if empty( aTmp[ _CRECDEV ] )
      aGet[ _CRECDEV ]:Disable()
   else
      aGet[ _CRECDEV ]:Enable()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function DelCobCli( oBrw, cFacCliP )

   if ( cFacCliP )->lCloPgo .and. !oUser():lAdministrador()
      MsgStop( "Solo pueden eliminar los recibos cerrados los administradores." )
      RETURN .f.
   end if

   if !empty( ( cFacCliP )->nNumRem ) .and. !oUser():lAdministrador()
      msgStop( "Este tiket pertenece a una remesa de clientes.", "Imposible eliminar" )
      RETURN .f.
   end if

   if !empty( ( cFacCliP )->nNumCob ) .and. !oUser():lAdministrador()
      msgStop( "Este tiket pertenece a una remesa de cobros.", "Imposible eliminar" )
      RETURN .f.
   end if

   if ( cFacCliP )->lCobrado .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta cobrado.", "Imposible eliminar" )
      RETURN .f.
   end if

   if ( cFacCliP )->lRecDto .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta descontado.", "Imposible eliminar" )
      RETURN .f.
   end if

   if !empty( ( cFacCliP )->cNumMtr )
      msgStop( "Este recibo está compensado", "Imposible eliminar" )
      RETURN .f.
   end if

/*
   if !empty( ( cFacCliP )->lCobrado )
      msgStop( "Este recibo está liquidado", "Imposible eliminar" )
      RETURN .f.
   end if
*/
   WinDelRec( oBrw, cFacCliP, {|| QuiRecCli( cFacCliP ) } )

RETURN .t.

//---------------------------------------------------------------------------//

Function QuiRecCli( cFacCliP )

   local cNumRec  := ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac + str( ( cFacCliP )->nNumRec ) + ( cFacCliP )->cTipRec
   local nRec     := ( cFacCliP )->( Recno() )
   local nOrdAnt  := ( cFacCliP )->( OrdSetFocus( "cNumMtr" ) )
   local aRecibos := {}
   local cRecibo

   if ( cFacCliP )->( dbSeek( cNumRec ) )

      while ( cFacCliP )->cNumMtr == cNumRec .and. !( cFacCliP )->( Eof() )

         aAdd( aRecibos, ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac + str( ( cFacCliP )->nNumRec ) )

         ( cFacCliP )->( dbSkip() )

      end while
      
   end if

   ( cFacCliP )->( OrdSetFocus( "nNumFac" ) )

   for each cRecibo in aRecibos

      if ( cFacCliP )->( dbSeek( cRecibo ) ) .and.;
         dbLock( cFacCliP )

         ( cFacCliP )->lCobrado  := .f.
         ( cFacCliP )->dEntrada  := cTod( "" )
         ( cFacCliP )->cNumMtr   := ""
         ( cFacCliP )->( dbUnLock() )

      end if

   next

   ( cFacCliP )->( OrdSetFocus( nOrdAnt ) )
   ( cFacCliP )->( dbGoTo( nRec ) )

RETURN .t.

//---------------------------------------------------------------------------//

function nNewReciboCliente( cNumFac, cTipRec, cFacCliP )

   local nCon
   local nRec
   local nOrd
   local cFilter     := ""

   DEFAULT cTipRec   := space( 1 )

   nCon              := 1
   nRec              := ( cFacCliP )->( Recno() )
   nOrd              := ( cFacCliP )->( OrdSetFocus( "nNumFac" ) )
   //cFilter           := ( cFacCliP )->( dbInfo( DBI_DBFILTER ) )
   
   //( cFacCliP )->( dbClearFilter() )

   ( cFacCliP )->( dbGoTop() )

   if ( cFacCliP )->( dbSeek( cNumFac ) )

      while ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac == cNumFac .and. !( cFacCliP )->( eof() )

         if ( cFacCliP )->cTipRec == cTipRec
            ++nCon
         end if

         ( cFacCliP )->( dbSkip() )

      end do

   end if

   ( cFacCliP )->( OrdSetFocus( nOrd ) )
   ( cFacCliP )->( dbGoTo( nRec ) )

   /*if !Empty( cFilter ) 
      ( cFacCliP )->( dbSetFilter( bCheck2Block( cFilter ), cFilter ) )
      ( cFacCliP )->( dbGoTop() )
   end if

   MsgInfo( ( cFacCliP )->( dbInfo( DBI_DBFILTER ) ) )*/

RETURN ( nCon )

//------------------------------------------------------------------------//

STATIC FUNCTION YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, cFacCliP, oBrw, oDlg, nMode, nSpecialMode )

   local nRec        
   local nImp
   local nCon
   local aTabla
   local nOrdAnt
   local lImpNeg
   local nImpFld
   local nImpTmp
   local cNumFac
   local cNumRec
   local cNumRecTip
   local lDevuelto
   local lCobrado
   local dFechaCobro
   local cRecibo
   local cTipoRecibo
   local cSerie         := ""

   if empty( cFacCliP )
      cFacCliP          := D():FacturasClientesCobros( nView )
   end if

   if nSpecialMode == LIBRE_MODE

      if !lValidReciboLibre( aTmp )
         RETURN .f.
      end if

      cSerie            := cNewSer( "nRecCli", D():Contadores( nView ) )
      
      aTmp[ _CTIPREC ]  := "L"
      aTmp[ _CSERIE  ]  := cSerie
      aTmp[ _NNUMFAC ]  := nNewDoc( cSerie, cFacCliP, "nRecCli", , D():Contadores( nView ) )
      aTmp[ _CSUFFAC ]  := RetSufEmp()
      aTmp[ _NNUMREC ]  := 1

   end if

   cNumFac              := aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ], 9 ) + aTmp[ _CSUFFAC ]
   cNumRec              := aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ], 9 ) + aTmp[ _CSUFFAC ] + str( aTmp[ _NNUMREC ], 2 )
   cNumRecTip           := aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ], 9 ) + aTmp[ _CSUFFAC ] + str( aTmp[ _NNUMREC ], 2 ) + aTmp[ _CTIPREC ]
   lDevuelto            := aTmp[ _LDEVUELTO ]
   cTipoRecibo          := aTmp[ _CTIPREC  ]
   lCobrado             := aTmp[ _LCOBRADO ]
   dFechaCobro          := aTmp[ _DENTRADA ]
   lImpNeg              := ( cFacCliP )->nImporte < 0
   nImpFld              := abs( ( cFacCliP )->nImporte )
   nImpTmp              := abs( aTmp[ _NIMPORTE ] )
   
   /*
   Condiciones antes de grabar-------------------------------------------------
   */

   if !aGet[ _NIMPCOB ]:lValid()
      RETURN .f.
   end if

   /*
   El importe no puede ser mayor q el importe anterior-------------------------

   if nSpecialMode != LIBRE_MODE
      if nImpTmp > nImpFld
         msgStop( "El importe no puede ser superior al actual." )
         RETURN nil
      end if
   end if
   */

   if !lExisteTurno( aGet[ _CTURREC ]:VarGet(), D():Turnos( nView ) )
      msgStop( "La sesión introducida no existe." )
      aGet[ _CTURREC ]:SetFocus()
      RETURN nil
   end if

   oDlg:Disable()

   /*
   Comprobamos q los importes sean distintos-----------------------------------
   */

   if nSpecialMode != LIBRE_MODE

      if ( nImpFld != nImpTmp )
      
         nRec                       := ( cFacCliP )->( Recno() )

         /*
         El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
         */

         nImp                       := ( nImpFld - nImpTmp ) * if( lImpNeg, - 1 , 1 )

         /*
         Obtnenemos el nuevo numero del contador----------------------------------
         */

         nCon                       := nNewReciboCliente( aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], aTmp[ _CTIPREC ], cFacCliP )

         /*
         Añadimos el nuevo recibo-------------------------------------------------
         */

         ( cFacCliP )->( dbAppend() )

         ( cFacCliP )->cTurRec    := cCurSesion()
         ( cFacCliP )->cTipRec    := aTmp[ _CTIPREC ]
         ( cFacCliP )->cSerie     := aTmp[ _CSERIE  ]
         ( cFacCliP )->nNumFac    := aTmp[ _NNUMFAC ]
         ( cFacCliP )->cSufFac    := aTmp[ _CSUFFAC ]
         ( cFacCliP )->nNumRec    := nCon
         ( cFacCliP )->cCodCaj    := aTmp[ _CCODCAJ ]
         ( cFacCliP )->cCodCli    := aTmp[ _CCODCLI ]
         ( cFacCliP )->cNomCli    := aTmp[ _CNOMCLI ]
         ( cFacCliP )->cCodAge    := aTmp[ _CCODAGE ] 
         ( cFacCliP )->dEntrada   := Ctod( "" )
         ( cFacCliP )->nImporte   := nImp
         ( cFacCliP )->nImpCob    := nImp
         ( cFacCliP )->cDescrip   := "Recibo nº" + AllTrim( str( nCon ) ) + " de factura " + if( !empty( aTmp[ _CTIPREC ] ), "rectificativa ", "" ) + aTmp[ _CSERIE ] + '/' + AllTrim( str( aTmp[ _NNUMFAC ] ) ) + '/' + aTmp[ _CSUFFAC ]
         ( cFacCliP )->dPreCob    := dFecFacCli( aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], D():FacturasClientes( nView ) )
         ( cFacCliP )->cPgdoPor   := ""
         ( cFacCliP )->lCobrado   := .f.
         ( cFacCliP )->cDivPgo    := aTmp[ _CDIVPGO ]
         ( cFacCliP )->nVdvPgo    := aTmp[ _NVDVPGO ]
         ( cFacCliP )->cCodPgo    := aTmp[ _CCODPGO ]
         ( cFacCliP )->lConPgo    := .f.
         ( cFacCliP )->lSndDoc    := .t.
         ( cFacCliP )->dFecCre    := GetSysDate()
         ( cFacCliP )->cHorCre    := Substr( Time(), 1, 5 )

         ( cFacCliP )->( dbUnLock() )

         ( cFacCliP )->( dbGoTo( nRec ) )

      end if

   end if

   /*
   Estado de la contabilizacion------------------------------------------------
   */

   if ( lOldDevuelto != lDevuelto )
      aTmp[ _LCONPGO ]           := .f.
   end if

   /*
   Ponemos la fecha y hora de creacion y modificación--------------------------
   */

   aTmp[ _DFECCRE ]    := GetSysDate()
   aTmp[ _CHORCRE ]    := Substr( Time(), 1, 5 )

   /*
   Grabamos el recibo----------------------------------------------------------
   */

   WinGather( aTmp, aGet, cFacCliP, oBrw, nMode )

   /*
   Anotamos los recibos asociados----------------------------------------------
   */

   if nSpecialMode != LIBRE_MODE

      /*
      Si es Devuelto creamos el tiket nuevo---------------------------------------
      */

      if lOldDevuelto != lDevuelto

         nRec                             := ( cFacCliP )->( Recno() )

         if lDevuelto

            nOrdAnt                       := ( cFacCliP )->( OrdSetFocus( "nNumFac" ) )

            if ( cFacCliP )->( dbSeek( cNumRec ) )

               aTabla                     := dbScatter( cFacCliP )

               nCon                       := nNewReciboCliente( aTabla[ _CSERIE ] + str( aTabla[ _NNUMFAC ] ) + aTabla[ _CSUFFAC ], aTabla[ _CTIPREC ], cFacCliP )

               ( cFacCliP )->( dbAppend() )
               ( cFacCliP )->cSerie     := aTabla[ _CSERIE  ]
               ( cFacCliP )->nNumFac    := aTabla[ _NNUMFAC ]
               ( cFacCliP )->cSufFac    := aTabla[ _CSUFFAC ]
               ( cFacCliP )->nNumRec    := nCon
               ( cFacCliP )->cTipRec    := aTabla[ _CTIPREC ]
               ( cFacCliP )->cCodPgo    := aTabla[ _CCODPGO ]
               ( cFacCliP )->cCodCaj    := aTabla[ _CCODCAJ ]
               ( cFacCliP )->cTurRec    := cCurSesion()
               ( cFacCliP )->cCodCli    := aTabla[ _CCODCLI ]
               ( cFacCliP )->cNomCli    := aTabla[ _CNOMCLI ]
               ( cFacCliP )->dEntrada   := Ctod( "" )
               ( cFacCliP )->nImporte   := aTabla[ _NIMPORTE ]
               ( cFacCliP )->cDescrip   := "Recibo Nº" + alltrim( str( nCon ) ) + " generado de la devolución del recibo " + aTabla[ _CSERIE ] + "/" + alltrim( str( aTabla[ _NNUMFAC ] ) ) + "/" + aTabla[ _CSUFFAC ] + " - " + AllTrim( str( aTabla[ _NNUMREC ] ) )
               ( cFacCliP )->dPreCob    := GetSysDate()
               ( cFacCliP )->lCobrado   := .f.
               ( cFacCliP )->cDivPgo    := aTabla[ _CDIVPGO ]
               ( cFacCliP )->nVdvPgo    := aTabla[ _NVDVPGO ]
               ( cFacCliP )->lConPgo    := .f.
               ( cFacCliP )->dFecVto    := GetSysDate()
               ( cFacCliP )->cCodAge    := aTabla[ _CCODAGE ]
               ( cFacCliP )->nImpGas    := aTabla[ _NIMPGAS ]
               ( cFacCliP )->dFecCre    := GetSysDate()
               ( cFacCliP )->cHorCre    := Time()
               ( cFacCliP )->cCodUsr    := Auth():Codigo() 
               ( cFacCliP )->cRecDev    := cNumRec
               ( cFacCliP )->cBncEmp    := aTabla[ _CBNCEMP    ]
               ( cFacCliP )->cBncCli    := aTabla[ _CBNCCLI    ]
               ( cFacCliP )->cEPaisIBAN := aTabla[ _CEPAISIBAN ]
               ( cFacCliP )->cECtrlIBAN := aTabla[ _CECTRLIBAN ]
               ( cFacCliP )->cEntEmp    := aTabla[ _CENTEMP    ]
               ( cFacCliP )->cSucEmp    := aTabla[ _CSUCEMP    ]
               ( cFacCliP )->cDigEmp    := aTabla[ _CDIGEMP    ]
               ( cFacCliP )->cCtaEmp    := aTabla[ _CCTAEMP    ]
               ( cFacCliP )->cPaisIBAN  := aTabla[ _CPAISIBAN  ]
               ( cFacCliP )->cCtrlIBAN  := aTabla[ _CCTRLIBAN  ]
               ( cFacCliP )->cEntCli    := aTabla[ _CENTCLI    ]
               ( cFacCliP )->cSucCli    := aTabla[ _CSUCCLI    ]
               ( cFacCliP )->cDigCli    := aTabla[ _CDIGCLI    ]
               ( cFacCliP )->cCtaCli    := aTabla[ _CCTACLI    ]
               ( cFacCliP )->cCtaGas    := aTabla[ _CCTAGAS    ]
               ( cFacCliP )->cCtaRec    := aTabla[ _CCTAREC    ]
               ( cFacCliP )->cCtaRem    := aTabla[ _CCTAREM    ]

               ( cFacCliP )->( dbUnLock() )

            else 

               msgStop( "Número de recibo " + alltrim( cNumRec ) + " no encontrado" )

            end if

            ( cFacCliP )->( OrdSetFocus( nOrdAnt ) )

         else

            nOrdAnt                       := ( cFacCliP )->( OrdSetFocus( "cRecDev" ) )

            if ( cFacCliP )->( dbSeek( cNumRec ) ) .and. dbDialogLock( cFacCliP )
               ( cFacCliP )->( dbDelete() )
               ( cFacCliP )->( dbUnLock() )
            end if

            ( cFacCliP )->( OrdSetFocus( nOrdAnt ) )

         end if

         ( cFacCliP )->( dbGoTo( nRec ) )

      end if

      /*
      Comprobamos el estado de la factura-----------------------------------------
      */

      actualizarEstadoFactura( cTipoRecibo, cNumFac )

   else

      if isArray( aRecibosRelacionados ) .and. Len( aRecibosRelacionados ) > 0

         nRec     := ( D():FacturasClientesCobros( nView ) )->( Recno() )
         nOrdAnt  := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "nNumFac" ) )

         for each cRecibo in aRecibosRelacionados

            if ( D():FacturasClientesCobros( nView ) )->( dbSeek( cRecibo ) )

               if dbLock( D():FacturasClientesCobros( nView ) )

                  ( D():FacturasClientesCobros( nView ) )->lCobrado     := .t.
                  ( D():FacturasClientesCobros( nView ) )->dEntrada     := GetSysDate()
                  ( D():FacturasClientesCobros( nView ) )->cNumMtr      := cNumRecTip

                  ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )

                  actualizarEstadoFactura( ( D():FacturasClientesCobros( nView ) )->cTipRec, ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac )

               end if

            end if

         next

         ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrdAnt ) )
         ( D():FacturasClientesCobros( nView ) )->( dbGoTo( nRec ) )

      end if

   end if

   /*
   Limpiamos los valores para que al hacer un recibo nuevo despues de compensar no tome los valores antiguos
   */

   nTotalRelacionados      := 0

   aRecibosRelacionados    := {}

   if !empty( oClienteCompensar )
      oClienteCompensar:cText( space( 12 ) )
      oClienteCompensar    := nil
   end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oDlg:Enable()

   oDlg:End( IDOK )

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION lValidReciboLibre( aTmp )

   if empty( aTmp[ _CCODCLI ] )
      MsgInfo( "El código del cliente no puede estar vacío para un recibo libre" )
      RETURN .f.
   end if

   if empty( aTmp[ _CCODPGO ] )
      MsgInfo( "El código de la forma de pago no puede estar vacío para un recibo libre" )
      RETURN .f.
   end if

   if aTmp[ _NIMPORTE ] == 0 .and. empty( oClienteCompensar )
      MsgInfo( "No puede hacer un recibo libre con importe 0" )
      RETURN .f.
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

function RollBackRecibosRelacionados( cNumRecTip, cFacCliP )

   local nRec     := ( cFacCliP )->( Recno() )
   local nOrdAnt  := ( cFacCliP )->( OrdSetFocus( "cNumMtr" ) )

   if ( cFacCliP )->( dbSeek( cNumRecTip ) )

      while  !( cFacCliP )->( eof() )

         if ( cFacCliP )->cNumMtr == cNumRecTip

            if dbLock( cFacCliP )
               ( cFacCliP )->cNumMtr := space( 15 )
               ( cFacCliP )->( dbUnLock() )
            end if 

         end if

         ( cFacCliP )->( dbSkip() )

      end while

   end if

   ( cFacCliP )->( dbGoTo( nRec ) )
   ( cFacCliP )->( OrdSetFocus( nOrdAnt ) )

RETURN .t.

//---------------------------------------------------------------------------//

function nEstadoRecibo( uFacCliP )

RETURN ( hGetPos( hEstadoRecibo, cEstadoRecibo( uFacCliP ) ) )

//---------------------------------------------------------------------------//

function cEstadoRecibo( uFacCliP )

   local cEstadoRecibo  := ""

   DEFAULT uFacCliP     := D():FacturasClientesCobros( nView )

   if empty( uFacCliP )
      RETURN ( cEstadoRecibo )
   end if 

   do case
      case ( uFacCliP )->lEsperaDoc
         cEstadoRecibo  := "Espera documentación"
      case ( uFacCliP )->lCobrado .and. !( uFacCliP )->lDevuelto 
         cEstadoRecibo  := "Cobrado"
      case ( uFacCliP )->lCobrado .and. ( uFacCliP )->lDevuelto
         cEstadoRecibo  := "Devuelto"
      case !( uFacCliP )->lCobrado .and. ( uFacCliP )->lRemesa .and. !empty( ( uFacCliP )->nNumRem )
         cEstadoRecibo  := "Remesado"
      case !( uFacCliP )->lCobrado 
         cEstadoRecibo  := "Pendiente"
   end case

RETURN ( cEstadoRecibo )

//---------------------------------------------------------------------------//

Function lReciboMatriz( cNumRec, uFacCliP )
   
   DEFAULT uFacCliP     := D():FacturasClientesCobros( nView )
   DEFAULT cNumRec      := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec

   if dbSeekInOrd( cNumRec, "cNumMtr", uFacCliP )
      RETURN .t.
   end if 

RETURN .f.

//---------------------------------------------------------------------------//

Function nEstadoMatriz( uFacCliP )

   local nRec
   local nOrd
   local nEstado     := 1
   local cNum

   DEFAULT uFacCliP  := D():FacturasClientesCobros( nView )

   cNum              := ( uFacCliP )->cSerie + str( ( uFacCliP )->nNumFac ) + ( uFacCliP )->cSufFac + str( ( uFacCliP )->nNumRec ) + ( uFacCliP )->cTipRec
   nRec              := ( uFacCliP )->( recno() )
   nOrd              := ( uFacCliP )->( ordsetfocus( "cNumMtr" ) )

   if ( uFacCliP )->( dbseek( cNum ) )
      nEstado        := 2
   end if 
  
   ( uFacCliP )->( ordsetfocus( nOrd ) )
   ( uFacCliP )->( dbgoto( nRec ) )

   if !empty( ( uFacCliP )->cNumMtr )
      nEstado        := 3
   end if

RETURN nEstado

//---------------------------------------------------------------------------//

Function cEstadoMatriz( uFacCliP )

   local cEstadoMatriz  := ""
   local nEstadoMatriz  := nEstadoMatriz( uFacCliP )

   do case
      case nEstadoMatriz == 2
         cEstadoMatriz  := "Matriz"
      case nEstadoMatriz == 3
         cEstadoMatriz  := "Compensado"
   end case

RETURN ( cEstadoMatriz )

//---------------------------------------------------------------------------//

Function cCuentaEmpresaRecibo( uFacCliP )

   local cCuentaEmpresaRecibo := ""

   do case
   case IsObject( uFacCliP )
      cCuentaEmpresaRecibo    += uFacCliP:cEntEmp
      cCuentaEmpresaRecibo    += uFacCliP:cSucEmp
      cCuentaEmpresaRecibo    += uFacCliP:cDigEmp
      cCuentaEmpresaRecibo    += uFacCliP:cCtaEmp

   case IsChar( uFacCliP )
      cCuentaEmpresaRecibo    += ( uFacCliP )->cEntEmp
      cCuentaEmpresaRecibo    += ( uFacCliP )->cSucEmp
      cCuentaEmpresaRecibo    += ( uFacCliP )->cDigEmp
      cCuentaEmpresaRecibo    += ( uFacCliP )->cCtaEmp

   end case

RETURN ( cCuentaEmpresaRecibo )

//---------------------------------------------------------------------------//

STATIC FUNCTION lUpdateSubCta( aGet, aTmp )

   if !empty( aTmp[ _CCODPGO ] )

      //if empty( aTmp[ _CCTAREC ] )
         aGet[ _CCTAREC ]:cText( RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ), "cCtaCobro" ) )
         aGet[ _CCTAREC ]:Refresh()
      //end if

      //if empty( aTmp[ _CCTAGAS ] )
         aGet[ _CCTAGAS ]:cText( RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ), "cCtaGas" ) )
         aGet[ _CCTAGAS ]:Refresh()
      //end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION lValidCompensado( aTmp )

   local cNumRec  := aTmp[ _CSERIE ] + "/" + allTrim( str( aTmp[ _NNUMFAC ] ) ) + "/" + aTmp[ _CSUFFAC ] + "-" + AllTrim( str( aTmp[ _NNUMREC ] ) )

   if aTmp[ _LCOBRADO ]
      msgStop( "Recibo ya cobrado.", "Recibo: " + cNumRec )
      RETURN .f.
   end if 

   if aTmp[ _LREMESA ]
      msgStop( "Recibo ya remesado.", "Recibo: " + cNumRec )
      RETURN .f.
   end if 

   if !empty( aTmp[ _CNUMMTR ] )
      msgStop( "Recibo ya pertenece a otra matriz.", "Recibo: " + cNumRec )
      RETURN .f.
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION cTipoRecibo( cTipo )

   local cTipoRecibo    := "Factura"

   do case
      case cTipo == "R"
         cTipoRecibo    := "Rectificativa"
      case cTipo == "L"
         cTipoRecibo    := "Libre"
   end case

RETURN ( cTipoRecibo )

//---------------------------------------------------------------------------//

STATIC FUNCTION loadCliente( aGet, aTmp )

   local lValid      := .t.
   local cCodCli     := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli  := ( empty( cOldCodCli ) .or. cOldCodCli != cCodCli )

   if empty( cCodCli )
      RETURN .t.
   elseif At( ".", cCodCli ) != 0
      cCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cCodCli     := Rjust( cCodCli, "0", RetNumCodCliEmp() )
   end if

   if lChgCodCli

      if ( D():Clientes( nView ) )->( dbSeek( cCodCli ) )

         /*
         Asignamos el codigo siempre
         */

         aGet[ _CCODCLI ]:cText( ( D():Clientes( nView ) )->Cod )
         aGet[ _CNOMCLI ]:cText( ( D():Clientes( nView ) )->Titulo )

         aGet[ _CCODPGO ]:cText( ( D():Clientes( nView ) )->CodPago )
         aGet[ _CCODPGO ]:lValid()

         aGet[ _CCODAGE ]:cText( ( D():Clientes( nView ) )->cAgente )
         aGet[ _CCODAGE ]:lValid()

         aGet[ _CCTAREM ]:cText( ( D():Clientes( nView ) )->cCodRem )
         aGet[ _CCTAREM ]:lValid()

         if !empty( ( D():Clientes( nView ) )->CodPago )
            aGet[ _CCTAREC ]:cText( RetFld( ( D():Clientes( nView ) )->CodPago, D():FormasPago( nView ), "cCtaCobro" ) )
            aGet[ _CCTAGAS ]:cText( RetFld( ( D():Clientes( nView ) )->CodPago, D():FormasPago( nView ), "cCtaGas" ) )
         end if

         if lBancoDefecto( ( D():Clientes( nView ) )->Cod, D():ClientesBancos( nView ) )

            aGet[ _CBNCCLI ]:cText( ( D():ClientesBancos( nView ) )->cCodBnc )
            aGet[ _CPAISIBAN ]:cText( ( D():ClientesBancos( nView ) )->cPaisIBAN )
            aGet[ _CCTRLIBAN ]:cText( ( D():ClientesBancos( nView ) )->cCtrlIBAN )
            aGet[ _CENTCLI ]:cText( ( D():ClientesBancos( nView ) )->cEntBnc )
            aGet[ _CSUCCLI ]:cText( ( D():ClientesBancos( nView ) )->cSucBnc )
            aGet[ _CDIGCLI ]:cText( ( D():ClientesBancos( nView ) )->cDigBnc )
            aGet[ _CCTACLI ]:cText( ( D():ClientesBancos( nView ) )->cCtaBnc )

         end if

         cOldCodCli  := ( D():Clientes( nView ) )->Cod

      else

         MsgStop( "Cliente no encontrado" )

         lValid      := .f.

      end if

   end if

RETURN ( lValid )

//---------------------------------------------------------------------------//

STATIC FUNCTION CompensarReciboCliente( oBrw )

   local oDlg
   local oBmp
   local oBrwRec
   local oSayTot
   local cCodCli           := space( 12 )
   local nRec              := ( D():FacturasClientesCobros( nView ) )->( Recno() )
   local nOrdAnt           := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "nNumFac" ) )

   aRecibosRelacionados    := {}
   nTotalRelacionados      := 0
   
   DEFINE DIALOG oDlg ;
      RESOURCE "RECIBOSCOMPENSAR" ;
      TITLE    "Compensación recibos de clientes"

   REDEFINE BITMAP oBmp ;
      ID       500 ;
      RESOURCE "gc_folder_cubes_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET oClienteCompensar VAR cCodCli ;
      ID       310 ;
      IDTEXT   311 ;
      VALID    ( cClient( oClienteCompensar, , oClienteCompensar:oHelpText ) ) ;
      ON HELP  ( BrwClient( oClienteCompensar, oClienteCompensar:oHelpText ) ) ;
      BITMAP   "LUPA" ;
      OF       oDlg   

   REDEFINE BUTTON ;
      ID       100 ;
      OF       oDlg;
      WHEN     ( !empty( cCodCli ) );
      ACTION   ( GetReciboCliente( cCodCli, oBrwRec ) )

   REDEFINE BUTTON ;
      ID       110 ;
      OF       oDlg;
      WHEN     ( !empty( cCodCli ) );
      ACTION   ( DelReciboCliente( oBrwRec ) )

   oBrwRec                 := IXBrowse():New( oDlg )

   oBrwRec:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwRec:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   oBrwRec:nMarqueeStyle   := 6
   oBrwRec:lRecordSelector := .f.
   oBrwRec:lHScroll        := .f.

   oBrwRec:SetArray( aRecibosRelacionados, , , .f. )

   oBrwRec:CreateFromResource( 200 )

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Tipo"
      :bstrData         := {|| if( len( aRecibosRelacionados ) > 0 , cTipoRecibo( Right( aRecibosRelacionados[ oBrwRec:nArrayAt ], 1 ) ), "" ) }
      :nWidth           := 50
   end with

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Numero"
      :bstrData         := {|| if( len( aRecibosRelacionados) > 0, Left( aRecibosRelacionados[ oBrwRec:nArrayAt ], 1 ) + "/" + Alltrim( Substr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 2, 9 ) ) + "-" + Alltrim( Substr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 13, 2 ) ), "" ) }
      :nWidth           := 100
   end with

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Delegación"
      :bstrData         := {|| if( len( aRecibosRelacionados) > 0, Substr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 11, 2 ), "" ) }
      :nWidth           := 40
      :lHide            := .t.
   end with

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Fecha"
      :bstrData         := {|| if( len( aRecibosRelacionados) > 0, RetFld( aRecibosRelacionados[ oBrwRec:nArrayAt ], D():FacturasClientesCobros( nView ), "dPreCob", "nNumFac" ), "" ) }
      :nWidth           := 80
      :nDatastrAlign    := 3
      :nHeadstrAlign    := 3
   end with

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Vencimiento"
      :bstrData         := {|| if( len( aRecibosRelacionados) > 0, RetFld( aRecibosRelacionados[ oBrwRec:nArrayAt ], D():FacturasClientesCobros( nView ), "dFecVto", "nNumFac" ), "" ) }
      :nWidth           := 80
      :nDatastrAlign    := 3
      :nHeadstrAlign    := 3
   end with

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Concepto"
      :bstrData         := {|| if( len( aRecibosRelacionados) > 0, RetFld( aRecibosRelacionados[ oBrwRec:nArrayAt ], D():FacturasClientesCobros( nView ), "cDesCriP", "nNumFac" ), "" ) }
      :nWidth           := 200
   end with

   with object ( oBrwRec:AddCol() )
      :cHeader          := "Total"
      :bstrData         := {|| if( len( aRecibosRelacionados) > 0, Trans( RetFld( aRecibosRelacionados[ oBrwRec:nArrayAt ], D():FacturasClientesCobros( nView ), "nImporte", "nNumFac" ), cPorDiv() ), "" ) }
      :nWidth           := 80
      :nDatastrAlign    := 1
      :nHeadstrAlign    := 1
   end with

   oBrwRec:bLDblClick   := {|| ZoomReciboCliente( Substr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 1, 14 ) ) }

   REDEFINE SAY oSayTot;
      ID       488 ;
      FONT     oFontTotal() ;
      OF       oDlg

   REDEFINE SAY oTotalRelacionados VAR nTotalRelacionados ;
      ID       485 ;
      FONT     oFontTotal() ;
      PICTURE  cPorDiv() ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( if( lPreSaveCompensarReciboCliente(), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F2, {|| GetReciboCliente( cCodCli, oBrwRec ) } )
      oDlg:AddFastKey( VK_F4, {|| DelReciboCliente( oBrwRec ) } )

      oDlg:bStart := {|| oClienteCompensar:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientesCobros( nView ) )->( dbGoto( nRec ) )

   if !empty( oBmp )
      oBmp:End()
   end if

   if !empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION lPreSaveCompensarReciboCliente()

   if empty( oClienteCompensar:VarGet() )
      MsgStop( "Tiene que seleccionar un cliente" )
      oClienteCompensar:SetFocus()
      RETURN .f.
   end if

   if Len( aRecibosRelacionados ) < 1
      MsgStop( "Tiene que seleccionar recibos para crear una compensación" )
      RETURN .f.
   end if

   if !WinAppRec( oWndBrw:oBrw, bEdit, D():FacturasClientesCobros( nView ), , LIBRE_MODE )
      RETURN .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION ZoomReciboCliente( cNumFac )

   local nRec     := ( D():FacturasClientesCobros( nView ) )->( Recno() )
   local nOrdAnt  := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "nNumFac" ) )

   if ( D():FacturasClientesCobros( nView ) )->( dbSeek( cNumFac ) )
      WinZooRec( , bEdit, D():FacturasClientesCobros( nView ) )
   end if

   ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientesCobros( nView ) )->( dbGoTo( nRec ) )

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION aRecibosAgrupados( uFacCliP )

   local nRec
   local nOrd
   local cNum
   local hRecibo

   aRecibosMatriz    := {}

   DEFAULT uFacCliP  := D():FacturasClientesCobros( nView )

   cNum              := ( uFacCliP )->cSerie + str( ( uFacCliP )->nNumFac ) + ( uFacCliP )->cSufFac + str( ( uFacCliP )->nNumRec ) + ( uFacCliP )->cTipRec
   nRec              := ( uFacCliP )->( recno() )
   nOrd              := ( uFacCliP )->( ordsetfocus( "cNumMtr" ) )

   if ( uFacCliP )->( dbseek( cNum ) )
      
      while ( uFacCliP )->cNumMtr == cNum .and. !( uFacCliP )->( Eof() )

         hRecibo     := {  "Número"                => ( uFacCliP )->cSerie + "/" + AllTrim( str( ( uFacCliP )->nNumFac ) ) + "/" + AllTrim( ( uFacCliP )->cSufFac ) + "-" + AllTrim( str( ( uFacCliP )->nNumRec ) ),;
                           "Estado"                => ( uFacCliP )->lCobrado,;
                           "Fecha"                 => ( ( uFacCliP )->dEntrada ),;
                           "Vencimiento"           => ( ( uFacCliP )->dFecVto ),;
                           "Pago"                  => ( uFacCliP )->cCodPgo + "-" + RetFld( ( uFacCliP )->cCodPgo, D():FormasPago( nView ) ),;
                           "Importe"               => Trans( ( uFacCliP )->nImporte, cPorDiv() ) }

         aAdd( aRecibosMatriz, hRecibo )

         ( uFacCliP )->( dbSkip() )

      end while

   end if 
  
   ( uFacCliP )->( ordsetfocus( nOrd ) )
   ( uFacCliP )->( dbgoto( nRec ) )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION deleteRecibosFacturasClientes( cNumeroFactura, dbfFacCliP )

   while ( dbfFacCliP )->( dbSeek( cNumeroFactura ) ) .and. ( dbfFacCliP )->( !eof() )

      if dbLock( dbfFacCliP )
         ( dbfFacCliP )->( dbDelete() )
         ( dbfFacCliP )->( dbUnLock() )
      end if

      ( dbfFacCliP )->( dbSkip() )

   end while

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION cFormatoRecibosClientes( cSerie )

   local cFormato

   DEFAULT cSerie    := ( D():FacturasClientesCobros( nView ) )->cSerie

   cFormato          := cFormatoDocumento( cSerie, "nRecCli", D():Contadores( nView ) )

   if empty( cFormato )
      cFormato       := cFirstDoc( "RF", D():Documentos( nView ) )
   end if

RETURN ( cFormato )

//---------------------------------------------------------------------------//

STATIC FUNCTION actualizarEstadoFactura( cTipoRecibo, cNumeroFactura )

   if !( lActualizarEstadoFactura )
      RETURN ( .f. )
   end if 

   do case 
      case empty( cTipoRecibo )

         if ( D():FacturasClientes( nView ) )->( dbSeek( cNumeroFactura ) )
            ChkLqdFacCli( nil, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():TiposIva( nView ), D():Divisas( nView ), .f. )
         end if

      case cTipoRecibo == "R"

         if ( D():FacturasRectificativas( nView ) )->( dbSeek( cNumeroFactura ) )
            ChkLqdFacRec( nil, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ), D():FacturasClientesCobros( nView ), D():TiposIva( nView ), D():Divisas( nView ) )
         end if

   end case

RETURN nil

//---------------------------------------------------------------------------//

Function LiquidaRecibo( nImporte, dbfRecCli, cFacCliT )

   local nRec
   local nImp
   local aTbl
   local nCon

   if ( ( dbfRecCli )->nImporte != nImporte )
      
      /*
      Me guardo en un array el registro-------------------------------------
      */

      aTbl                       := dbScatter( dbfRecCli )

      /*
      El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
      */

      nImp                       := ( ( dbfRecCli )->nImporte - nImporte )

      /*
      Cambiamos el recibo de valor y lo liquidamos--------------------------
      */

      if dbLock( dbfRecCli )
         ( dbfRecCli )->nImporte    := nImporte
         ( dbfRecCli )->lCobrado    := .t.
         ( dbfRecCli )->dEntrada    := GetSysDate()
         ( dbfRecCli )->( dbUnLock() )
      end if
            
      /*
      Obtenemos el número de registro---------------------------------------
      */

      nRec                       := ( dbfRecCli )->( Recno() )

      /*
      Obtnenemos el nuevo numero del contador----------------------------------
      */

      nCon                       := nNewReciboCliente( aTbl[ _CSERIE ] + str( aTbl[ _NNUMFAC ] ) + aTbl[ _CSUFFAC ], aTbl[ _CTIPREC ], dbfRecCli )

      /*
      Añadimos el nuevo recibo-------------------------------------------------
      */

      ( dbfRecCli )->( dbAppend() )

      ( dbfRecCli )->cTurRec    := aTbl[ _CTURREC ]
      ( dbfRecCli )->cTipRec    := aTbl[ _CTIPREC ]
      ( dbfRecCli )->cSerie     := aTbl[ _CSERIE  ]
      ( dbfRecCli )->nNumFac    := aTbl[ _NNUMFAC ]
      ( dbfRecCli )->cSufFac    := aTbl[ _CSUFFAC ]
      ( dbfRecCli )->nNumRec    := nCon
      ( dbfRecCli )->cCodCaj    := aTbl[ _CCODCAJ ]
      ( dbfRecCli )->cCodCli    := aTbl[ _CCODCLI ]
      ( dbfRecCli )->cNomCli    := aTbl[ _CNOMCLI ]
      ( dbfRecCli )->cCodAge    := aTbl[ _CCODAGE ] 
      ( dbfRecCli )->dEntrada   := Ctod( "" )
      ( dbfRecCli )->nImporte   := nImp
      ( dbfRecCli )->nImpCob    := nImp
      ( dbfRecCli )->cDescrip   := "Recibo nº" + AllTrim( str( nCon ) ) + " de factura " + if( !empty( aTbl[ _CTIPREC ] ), "rectificativa ", "" ) + aTbl[ _CSERIE ] + '/' + AllTrim( str( aTbl[ _NNUMFAC ] ) ) + '/' + aTbl[ _CSUFFAC ]
      ( dbfRecCli )->dPreCob    := dFecFacCli( aTbl[ _CSERIE ] + str( aTbl[ _NNUMFAC ] ) + aTbl[ _CSUFFAC ], cFacCliT )
      ( dbfRecCli )->cPgdoPor   := ""
      ( dbfRecCli )->lCobrado   := .f.
      ( dbfRecCli )->cDivPgo    := aTbl[ _CDIVPGO ]
      ( dbfRecCli )->nVdvPgo    := aTbl[ _NVDVPGO ]
      ( dbfRecCli )->cCodPgo    := aTbl[ _CCODPGO ]
      ( dbfRecCli )->lConPgo    := .f.
      ( dbfRecCli )->lSndDoc    := .t.
      ( dbfRecCli )->dFecCre    := GetSysDate()
      ( dbfRecCli )->cHorCre    := Substr( Time(), 1, 5 )

      ( dbfRecCli )->( dbUnLock() )

      ( dbfRecCli )->( dbGoTo( nRec ) )

   end if

RETURN nil

//---------------------------------------------------------------------------//

Function insertVencimientoContaplus( cFacCliP, cClient )

   local cArea
   local cEmpresaContaplus    

   // Si el recibo esta pagado nos vamos--------------------------------------

   if ( ( cFacCliP )->lCobrado ) 
      RETURN ( .f. )
   end if 

   // si no estamos usando una version de contaplus----------------------------

   if lAplicacionA3()
      RETURN ( .f. )
   end if 

   // si esta vacia la ruta de contaplus---------------------------------------

   if empty( cRutCnt() )
      RETURN ( .f. )
   end if 

   // la serie del recibo tiene empresa contable asociada----------------------

   cEmpresaContaplus    := cEmpCnt( ( cFacCliP )->cSerie )
   if empty(cEmpresaContaplus)
      RETURN ( .f. )
   end if 

   // Apertura de base de dtos de vencimiento en contaplis

   if !( OpenVencimientos( cRutCnt(), cEmpresaContaplus, @cArea ) )
      RETURN ( .f. )
   end if 

   // Añadir campos a base de datos de contaplus

   ( cArea )->( dbappend( .t. ) )
   ( cArea )->fecha     := ( cFacCliP )->dPreCob
   ( cArea )->cod       := cCliCta( ( cFacCliP )->cCodCli, cClient )
   ( cArea )->acpa      := 'A'
   ( cArea )->contra    := ( cFacCliP )->cCtaRec
   ( cArea )->concepto  := 'Cobro Fra. ' + ( cFacCliP )->cSerie + '/' + alltrim( str( ( cFacCliP )->nNumFac ) )
   ( cArea )->estado    := .t.
   ( cArea )->documento := ( cFacCliP )->cSerie + '/' + alltrim( str( ( cFacCliP )->nNumFac ) )
   ( cArea )->monedaUso := '2'
   ( cArea )->fechaPag  := ( cFacCliP )->dFecVto
   ( cArea )->euro      := ( cFacCliP )->nImporte
   ( cArea )->( dbunlock() )

   // Cerrar base de datos de contaplus

   Close( cArea )

RETURN nil

//---------------------------------------------------------------------------//
