#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Print.ch"
#include "Report.ch"
#include "FastRepH.ch"
#include "Factu.ch" 

#define _MENUITEM_               "01059"

/*
Defines para las lineas de Pago
*/

#define _CSERIE                   1      //   C      1     0
#define _NNUMFAC                  2      //   N      9     0
#define _CSUFFAC                  3      //   C      2     0
#define _NNUMREC                  4      //   N      2     0
#define _CTIPREC                  5      //   N      2     0
#define _CCODPGO                  6      //   C      2     0
#define _CCODCAJ                  7      //   C      6     0
#define _CTURREC                  8      //   C     12     0
#define _CCODCLI                  9      //   D      8     0
#define _CNOMCLI                 10      //   D      8     0
#define _DENTRADA                11      //   N     10     0
#define _NIMPORTE                12      //   C    100     0
#define _CDESCRIP                13      //   C      8     0
#define _DPRECOB                 14      //   D     50     0
#define _CPGDOPOR                15      //   D     50     0
#define _CDOCPGO                 16      //   L      1     0
#define _LCOBRADO                17      //   C      3     0
#define _CDIVPGO                 18      //
#define _NVDVPGO                 19      //   L      1     0
#define _LCONPGO                 20      //   C     12     0
#define _CCTAREC                 21      //   N     16     6
#define _NIMPEUR                 22      //   L      1     0
#define _LIMPEUR                 23      //   N      9     0 Numero de la remesas
#define _NNUMREM                 24      //   C      2     0 Sufijo de remesas
#define _CSUFREM                 25      //   C      3     0 Cuenta de remesa
#define _CCTAREM                 26      //   L      1     0 Marca para impreso
#define _LRECIMP                 27      //   L      1     0 Recibo descontado
#define _LRECDTO                 28      //   D      8     0 Fecha del descuento
#define _DFECDTO                 29      //   D      8     0 Fecha de vencimiento
#define _DFECVTO                 30      //   C      3     0 Codigo del agente
#define _CCODAGE                 31      //   C      3     0 Numero de cobro
#define _NNUMCOB                 32      //   C      2     0 Sufijo de cobro
#define _CSUFCOB                 33      //   N     16     6 Importe de cobro
#define _NIMPCOB                 34      //   N     16     6 Importe de gastos
#define _NIMPGAS                 35      //   C     12     0 Subcuenta de gastos
#define _CCTAGAS                 36
#define _LESPERADOC              37
#define _LCLOPGO                 38
#define _DFECIMP                 39      //   D      8     0
#define _CHORIMP                 40      //   C      5     0
#define _LNOTARQUEO              41
#define _CCODBNC                 42
#define _DFECCRE                 43      //   D      8     0
#define _CHORCRE                 44      //   C      5     0
#define _CCODUSR                 45      //   C      3     0
#define _LDEVUELTO               46      //   L      1     0
#define _DFECDEV                 47      //   D      8     0
#define _CMOTDEV                 48      //   C    250     0
#define _CRECDEV                 49      //   C     14     0
#define _LSNDDOC                 50      //   L      1     0
#define _CBNCEMP                 51
#define _CBNCCLI                 52
#define _CEPAISIBAN              53
#define _CECTRLIBAN              54
#define _CENTEMP                 55
#define _CSUCEMP                 56
#define _CDIGEMP                 57
#define _CCTAEMP                 58
#define _CPAISIBAN               59
#define _CCTRLIBAN               60
#define _CENTCLI                 61
#define _CSUCCLI                 62
#define _CDIGCLI                 63
#define _CCTACLI                 64
#define _LREMESA                 65
#define _CNUMMTR                 66
#define _LPASADO                 67
#define _CCENTROCOSTE            68

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

static aRecibosRelacionados   := {}

static oMenu

static lExternal              := .f.
static lOpenFiles             := .f.
static cFiltroUsuario         := ""

static lOldDevuelto           := .f.

static bEdit                  := { |aTmp, aGet, dbf, oBrw, lRectificativa, bValid, nMode, aTmpFac| EdtCob( aTmp, aGet, dbf, oBrw, lRectificativa, bValid, nMode, aTmpFac ) }

static hEstadoRecibo          := {  "Pendiente"             => "bCancel",;
                                    "Cobrado"               => "bSel",;
                                    "Devuelto"              => "bAlert",;
                                    "Remesado"              => "folder_ok_16",;
                                    "Espera documentación"  => "bClock" }

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Los ficheros de recibos de clientes ya estan abiertos.' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
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

      oCtaRem              := TCtaRem():Create( cPatCli() )
      oCtaRem:OpenFiles()

      oCentroCoste            := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de recibos de clientes" + CRLF + ErrorMessage( oError ) )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if oCtaRem != nil
      oCtaRem:CloseFiles()
      oCtaRem:End()
   end if

   if !Empty( oCentroCoste )
      oCentroCoste:CloseFiles()
   end if

   oWndBrw     := nil

   lOpenFiles  := .f.

Return .t.

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

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  aNumRec     := Array( 1 )

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      Return .f.
   end if

   /*
   Anotamos el movimiento para el navegador------------------------------------
   */

   AddMnuNext( "Recibos de facturas de clientes", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Recibos de facturas de clientes" ;
      MRU      "Briefcase_user1_16" ;
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():FacturasClientesCobros( nView ) );
      PROMPTS  "Número",;
               "Código",;
               "Nombre",;
               "Expedición",;
               "Vencimiento",;
               "Cobro",;
               "Importe" ;
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
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 6
         :bStrData         := {|| cEstadoRecibo( D():FacturasClientesCobros( nView ) ) }
         :bBmpData         := {|| nEstadoRecibo( D():FacturasClientesCobros( nView ) ) }
         :nWidth           := 20
         heval( hEstadoRecibo, {|k,v,i| :AddResource( v ) } )
         :AddResource( "ChgPre16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado matriz"
         :nHeadBmpNo       := 2
         :bBmpData         := {|| nEstadoMatriz() }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Nil16" )
         :AddResource( "All_Components_16" )
         :AddResource( "Component_Blue_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->lConPgo }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "BmpConta16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( D():FacturasClientesCobros( nView ) )->lRecImp }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| if( !Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec ), "Rectificativa", "" ) }
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
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
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
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :bEditValue       := {|| nTotCobCli( D():FacturasClientesCobros( nView ), D():Divisas( nView ), if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Gasto"
         :bEditValue       := {|| nTotGasCli( D():FacturasClientesCobros( nView ), D():Divisas( nView ), if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
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
         :bEditValue       := {|| Alltrim( Str( ( D():FacturasClientesCobros( nView ) )->nNumRem ) ) + "/" + ( D():FacturasClientesCobros( nView ) )->cSufRem }
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
         :bEditValue       := {|| if( !Empty( ( D():FacturasClientesCobros( nView ) )->cNumMtr ), Trans( ( D():FacturasClientesCobros( nView ) )->cNumMtr, "@R #/999999999/##-9#" ), "" ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B"

   oWndBrw:AddSeaBar()

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

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinEdtRec( oWndBrw:oBrw, bEdit, D():FacturasClientesCobros( nView ), , .t. ) );
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

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
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

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oMail, IS_MAIL )

   DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBrw GROUP ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Cobrar" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "Document_Chart_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TFastVentasRecibos():New():Play() );
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

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEur := !lEur, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

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

      DEFINE BTNSHELL RESOURCE "User1_" OF oWndBrw ;
         ACTION   ( EdtCli( ( D():FacturasClientesCobros( nView ) )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Info" OF oWndBrw ;
         ACTION   ( InfCliente( ( D():FacturasClientesCobros( nView ) )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Document_User1_" OF oWndBrw ;
         ACTION   ( EdtFacCli( ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "End" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmrecCli() )
      oWndBrw:oActiveFilter:SetFilterType( REC_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   if ValType( aNumRec ) == "A" .and. !Empty( aNumRec[ 1 ] )

      nOrdAnt  := (D():FacturasClientesCobros( nView ))->( OrdSetFocus( "nNumFac" ) )
      lFound   := ( D():FacturasClientesCobros( nView ) )->( dbSeek( aNumRec[ 1 ] ) )

      ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrdAnt ) )

      if lFound
         oWndBrw:Refresh()
         oWndBrw:RecEdit()
      end if

      aNumRec  := Array( 1 )

   end if

Return .t.

//--------------------------------------------------------------------------//

FUNCTION EdtCob( aTmp, aGet, cFacCliP, oBrw, lRectificativa, lCompensar, nMode, aNumRec )

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
   local lMode

   DEFAULT lCompensar      := .f.

   if empty( cFacCliP )
      cFacCliP             := D():FacturasClientesCobros( nView )
   end if

   cGetAge                 := cNbrAgent( ( cFacCliP )->cCodAge, D():Agentes( nView ) )
   cGetCaj                 := RetFld( ( cFacCliP )->cCodCaj, D():Cajas( nView ), "cNomCaj" )
   cGetPgo                 := RetFld( ( cFacCliP )->cCodPgo, D():FormasPago( nView ), "cDesPago" )
   cPorDiv                 := cPorDiv( ( cFacCliP )->cDivPgo, D():Divisas( nView ) )

   if !IsLogic( lRectificativa )
      lRectificativa       := .f.
   end if

   if !IsLogic( lCompensar )
      lCompensar       := .f.
   end if

   if lCompensar .and. !lValidCompensado( aTmp )
      Return .f.
   end

   if nMode != APPD_MODE

      do case
         case nEstadoMatriz() == 2
            lCompensar  := .t.

         case nEstadoMatriz() == 3

            MsgStop( "Recibo perteneciente a la matriz " + trans( aTmp[ _CNUMMTR ], "@R #/999999999/##-9#" ) )
            Return .f.

      end case

   end if

   do case
      case nMode == APPD_MODE

         if lRectificativa
            aTmp[ _CTIPREC ]  := "R"
         end if

      case nMode == EDIT_MODE

         if aTmp[ _LCONPGO ] .and. !ApoloMsgNoYes( 'La modificación de este recibo puede provocar descuadres contables.' + CRLF + '¿Desea continuar?', 'Recibo ya contabilizado' )
            return .f.
         end if

         if aTmp[ _LCLOPGO ] .and. !oUser():lAdministrador()
            msgStop( "Solo pueden modificar los recibos cerrados los administradores." )
            return .f.
         end if

   end case

   if Empty( aTmp[ _CCODCAJ ] )
      aTmp[ _CCODCAJ ]     := oUser():cCaja()
   end if

   //getInitRecibosRelacionados()

   aRecibosRelacionados    := {}

   if lCompensar
      aAdd( aRecibosRelacionados, aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] + Str( aTmp[ _NNUMREC ] ) + aTmp[ _CTIPREC ] )
   end if

   lOldDevuelto            := aTmp[ _LDEVUELTO ]

   lPgdOld                 := ( cFacCliP )->lCobrado .or. ( cFacCliP )->lRecDto
   nImpOld                 := ( cFacCliP )->nImporte

   lMode                   := ( !lCompensar .and. nMode != ZOOM_MODE )

   if lCompensar
      
      DEFINE DIALOG  oDlg ;
         RESOURCE "RecibosExtend" ;
         TITLE    LblTitle( nMode ) + "recibos de clientes"

   else

      DEFINE DIALOG  oDlg ;
         RESOURCE "Recibos" ;
         TITLE    LblTitle( nMode ) + "recibos de clientes"

   end if

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

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Money_Alpha_48" ;
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
         WHEN     lMode ;
         ON HELP  aGet[ _DFECVTO ]:cText( Calendario( aTmp[ _DFECVTO ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LNOTARQUEO ] VAR aTmp[ _LNOTARQUEO ];
         ID       200 ;
			WHEN 		lMode ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CTURREC ] VAR aTmp[ _CTURREC ] ;
         ID       335 ;
         PICTURE  "999999" ;
         WHEN     ( lMode .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       120 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ];
         ID       121 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       130 ;
			WHEN 		lMode ;
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
			WHEN 		( lMode ) ;
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
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE GET aGet[ _CPGDOPOR ] VAR aTmp[ _CPGDOPOR ] ;
         ID       150 ;
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet [ _CDOCPGO ] VAR aTmp[ _CDOCPGO ] ;
         ID       155 ;
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDIVPGO ] VAR aTmp[ _CDIVPGO ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], nil, nil, @cPorDiv, nil, nil, nil, nil, D():Divisas( nView ) ) );
         PICTURE  "@!";
         ID       170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], D():Divisas( nView ) ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       171;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NIMPORTE ] VAR aTmp[ _NIMPORTE ] ;
         ID       180 ;
         WHEN     ( lMode ) ;
         VALID    ( aGet[ _NIMPCOB ]:cText( aTmp[ _NIMPORTE ] ), .t. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NIMPCOB ] VAR aTmp[ _NIMPCOB ] ;
         ID       190 ;
         WHEN     ( lMode ) ;
         VALID    ( ValCobro( aGet, aTmp ) ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NIMPGAS ] VAR aTmp[ _NIMPGAS ] ;
         ID       260 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LCOBRADO ] VAR aTmp[ _LCOBRADO ];
         ID       220 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
			WHEN 		( lMode ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DENTRADA ] VAR aTmp[ _DENTRADA ] ;
         ID       230 ;
         SPINNER ;
         WHEN     ( lMode ) ;
         ON HELP  aGet[ _DENTRADA ]:cText( Calendario( aTmp[ _DENTRADA ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      /*
      Cajas____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( lMode ) ;
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
         RESOURCE "office_building_48_alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CBNCEMP ] VAR aTmp[ _CBNCEMP ];
         ID       100 ;
         WHEN     ( lMode ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ _CBNCEMP], aGet[ _CEPAISIBAN ], aGet[ _CECTRLIBAN ], aGet[ _CENTEMP], aGet[ _CSUCEMP], aGet[ _CDIGEMP], aGet[ _CCTAEMP] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CEPAISIBAN ] VAR aTmp[ _CEPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       270 ;
         WHEN     ( lMode ) ;
         VALID    ( lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CECTRLIBAN ] VAR aTmp[ _CECTRLIBAN ] ;
         ID       280 ;
         PICTURE  "99" ;
         WHEN     ( lMode ) ;
         VALID    ( lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTEMP] VAR aTmp[ _CENTEMP];
         ID       110 ;
         PICTURE  "9999" ;
         WHEN     ( lMode ) ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP], aTmp[ _CSUCEMP], aTmp[ _CDIGEMP], aTmp[ _CCTAEMP], aGet[ _CDIGEMP] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCEMP] VAR aTmp[ _CSUCEMP];
         ID       120 ;
         WHEN     ( lMode ) ;
         PICTURE  "9999" ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP], aTmp[ _CSUCEMP], aTmp[ _CDIGEMP], aTmp[ _CCTAEMP], aGet[ _CDIGEMP] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGEMP] VAR aTmp[ _CDIGEMP];
         ID       130 ;
         PICTURE  "99" ;
         WHEN     ( lMode ) ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAEMP ] VAR aTmp[ _CCTAEMP ];
         ID       140 ;
         PICTURE  "9999999999" ;
         WHEN     ( lMode ) ;
         VALID    (  lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() )  ;
         OF       oFld:aDialogs[2]

      /*
       Banco del cliente--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBNCCLI] VAR aTmp[ _CBNCCLI];
         ID       200 ;
         WHEN     ( lMode ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ _CBNCCLI], aGet[ _CPAISIBAN], aGet[ _CCTRLIBAN], aGet[ _CENTCLI], aGet[ _CSUCCLI], aGet[ _CDIGCLI], aGet[ _CCTACLI], aTmp[ _CCODCLI] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CPAISIBAN] VAR aTmp[ _CPAISIBAN] ;
         PICTURE  "@!" ;
         ID       250 ;
         WHEN     ( lMode ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN], aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CCTRLIBAN] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTRLIBAN] VAR aTmp[ _CCTRLIBAN] ;
         ID       260 ;
         PICTURE  "99" ;
         WHEN     ( lMode ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN], aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CCTRLIBAN] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTCLI] VAR aTmp[ _CENTCLI];
         ID       210 ;
         PICTURE  "9999" ;
         WHEN     ( lMode ) ;
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCCLI] VAR aTmp[ _CSUCCLI];
         ID       220 ;
         PICTURE  "9999" ;
         WHEN     ( lMode ) ;
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGCLI] VAR aTmp[ _CDIGCLI];
         ID       230 ;
         WHEN     ( lMode ) ;
         PICTURE  "99";
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTACLI] VAR aTmp[ _CCTACLI];
         ID       240 ;
         PICTURE  "9999999999" ;
         WHEN     ( lMode ) ;
         VALID    (  lCalcDC( aTmp[ _CENTCLI], aTmp[ _CSUCCLI], aTmp[ _CDIGCLI], aTmp[ _CCTACLI], aGet[ _CDIGCLI] ),;
                     aGet[ _CPAISIBAN]:lValid() ) ;
         OF       oFld:aDialogs[2]

      /*
      Recibo remesado----------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ _LREMESA ] VAR aTmp[ _LREMESA ] ;
         ID       300 ;
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NNUMREM ] VAR aTmp[ _NNUMREM ];
         ID       310 ;
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUFREM ] VAR aTmp[ _CSUFREM ];
         ID       320 ;
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAREM ] VAR aTmp[ _CCTAREM ] ;
         ID       290 ;
         WHEN     ( lMode ) ;
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
         RESOURCE "money2_delete_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE CHECKBOX aGet[ _LDEVUELTO ] VAR aTmp[ _LDEVUELTO ];
         ID       100 ;
         WHEN     ( aTmp[ _LCOBRADO] .and. lMode ) ;
         ON CHANGE( lChangeDevolucion( aGet, aTmp, .f. ) ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _DFECDEV ] VAR aTmp[ _DFECDEV ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( aTmp[ _LCOBRADO] .and. lMode ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CMOTDEV ] VAR aTmp[ _CMOTDEV ] ;
         ID       120 ;
         WHEN     ( aTmp[ _LCOBRADO ] .and. lMode ) ;
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
         RESOURCE "Folder2_red_Alpha_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[ _LCONPGO ] VAR aTmp[ _LCONPGO ];
         ID       230 ;
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CCTAREC ] VAR aTmp[ _CCTAREC ] ;
         ID       240 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. lMode ) ;
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
         WHEN     ( nLenCuentaContaplus() != 0 .AND. lMode ) ;
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
         WHEN     ( lMode .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       161 ;
         WHEN     ( lMode .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       162 ;
         WHEN     ( lMode .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[ _LESPERADOC ] VAR aTmp[ _LESPERADOC ];
         ID       165 ;
			WHEN 		( lMode ) ;
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
         WHEN     ( lMode ) ;
         OF       oFld:aDialogs[ 4 ]

      /*
      Agrupados----------------------------------------------------------------
      */

      if lCompensar

         REDEFINE BUTTON ;
            ID       100 ;
            OF       oDlg;
            WHEN     ( !aTmp[ _LCOBRADO ] .and. nMode != ZOOM_MODE ) ;
            ACTION   ( GetReciboCliente( aTmp, oBrwRec ) )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       oDlg;
            WHEN     ( !aTmp[ _LCOBRADO ] .and. nMode != ZOOM_MODE ) ;
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
            :cHeader             := "Tipo"
            :bStrData            := {|| if( len( aRecibosRelacionados ) > 0 .and. Right( aRecibosRelacionados[ oBrwRec:nArrayAt ], 1 ) == "R", "Rectificativa", "" ) }
            :nWidth              := 50
         end with

         with object ( oBrwRec:AddCol() )
            :cHeader          := "Numero"
            :bStrData         := {|| if( len( aRecibosRelacionados) > 0, Left( aRecibosRelacionados[ oBrwRec:nArrayAt ], 1 ) + "/" + Alltrim( SubStr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 2, 9 ) ) + "-" + Alltrim( SubStr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 13, 2 ) ), "" ) }
            :nWidth           := 100
         end with

         with object ( oBrwRec:AddCol() )
            :cHeader          := "Delegación"
            :bStrData         := {|| if( len( aRecibosRelacionados) > 0, SubStr( aRecibosRelacionados[ oBrwRec:nArrayAt ], 11, 2 ), "" ) }
            :nWidth           := 40
            :lHide            := .t.
         end with

         with object ( oBrwRec:AddCol() )
            :cHeader          := "Fecha"
            :bStrData         := {|| if( len( aRecibosRelacionados) > 0, RetFld( aRecibosRelacionados[ oBrwRec:nArrayAt ], cFacCliP, "dPreCob", "nNumFac" ), "" ) }
            :nWidth           := 80
            :nDataStrAlign    := 3
            :nHeadStrAlign    := 3
         end with

         with object ( oBrwRec:AddCol() )
            :cHeader          := "Vencimiento"
            :bStrData         := {|| if( len( aRecibosRelacionados) > 0, RetFld( aRecibosRelacionados[ oBrwRec:nArrayAt ], cFacCliP, "dFecVto", "nNumFac" ), "" ) }
            :nWidth           := 80
            :nDataStrAlign    := 3
            :nHeadStrAlign    := 3
         end with

         with object ( oBrwRec:AddCol() )
            :cHeader          := "Total"
            :bStrData         := {|| if( len( aRecibosRelacionados) > 0, Trans( nTotRecibo( aRecibosRelacionados[ oBrwRec:nArrayAt ], cFacCliP, D():Divisas( nView ) ), cPorDiv() ), "" ) }
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

      end if

      /*
      Botones__________________________________________________________________
		*/

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, cFacCliP, oBrw, oDlg, nMode, lCompensar ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( KillTrans( oDlg ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, cFacCliP, oBrw, oDlg, nMode, lCompensar ) } )
      end if

      oDlg:bStart := {|| StartEdtRec( aTmp, aGet, oBrwRec, lCompensar ) }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( EdtRecMenu( aTmp, oDlg ) )

   EndEdtRecMenu()

   if !Empty( oBmpDiv )
      oBmpDiv:End()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpDevolucion )
      oBmpDevolucion:End()
   end if

   if !Empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

   if !Empty( oBmpBancos )
      oBmpBancos:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartEdtRec( aTmp, aGet, oBrwRec, lCompensar )

   cursorWait()

   aGet[ _CDIVPGO       ]:lValid()
   aGet[ _CCTAREC       ]:lValid()
   aGet[ _CCTAGAS       ]:lValid()
   aGet[ _CCTAREM       ]:lValid()
   aGet[ _CCENTROCOSTE  ]:lValid()
   aGet[ _DPRECOB       ]:SetFocus()

   cargarRecibosAsociados( oBrwRec )

   if !lCompensar
      lChangeDevolucion( aGet, aTmp, .t. )
   end if

   cursorWE()

Return .t.

//---------------------------------------------------------------------------//
/*
Cargamos los recibos asociados----------------------------------------------
*/

Static Function cargarRecibosAsociados( oBrwRec )

   local cNum        := ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec
   local nRec        := ( D():FacturasClientesCobros( nView ) )->( recno() )
   local nOrd        := ( D():FacturasClientesCobros( nView ) )->( ordsetfocus( "cNumMtr" ) )

   if ( D():FacturasClientesCobros( nView ) )->( dbseek( cNum ) )
      while ( D():FacturasClientesCobros( nView ) )->cNumMtr == cNum .and. !( D():FacturasClientesCobros( nView ) )->( eof() )
         aadd( aRecibosRelacionados, ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec )
         ( D():FacturasClientesCobros( nView ) )->( dbskip() )
      end while
   end if 
  
   ( D():FacturasClientesCobros( nView ) )->( ordsetfocus( nOrd ) )
   ( D():FacturasClientesCobros( nView ) )->( dbgoto( nRec ) )

   if !Empty( oBrwRec )
      oBrwRec:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function KillTrans( oDlg )

   oDlg:End()

Return .t.

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

Static Function GetReciboCliente( aTmp, oBrwRec )

   local lResult  := .t.
   local cNumRec  := ""
   local aRecibosSeleccionados

   aRecibosSeleccionados      := browseRecCli( aTmp, D():FacturasClientesCobros( nView ), D():Divisas( nView ) )

   if isArray( aRecibosSeleccionados ) .and. Len( aRecibosSeleccionados ) > 0

      for each cNumRec in aRecibosSeleccionados

         if lResult .and. ( cNumRec == aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] + Str( aTmp[ _NNUMREC ] ) + aTmp[ _CTIPREC ] )
            msgStop( "No se puede agrupar un recibo con el mismo.", "Recibo: " + cNumRec )     
            lResult := .f.
         end if

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

         if lResult .and. RetFld( cNumRec, D():FacturasClientesCobros( nView ), "cCodCli", "nNumFac" ) != aTmp[ _CCODCLI ]
            msgStop( "Recibo pertenece a otro cliente.", "Recibo: " + cNumRec )
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

Return nil

//-------------------------------------------------------------------------//

Static Function DelReciboCliente( oBrwRec )
   
   aDel( aRecibosRelacionados, oBrwRec:nArrayAt, .t. )

   if !Empty( oBrwRec )
      oBrwRec:Refresh()
   end if

Return nil

//-------------------------------------------------------------------------//

/*
Contabiliza los recibos
*/

Static Function dlgContabilizaReciboCliente( oBrw, cTitle, cOption, lChgState )

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
      ID       90, 91, 92 ;
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
      WHEN     ( nRad == 2 );
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "999999999" ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "999999999" ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "##" ;
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "##" ;
		OF 		oDlg

   REDEFINE GET nNumIni ;
      ID       160 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "99" ;
		OF 		oDlg

   REDEFINE GET nNumFin ;
      ID       170 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "99" ;
		OF 		oDlg

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
      ACTION   ( initContabilizaReciboCliente( cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin ), nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| initContabilizaReciboCliente( cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin ), nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf ) } )

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

Static Function startContabilizaReciboCliente( oSerIni, oSimula, cOption )

   oSerIni:SetFocus()

   setWindowText( oSimula:hWnd, cOption )

   oSimula:Refresh()

RETURN NIL

//------------------------------------------------------------------------//

Static Function TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION initContabilizaReciboCliente( cDocIni, cDocFin, nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf )

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
         
            makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, aSimula )

            oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( ordkeyno() ) )
         
         next

      case ( nRad == 2 )

         ( D():FacturasClientesCobros( nView ) )->( dbGoTop() )
         while ( lWhile .and. !( D():FacturasClientesCobros( nView ) )->( eof() ) )

            makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, aSimula )

            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

            oMtrInf:Set( ( D():FacturasClientesCobros( nView ) )->( ordkeyno() ) )

         end do

      case ( nRad == 3 )

         ( D():FacturasClientesCobros( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile .and. (  ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) >= cDocIni .and. ;
                                 ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) <= cDocFin .and. ;
                                 !( D():FacturasClientesCobros( nView ) )->( eof() ) ) )

            makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, aSimula )

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
      WndCenter( oDlg:hWnd ) // Move( aPos[ 1 ], aPos[ 2 ] + 200 )
   end if

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function makeContabilizaReciboCliente( cTipo, oTree, lSimula, lChgState, aSimula )

   local lReturn     := .f.

   do case
      case ( cTipo == "Facturas" .or. cTipo == "Todas" ) .and. Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )

         if lChgState
            lReturn  := ChgState( lSimula )
         else
            lReturn  := ContabilizaReciboCliente( nil, oTree, lSimula, aSimula, D():FacturasClientes( nView ), D():FacturasClientesCobros( nView ), D():FormasPago( nView ), D():Clientes( nView ), D():Divisas( nView ), .f. )
         end if

      case ( cTipo == "Rectificativas" .or. cTipo == "Todas" ) .and. !Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )

         if lChgState
            lReturn  := ChgState( lSimula )
         else
            lReturn  := ContabilizaReciboCliente( nil, oTree, lSimula, aSimula, D():FacturasRectificativas( nView ), D():FacturasClientesCobros( nView ), D():FormasPago( nView ), D():Clientes( nView ), D():Divisas( nView ), .f. )
         end if

   end case

Return ( nil )

//---------------------------------------------------------------------------//

Function nTotRecCli( uFacCliP, cDbfDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec

   DEFAULT uFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )
   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if IsObject( uFacCliP )
      cDivPgo        := uFacCliP:cDivPgo
      nTotRec        := uFacCliP:nImporte
   else
      cDivPgo        := ( uFacCliP )->cDivPgo
      nTotRec        := ( uFacCliP )->nImporte
   end if

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   nTotRec           := Round( nTotRec, nRouDiv )

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet )
   end if

RETURN ( if( lPic, Trans( nTotRec, cPorDiv ), nTotRec ) )

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

Return ( cClientCuenta( ( cFacCliP )->cCodCli, cBncCli ) )

//------------------------------------------------------------------------//
//
// Sincroniza los recibos con las facturas de clientes
//

function SynRecCli( cPath )

   local oBlock
   local oError
   local nTotFac
   local nTotRec
   local cFacCliT
   local cFacCliP
   local cFacCliL
   local cAntCliT
   local cFacRecT
   local cFacRecL
   local cDiv
   local cIva
   local cClient
   local cFPago

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliT", @cFacCliT ) ) EXCLUSIVE
   if !lAIS() ; ( cFacCliT )->( ordListAdd( cPath + "FACCLIT.CDX" ) ); else ; ordSetFocus( 1 ) ; end 

   USE ( cPath + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliL", @cFacCliL ) ) EXCLUSIVE
   if !lAIS() ; ( cFacCliL )->( ordListAdd( cPath + "FACCLIL.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliP", @cFacCliP ) ) EXCLUSIVE
   if !lAIS() ; ( cFacCliP )->( ordListAdd( cPath + "FACCLIP.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "AntCliT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "AntCliT", @cAntCliT ) ) EXCLUSIVE
   if !lAIS() ; ( cAntCliT )->( ordListAdd( cPath + "AntCliT.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACRECT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecT", @cFacRecT ) ) EXCLUSIVE
   if !lAIS() ; ( cFacRecT )->( ordListAdd( cPath + "FacRecT.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACRECL.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecL", @cFacRecL ) ) EXCLUSIVE
   if !lAIS() ; ( cFacRecL )->( ordListAdd( cPath + "FacRecL.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "Client", @cClient ) ) EXCLUSIVE
   if !lAIS() ; ( cClient )->( ordListAdd( cPatCli() + "CLIENT.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FPago", @cFPago ) ) EXCLUSIVE
   if !lAIS() ; ( cFPago )->( ordListAdd( cPatGrp() + "FPAGO.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "Divisas", @cDiv ) )
   if !lAIS() ; ( cDiv )->( ordListAdd( cPatDat() + "DIVISAS.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIva", @cIva ) ) EXCLUSIVE
   if !lAIS() ; ( cIva )->( ordListAdd( cPatDat() + "TIVA.CDX" ) ); else ; ordSetFocus( 1 ) ; end

   ( cFacCliP )->( OrdSetFocus( 0 ) )
   ( cFacCliP )->( dbGoTop() )

   while !( cFacCliP )->( eof() )

      if Empty( ( cFacCliP )->cSufFac )
         ( cFacCliP )->cSufFac := "00"
      end if

      // Casos raros ----------------------------------------------------------

      if ( cFacCliP )->nImpCob == 0 .and. ( cFacCliP )->lCobrado
         ( cFacCliP )->nImpCob := ( cFacCliP )->nImporte
      end if

      if Empty( ( cFacCliP )->cTurRec )
         ( cFacCliP )->cTurRec := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "cTurFac" )
      end if

      if Empty( ( cFacCliP )->cNomCli )
         ( cFacCliP )->cNomCli := retClient( ( cFacCliP )->cCodCli, cClient )
      end if

      if Empty( ( cFacCliP )->cCodCaj )
         if ( cFacCliP )->cTipRec == "R"
            ( cFacCliP )->cCodCaj := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacRecT, "CCODCAJ" )
         else
            ( cFacCliP )->cCodCaj := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "CCODCAJ" )
         end if
      end if

      if Empty( ( cFacCliP )->cCodUsr )
         if ( cFacCliP )->cTipRec == "R"
            ( cFacCliP )->cCodUsr := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacRecT, "CCODUSR" )
         else
            ( cFacCliP )->cCodUsr := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "CCODUSR" )
         end if
      end if

      if Empty( ( cFacCliP )->cCodPgo )
         if ( cFacCliP )->cTipRec == "R"
            ( cFacCliP )->cCodPgo := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacRecT, "cCodPago" )
         else
            ( cFacCliP )->cCodPgo := RetFld( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac, cFacCliT, "cCodPago" )
         end if
      end if

      if Empty( ( cFacCliP )->cCtaRec )
         ( cFacCliP )->cCtaRec    := RetFld( ( cFacCliP )->cCodPgo, cFPago, "cCtaCobro" )
      end if

      if Empty( ( cFacCliP )->cCtaGas )
         ( cFacCliP )->cCtaGas    := RetFld( ( cFacCliP )->cCodPgo, cFPago, "cCtaGas" )
      end if

      ( cFacCliP )->( dbSkip() )

   end while

   ( cFacCliP )->( OrdSetFocus( 1 ) )

   // Calculo de totales----------------------------------------------------

   ( cFacCliT )->( OrdSetFocus( 0 ) )
   ( cFacCliT )->( dbGoTop() )

   while !( cFacCliT )->( eof() )

      nTotFac  := nTotFacCli( ( cFacCliT )->cSerie + Str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, cAntCliT, nil, nil, .f. )
      nTotRec  := nPagFacCli( ( cFacCliT )->cSerie + Str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliP, cIva, cDiv, nil, .f. )

      // Si el importe de la factura es mayor q el de registros----------------

      if abs( nTotFac ) > abs( nTotRec )
         GenPgoFacCli( ( cFacCliT )->cSerie + Str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliL, cFacCliP, cAntCliT, cClient, cFPago, cDiv, cIva, APPD_MODE, .f. )
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

      nTotFac  := nTotFacRec( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, cFacRecL, cIva, cDiv )
      nTotRec  := nPagFacRec( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, cFacRecL, cFacCliP, cIva, cDiv )

      // Si el importe de la factura es mayor q el de registros----------------

      if abs( nTotFac ) > abs( nTotRec )
         GenPgoFacRec( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, cFacRecL, cFacCliP, cClient, cFPago, cDiv, cIva, APPD_MODE, .f. )
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

return nil

//------------------------------------------------------------------------//

static function lGenRecCli( oBrw, oBtn, nDevice )

   local bAction
   local nOrdAnt     := ( D():Documentos( nView ) )->( OrdSetFocus( "cTipo" ) )

   DEFAULT nDevice   := IS_PRINTER

   IF !( D():Documentos( nView ) )->( dbSeek( "RF" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
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

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      END DO

   END IF

   ( D():Documentos( nView ) )->( OrdSetFocus( nOrdAnt ) )

return nil

//---------------------------------------------------------------------------//

static function bGenRecCli( nDevice, cCodDoc, cTitle )

   local nDev  := by( nDevice )
   local cCod  := by( cCodDoc   )
   local cTit  := by( cTitle    )

return {|| ImpPago( nil, nDev, cCod, cTit ) }

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
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lConPgo }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Co. Cobrado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lCobrado }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Tipo"
         :bEditValue          := {|| if( !Empty( ( cFacCliP )->cTipRec ), "Rectificativa", "" ) }
         :nWidth              := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumFac"
         :bEditValue          := {|| ( cFacCliP )->cSerie + "/" + AllTrim( Str( ( cFacCliP )->nNumFac ) ) + "-" + Alltrim( Str( ( cFacCliP )->nNumRec ) ) }
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
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( cFacCliP )->cDivPgo, cDiv ) }
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
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

      cNumRec     := ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac + Str( ( cFacCliP )->nNumRec ) + ( cFacCliP )->cTipRec

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

FUNCTION browseRecCli( aTmp, cFacCliP, cDiv )

   local cDbfRecCli     := getDatabaseRecibosClientes( aTmp, cFacCliP )

Return resourceBrowseRecCli( cDbfRecCli, cDiv )
   
//---------------------------------------------------------------------------//

static function getDatabaseRecibosClientes( aTmp, cFacCliP )
   
   if lAIS()
      return getAdsFilterRecibosClientes( aTmp, cFacCliP )
   else
      return getDbfFilterRecibosClientes( cFacCliP )
   end if

Return nil

//---------------------------------------------------------------------------//

static function getAdsFilterRecibosClientes( aTmp, cFacCliP )

   local cStm

   cStm           := "SELECT * "           
   cStm           += "FROM " + cPatEmp() + "FacCliP RecibosClientes "
   cStm           += "WHERE RecibosClientes.cNumMtr IS NULL AND RecibosClientes.lCobrado=false AND RecibosClientes.lRemesa=false  "
   cStm           += "AND RecibosClientes.cCodCli='" + alltrim( aTmp[ ( cFacCliP )->( fieldPos( "cCodCli" ) ) ] ) + "' "
   
   TDataCenter():ExecuteSqlStatement( cStm, "RecibosFacturasClientes" )

Return ( "RecibosFacturasClientes" )

//---------------------------------------------------------------------------//

static function getDbfFilterRecibosClientes( cFacCliP )

   ( cFacCliP )->( dbSetFilter( {|| !Field->lCobrado }, "!lCobrado" ) )
   ( cFacCliP )->( dbGoTop() )

Return cFacCliP

//---------------------------------------------------------------------------//

static function resourceBrowseRecCli( cFacCliP, cDiv )

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
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lConPgo }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Co. Cobrado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( cFacCliP )->lCobrado }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Tipo"
         :bEditValue          := {|| if( !Empty( ( cFacCliP )->cTipRec ), "Rectificativa", "" ) }
         :nWidth              := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumFac"
         :bEditValue          := {|| ( cFacCliP )->cSerie + "/" + AllTrim( Str( ( cFacCliP )->nNumFac ) ) + "-" + Alltrim( Str( ( cFacCliP )->nNumRec ) ) }
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
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
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

         aAdd( aRecCli, ( ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac + Str( ( cFacCliP )->nNumRec ) + ( cFacCliP )->cTipRec ) )

      next

   end if

RETURN ( aRecCli )

//---------------------------------------------------------------------------//

FUNCTION aCalRecCli()

   local aCalRecCli  := {}

   aAdd( aCalRecCli, {"nImpRecCli( cDbfRec, cDbfDiv )", "N", 16, 6, "Importe del recibo", "cPorDivRec",  "", "" } )
   aAdd( aCalRecCli, {"cTxtRecCli( cDbfRec, cDbfDiv )", "C",100, 0, "Importe en letras",  "",            "", "" } )
   aAdd( aCalRecCli, {"nTotFac",                        "N", 16, 6, "Total factura",      "cPorDivRec",  "", "" } )

return ( aCalRecCli )

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

static function lLiquida( oBrw )

   local nRec

   if len( oBrw:aSelected ) > 0

      for each nRec in ( oBrw:aSelected )

         ( D():FacturasClientesCobros( nView ) )->( dbGoTo( nRec ) )

         if !( D():FacturasClientesCobros( nView ) )->lCobrado

            if ( D():FacturasClientesCobros( nView ) )->( dbRLock() )
               ( D():FacturasClientesCobros( nView ) )->lCobrado   := .t.
               ( D():FacturasClientesCobros( nView ) )->dEntrada   := GetSysDate()
               ( D():FacturasClientesCobros( nView ) )->cTurRec    := cCurSesion()
               ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
            end if

         end if


         if ( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac ) )

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

return nil

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
   nTotCob           := nPagFacRec( cNumFac, cFacRecT, cFacRecL, cFacCliP, cIva, cDiv, nil, .f. )

   if nTotal != nTotCob

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar--
      */

      if ( cFacCliP )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) )

         while cSerFac + Str( nNumFac ) + cSufFac == ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac .and. !( cFacCliP )->( eof() )

            if !Empty( ( cFacCliP )->cTipRec )

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

      nTotal         -= nPagFacRec( cSerFac + Str( nNumFac ) + cSufFac, cFacRecT, cFacRecL, cFacCliP, cIva, cDiv, nil, .t. )

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
            ( cFacCliP )->cDescrip      := "Recibo nº" + AllTrim( Str( nInc ) ) + " de factura rectificativa " + cSerFac  + '/' + allTrim( Str( nNumFac )  ) + '/' + cSufFac
            ( cFacCliP )->cDivPgo       := cDivFac
            ( cFacCliP )->nVdvPgo       := nVdvFac
            ( cFacCliP )->dPreCob       := dFecFac
            ( cFacCliP )->cCtaRec       := ( cFPago )->cCtaCobro
            ( cFacCliP )->cCtaGas       := ( cFPago )->cCtaGas
            ( cFacCliP )->cCtaRem       := cCtaRem
            ( cFacCliP )->cCodAge       := cCodAge
            ( cFacCliP )->lEsperaDoc    := ( cFPago )->lEsperaDoc
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
            ( cFacCliP )->cHorCre       := SubStr( Time(), 1, 5 )

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

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar factura";
               MESSAGE  "Modificar la factura que creó el recibo" ;
               RESOURCE "Document_user1_16" ;
               ACTION   ( EdtFacCli( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] ) )

            SEPARATOR

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

Function EdtRecCli( cNumFac, lOpenBrowse, lRectificativa )

   local lEdit             := .f.
   local nLevel            := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse     := .f.
   DEFAULT lRectificativa  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
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

Return ( lEdit )

//----------------------------------------------------------------------------//

FUNCTION ZooRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
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

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
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

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
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

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
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

Return .t.

//---------------------------------------------------------------------------//

FUNCTION IntEdtRecCli( cNumFac )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientesCobros( nView ) )
      WinEdtRec( nil, bEdit, D():FacturasClientesCobros( nView ) )
   else
      MsgStop( "No se encuentra recibo" )
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ExtEdtRecCli( cFacCliP, nVista, lRectificativa, oCta, oCtrCoste )

   local nLevel            := nLevelUsr( _MENUITEM_ )

   DEFAULT lRectificativa  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   oCentroCoste            := oCtrCoste
   oCtaRem                 := oCta

   nView                   := nVista

   WinEdtRec( nil, bEdit, cFacCliP, lRectificativa )

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ExtDelRecCli( cFacCliP )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   DelCobCli( nil, cFacCliP )

Return .t.

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
   local cCodPgo     := Space( 3 )
   local oTxtPgo
   local cTxtPgo     := ""
   local nRecno      := ( D():FacturasClientesCobros( nView ) )->( recno() )
   local nOrdAnt     := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( 1 ) )
   local dFecIni     := CtoD( "01/" + Str( Month( GetSysDate() ), 2 ) + "/" + Str( Year( Date() ) ) )
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

   TBtnBmp():ReDefine( 92, "Printer_pencil_16",,,,,{|| EdtDocumento( cFmtRec ) }, oDlg, .f., , .f.,  )

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

   TBtnBmp():ReDefine( 321, "Printer_preferences_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

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
      ACTION   (  StartPrint( SubStr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni, 2 ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni, 2 ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg ), oDlg:end( IDOK ) } )

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

   if Empty( cCodDoc )
      return nil
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
               if( nRad == 2, ( ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) >= cDocIni .and. ;
                                ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) <= cDocFin ), .t. )  .and. ;
               if( !Empty( cCodPgo ), cCodPgo == cPgoFacCli( ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC, 9 ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC, D():FacturasClientes( nView ) ), .t. ) .and.;
               if( lNotRem, ( D():FacturasClientesCobros( nView ) )->nNumRem == 0 .and. Empty( ( D():FacturasClientesCobros( nView ) )->cSufRem ), .t. )                                 .and. ;
               if( lNotImp, !( D():FacturasClientesCobros( nView ) )->lRecImp, .t. )                                                                            .and. ;
               if( lNotCob, !( D():FacturasClientesCobros( nView ) )->lCobrado, .t. ) )

            // Posicionamos en ficheros auxiliares

            if dbLock( D():FacturasClientesCobros( nView ) )
               ( D():FacturasClientesCobros( nView ) )->lRecImp    := .t.
               ( D():FacturasClientesCobros( nView ) )->dFecImp    := GetSysDate()
               ( D():FacturasClientesCobros( nView ) )->cHorImp    := SubStr( Time(), 1, 5 )
               ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
            end if

            ( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC ) )
            ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->CCODCLI ) )
            ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->CCODPAGO ) )

            // Imprimir el documento

            PrintReportRecCli( IS_PRINTER, nCopPrn, nil )

         end if

         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

      end while

   else

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      // Cabeceras del listado

      if !Empty( oInf ) .and. oInf:lCreated
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

      if !Empty( oInf )

         ACTIVATE REPORT oInf WHILE ( !( D():FacturasClientesCobros( nView ) )->( eof() ) ) // ON STARTPAGE ( eItems( cCodDoc, oInf ) )

         oInf:oDevice:end()

      end if

      oInf                          := nil

   end if

   oDlg:Enable()

RETURN NIL

//--------------------------------------------------------------------------//

Static Function Skipping( nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodDoc, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, oInf )

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
            if( nRad == 2, ( ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) >= cDocIni .and. ;
                             ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) <= cDocFin ), .t. )  .and. ;
            if( !Empty( cCodPgo ), cCodPgo == cPgoFacCli( ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC, 9 ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC, D():FacturasClientes( nView ) ), .t. ) .and.;
            if( lNotRem, ( D():FacturasClientesCobros( nView ) )->nNumRem == 0 .and. Empty( ( D():FacturasClientesCobros( nView ) )->cSufRem ), .t. )                                 .and. ;
            if( lNotImp, !( D():FacturasClientesCobros( nView ) )->lRecImp, .t. )                                                                            .and. ;
            if( lNotCob, !( D():FacturasClientesCobros( nView ) )->lCobrado, .t. ) )

         // Posicionamos en ficheros auxiliares

         if dbLock( D():FacturasClientesCobros( nView ) )
            ( D():FacturasClientesCobros( nView ) )->lRecImp    := .t.
            ( D():FacturasClientesCobros( nView ) )->dFecImp    := GetSysDate()
            ( D():FacturasClientesCobros( nView ) )->cHorImp    := SubStr( Time(), 1, 5 )
            ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
         end if

         ( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->CSERIE + Str( ( D():FacturasClientesCobros( nView ) )->NNUMFAC ) + ( D():FacturasClientesCobros( nView ) )->CSUFFAC ) )
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

   DEFAULT cNumRec      := ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo recibos"
   DEFAULT nCopies      := 1
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():FacturasClientesCobros( nView ) )->cSerie, "nRecCli", D():Contadores( nView ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "RF", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   /*
   Continuamos con la impresion------------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )

      PrintReportRecCli( nDevice, nCopies, cPrinter )

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

      if Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )
         ( D():FacturasClientes( nView ) )->( dbSeek( cNumRec ) )
         ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cCodCli ) )
         ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cCodPago ) )
      else
         ( D():FacturasRectificativas( nView ))->( dbSeek( cNumRec ) )
         ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cCodCli ) )
         ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasRectificativas( nView ) )->cCodPago ) )
      end if

      if Empty( cPrinter )
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
      ( D():FacturasClientesCobros( nView ) )->cHorImp    := SubStr( Time(), 1, 5 )
      ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
   end if

   /*
   Refrescamos la pantalla principal-------------------------------------------
   */

   if !Empty( oWndBrw )
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

return ( bGen )

//-------------------------------------------------------------------------//

Static Function DataReport( oFr )

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

   oFr:SetMasterDetail( "Recibos", "Facturas",                 {|| ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Facturas rectificativas",  {|| ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Empresa",                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Recibos", "Clientes",                 {|| ( D():FacturasClientesCobros( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Recibos", "Formas de pago",           {|| ( D():FacturasClientesCobros( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Recibos", "Agentes",                  {|| ( D():FacturasClientesCobros( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Recibos", "Bancos",                   {|| ( D():FacturasClientesCobros( nView ) )->cCodCli } )

   oFr:SetResyncPair(   "Recibos", "Facturas" )
   oFr:SetResyncPair(   "Recibos", "Facturas rectificativas" )
   oFr:SetResyncPair(   "Recibos", "Empresa" )
   oFr:SetResyncPair(   "Recibos", "Clientes" )
   oFr:SetResyncPair(   "Recibos", "Formas de pago" )
   oFr:SetResyncPair(   "Recibos", "Agentes" )
   oFr:SetResyncPair(   "Recibos", "Bancos" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Recibos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Recibos", "Importe del recibo",       "CallHbFunc('nImpRecCli')" )
   oFr:AddVariable(     "Recibos", "Importe formato texto",    "CallHbFunc('cTxtRecCli')" )
   oFr:AddVariable(     "Recibos", "Total factura",            "CallHbFunc('nTotFactura')" )
   oFr:AddVariable(     "Recibos", "Total rectificativa",      "CallHbFunc('nTotRectificativa')" )
   oFr:AddVariable(     "Recibos", "Cuenta bancaria cliente",  "CallHbFunc('cCtaRecCli')" )

Return nil

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

      if !Empty( ( cDbfDoc )->mReport )

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

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

static Function PrintReportRecCli( nDevice, nCopies, cPrinter )

   local oFr
   local cFilePdf       := cPatTmp() + "RecibosCliente" + StrTran( ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac, " ", "" ) + ".Pdf"

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

                  :SetTypeDocument( "nRecCli" )
                  :SetAlias(        D():FacturasClientesCobros( nView ) )
                  :SetItems(        aItmRecCli() )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( D():FacturasClientesCobros( nView ) )->cCodCli, D():Clientes( nView ), "cMeiInt" ) )
                  :SetAsunto(       "Envío de  recibo de cliente número " + StrTran( ( D():FacturasClientesCobros( nView ) )->cSerie + "/" + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + "-" + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ), " ", "" ) )
                  :SetMensaje(      "Adjunto le remito nuestra factura de anticipo de cliente " + StrTran( ( D():FacturasClientesCobros( nView ) )->cSerie + "/" + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + "-" + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ), " ", "" ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( D():FacturasClientesCobros( nView ) )->dPreCob ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :lSend()

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

function nTotFactura( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT )

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT cFacCliT  := D():FacturasClientes( nView )
   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT cDbfIva   := D():TiposIva( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )
   DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cAntCliT  := D():AnticiposClientes( nView )

Return ( nTotFacCli( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT, , , .f. ) )

//---------------------------------------------------------------------------//

function nTotRectificativa( cNumRec, cFacRecT, cFacRecL, cDbfIva, cDbfDiv )

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac
   DEFAULT cFacRecT  := D():FacturasRectificativas( nView )
   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT cDbfIva   := D():TiposIva( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )

Return ( nTotFacRec( cNumRec, cFacRecT, cFacRecL, cDbfIva, cDbfDiv, nil, nil, .f. ) )

//---------------------------------------------------------------------------//

function nTotRecibo( cNumRec, cFacCliP, cDiv )

   local hStatus
   local nTotRec     := 0

   DEFAULT cNumRec   := ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec
   DEFAULT cDiv      := D():Divisas( nView )

   hStatus           := hGetStatus( cFacCliP )

   if hSeekInOrd( { "Value" => cNumRec, "Order" => "nNumFac", "Alias" => cFacCliP } )
      nTotRec        := nTotRecCli( cFacCliP, cDiv )
   end if

   hSetStatus( hStatus )

Return ( nTotRec )

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
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) + Field->cTipRec } ) )

      // "Código"

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodCli", "cCodCli", {|| Field->CCODCLI } ) )

      // "Nombre",;

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cNomCli", "cNomCli", {|| Field->cNomCli } ) )

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
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodAge", "cCodAge", {|| Field->CCODAGE } ) )

      // Codigo de clientes no cobrados

      ( cFacCliT )->( ordCondSet("!Deleted() .and. !Field->lCobrado", {|| !Deleted() .and. !Field->lCobrado } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lCodCli", "cCodCli", {|| Field->cCodCli } ) )

      // Numero de remesas

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumRem", "Str( nNumRem ) + cSufRem", {|| Str( Field->nNumRem ) + Field->cSufRem } ) )

      // Cuentas de remesas----------------------------------------------------

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCtaRem", "cCtaRem", {|| Field->CCTAREM }, ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumCob", "Str( nNumCob ) + cSufCob", {|| Str( Field->NNUMCOB ) + Field->CSUFCOB } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cTurRec", "cTurRec + cSufFac + cCodCaj", {|| Field->CTURREC + Field->CSUFFAC + Field->cCodCaj } ) )

      ( cFacCliT )->( ordCondSet("!Deleted() .and. Empty( cTipRec )", {|| !Deleted() .and.  Empty( Field->cTipRec ) } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "fNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted() .and. !Empty( cTipRec )", {|| !Deleted() .and.  !Empty( Field->cTipRec ) } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "rNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cRecDev", "cRecDev", {|| Field->CRECDEV } ) )

      ( cFacCliT )->( ordCondSet("!Deleted() .and. Field->lCobrado", {|| !Deleted() .and. Field->lCobrado } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lCtaBnc", "Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp", {|| Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cNumMtr", "Field->cNumMtr", {|| Field->cNumMtr } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliP.Cdx", "iNumFac", "'18' + cSerie + str( nNumFac ) + Space( 1 ) + cSufFac + Str( nNumRec )", {|| '18' + Field->cSerie + str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac + Str( Field->nNumRec ) } ) )

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
      dbCreate( cPath + "FacCliP.Dbf", aSqlStruct( aItmRecCli() ), cLocalDriver() )
   end if 

   if !lExistTable( cPath + "FacCliG.Dbf", cLocalDriver() )
      dbCreate( cPath + "FacCliG.Dbf", aSqlStruct( aItmGruposRecibos() ), cLocalDriver() )
   end if

   if lReindex
      rxRecCli( cPath, cLocalDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aItmRecCli()

   local aBasRecCli  := {}

   aAdd( aBasRecCli, {"cSerie"      ,"C",  1, 0, "Serie de factura",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumFac"     ,"N",  9, 0, "Número de factura",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSufFac"     ,"C",  2, 0, "Sufijo de factura",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumRec"     ,"N",  2, 0, "Número del recibo",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cTipRec"     ,"C",  1, 0, "Tipo de recibo",              "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodPgo"     ,"C",  2, 0, "Código de forma de pago",     "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodCaj"     ,"C",  3, 0, "Código de caja",              "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cTurRec"     ,"C",  6, 0, "Sesión del recibo",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodCli"     ,"C", 12, 0, "Código de cliente",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cNomCli"     ,"C", 80, 0, "Nombre de cliente",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dEntrada"    ,"D",  8, 0, "Fecha de cobro",              "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImporte"    ,"N", 16, 6, "Importe",                     "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDesCriP"    ,"C",100, 0, "Concepto del pago",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dPreCob"     ,"D",  8, 0, "Fecha de expedición",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cPgdoPor"    ,"C", 50, 0, "Pagado por",                  "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDocPgo"     ,"C", 50, 0, "Documento de pago",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lCobrado"    ,"L",  1, 0, "Lógico de cobrado",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDivPgo"     ,"C",  3, 0, "Código de la divisa",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nVdvPgo"     ,"N", 10, 6, "Cambio de la divisa",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lConPgo"     ,"L",  1, 0, "Lógico de contabilizado",     "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaRec"     ,"C", 12, 0, "Cuenta de contabilidad",      "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImpEur"     ,"N", 16, 6, "Importe del pago en Euros",   "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lImpEur"     ,"L",  1, 0, "Lógico cobrar en Euros",      "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumRem"     ,"N",  9, 0, "Número de la remesas",        "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSufRem"     ,"C",  2, 0, "Sufijo de remesas",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaRem"     ,"C",  3, 0, "Cuenta de remesa",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lRecImp"     ,"L",  1, 0, "Lógico ya impreso",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lRecDto"     ,"L",  1, 0, "Lógico descontado",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecDto"     ,"D",  8, 0, "Fecha del descuento",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecVto"     ,"D",  8, 0, "Fecha de vencimiento",        "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodAge"     ,"C",  3, 0, "Código del agente",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumCob"     ,"N",  9, 0, "Número de cobro",             "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSufCob"     ,"C",  2, 0, "Sufijo del cobro",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImpCob"     ,"N", 16, 6, "Importe del cobro",           "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImpGas"     ,"N", 16, 6, "Importe de gastos",           "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaGas"     ,"C", 12, 0, "Subcuenta de gastos",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lEsperaDoc"  ,"L",  1, 0, "Lógico a la espera de documentación","",            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lCloPgo"     ,"L",  1, 0, "Lógico de turno cerrado",     "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecImp"     ,"D",  8, 0, "Última fecha de impresión" ,  "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cHorImp"     ,"C",  5, 0, "Hora de la última impresión" ,"",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lNotArqueo"  ,"L",  1, 0, "Lógico de no incluir en arqueo","",                 "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodBnc"     ,"C",  4, 0, "Código del banco",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecCre"     ,"D",  8, 0, "Fecha de creación del registro" ,  "",              "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cHorCre"     ,"C",  5, 0, "Hora de creación del registro" ,"",                 "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodUsr"     ,"C",  3, 0, "Código del usuario" ,"",                            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lDevuelto"   ,"L",  1, 0, "Lógico recibo devuelto" ,"",                        "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecDev"     ,"D",  8, 0, "Fecha devolución" ,"",                              "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cMotDev"     ,"C",250, 0, "Motivo devolución" ,"",                             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cRecDev"     ,"C", 14, 0, "Recibo de procedencia" ,"",                         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lSndDoc"     ,"L",  1, 0, "Lógico para envio" ,"",                             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cBncEmp"     ,"C", 50, 0, "Banco de la empresa para el recibo" ,"",            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo" ,"",              "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cEPaisIBAN"  ,"C",  2, 0, "País IBAN de la empresa para el recibo" ,"",        "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cECtrlIBAN"  ,"C",  2, 0, "Dígito de control IBAN de la empresa para el recibo" ,"", "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",           "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",  "",          "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",  "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",  "",                "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cPaisIBAN"   ,"C",  2, 0, "País IBAN del cliente para el recibo" ,"",          "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtrlIBAN"   ,"C",  2, 0, "Dígito de control IBAN del cliente para el recibo" ,"", "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",  "",             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",  "",            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDigCli"     ,"C",  2, 0, "Dígito de control de la cuenta del cliente", "",    "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",  "",                  "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lRemesa"     ,"L",  1, 0, "Lógico de incluido en una remesa",  "",             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cNumMtr"     ,"C", 15, 0, "Numero del recibo matriz",   "",                    "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lPasado"     ,"L",  1, 0, "Lógico pasado", "",                                 "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtrCoste"   ,"C",  9, 0, "Código del centro de coste", "",                    "", "( cDbfRec )" } )

Return ( aBasRecCli )

//---------------------------------------------------------------------------//

FUNCTION aItmGruposRecibos()

   local aBasRecCli  := {}

   aAdd( aBasRecCli, {"cNumMtr"     ,"C", 14, 0, "Número de recibo matriz",         "",                "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cNumRec"     ,"C", 14, 0, "Número de recibo relacionado",    "",                "", "( cDbfRec )" } )

Return ( aBasRecCli )

//---------------------------------------------------------------------------//
// 
// Fachada para vistas
//

FUNCTION generatePagosFacturaCliente( Id, nView, nMode )

   sysrefresh()

Return ( genPgoFacCli( Id, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():Clientes( nView ), D():FormasPago( nView ), D():Divisas( nView ), D():TiposIva( nView ), nMode, .f. ) )   

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/

FUNCTION GenPgoFacCli( cNumFac, cFacCliT, cFacCliL, cFacCliP, cAntCliT, dbfCli, cFPago, cDiv, cIva, nMode, lMessage ) 

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

   DEFAULT nMode     := APPD_MODE
   DEFAULT lMessage  := .t.

   DEFAULT cFacCliP  := D():FacturasClientesCobros( nView )
   DEFAULT cFPago    := D():FormasPago( nView )
   DEFAULT cDiv      := D():Divisas( nView )
   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT cFacCliT  := D():FacturasClientes( nView )
   DEFAULT cAntCliT  := D():AnticiposClientes( nView )

   lAlert            := ( nMode == APPD_MODE )

   cSerFac           := ( cFacCliT )->cSerie
   nNumFac           := ( cFacCliT )->nNumFac
   cSufFac           := ( cFacCliT )->cSufFac
   cDivFac           := ( cFacCliT )->cDivFac
   nVdvFac           := ( cFacCliT )->nVdvFac
   dFecFac           := ( cFacCliT )->dFecFac
   cCodPgo           := ( cFacCliT )->cCodPago
   cCodCli           := ( cFacCliT )->cCodCli
   cNomCli           := ( cFacCliT )->cNomCli
   cCodAge           := ( cFacCliT )->cCodAge
   cCodCaj           := ( cFacCliT )->cCodCaj
   cCodUsr           := ( cFacCliT )->cCodUsr
   cBanco            := ( cFacCliT )->cBanco
   cPaisIBAN         := ( cFacCliT )->cPaisIBAN 
   cCtrlIBAN         := ( cFacCliT )->cCtrlIBAN
   cEntidad          := ( cFacCliT )->cEntBnc
   cSucursal         := ( cFacCliT )->cSucBnc
   cControl          := ( cFacCliT )->cDigBnc
   cCuenta           := ( cFacCliT )->cCtaBnc

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

   nTotal            := nTotFacCli( cNumFac, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, cAntCliT, nil, nil, .f. )

   nTotCob           := nPagFacCli( cNumFac, cFacCliT, cFacCliP, cIva, cDiv, nil, .f. )

   /*
   Ya nos viene sin los anticipos
   */

   if lDiferencia( nTotal, nTotCob, 0.1 )

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar
      */

      if ( cFacCliP )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) )

         while cSerFac + Str( nNumFac ) + cSufFac == ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac

            if !( cFacCliP )->lCobrado .and. dbLock( cFacCliP )
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

      nTotal         -= nPagFacCli( cSerFac + Str( nNumFac ) + cSufFac, cFacCliT, cFacCliP, cIva, cDiv, nil, .t. )

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
            ( cFacCliP )->cDescrip      := "Recibo nº" + AllTrim( Str( nInc ) ) + " de factura " + cSerFac  + '/' + allTrim( Str( nNumFac ) ) + '/' + cSufFac

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

            if !( "TABLET" $ cParamsMain() )

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
            ( cFacCliP )->cHorCre          := SubStr( Time(), 1, 5 )

            lAlert                           := .f.

            ( cFacCliP )->( dbUnLock() )

         next

      else

         if lMessage
            MsgStop( "Forma de pago " + cCodPgo + " no encontrada, generando recibos" )
         end if

      end if

   end if

   ( dbfCli )->( dbGoTo( nRecCli ) )

   if ( lAlert .and. lMessage )
      msgWait( "Factura " + cSerFac  + '/' + allTrim( Str( nNumFac ) ) + '/' + cSufFac + " no se generaron recibos.", "Atención", 1 )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION dNexDay( dFecPgo, dbfCli )

   local nDay
   local nMon
   local nYea

   if Empty( dbfCli )
      Return ( dFecPgo )
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

RETURN ( Ctod( Str( nDay, 2 ) + "/" + Str( nMon, 2 ) + "/" + Str( nYea, 4 ) ) )

//----------------------------------------------------------------------------//

Function ValCobro( aGet, aTmp )

   if aTmp[ _NIMPCOB ] <= aTmp[ _NIMPORTE ]

      if ( aTmp[ _NIMPCOB ] != 0 ) .and. ( aTmp[ _NIMPORTE ] != aTmp[ _NIMPCOB ] )
         aGet[ _NIMPGAS ]:cText( aTmp[ _NIMPORTE ] - aTmp[ _NIMPCOB ] )
      end if

      Return .t.

   else

      msgStop( "El importe del cobro excede al importe del recibo" )

   end if

Return .f.

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

Return .t.

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
         aGet[ _CMOTDEV ]:cText( Space( 250 ) )
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

   if Empty( aTmp[ _CRECDEV ] )
      aGet[ _CRECDEV ]:Disable()
   else
      aGet[ _CRECDEV ]:Enable()
   end if

return .t.

//---------------------------------------------------------------------------//

Function DelCobCli( oBrw, cFacCliP )

   if ( cFacCliP )->lCloPgo .and. !oUser():lAdministrador()
      MsgStop( "Solo pueden eliminar los recibos cerrados los administradores." )
      return .f.
   end if

   if !Empty( ( cFacCliP )->nNumRem ) .and. !oUser():lAdministrador()
      msgStop( "Este tiket pertenece a una remesa de clientes.", "Imposible eliminar" )
      return .f.
   end if

   if !Empty( ( cFacCliP )->nNumCob ) .and. !oUser():lAdministrador()
      msgStop( "Este tiket pertenece a una remesa de cobros.", "Imposible eliminar" )
      return .f.
   end if

   if ( cFacCliP )->lCobrado .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta cobrado.", "Imposible eliminar" )
      return .f.
   end if

   if ( cFacCliP )->lRecDto .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta descontado.", "Imposible eliminar" )
      return .f.
   end if

   WinDelRec( oBrw, cFacCliP )

return .t.

//---------------------------------------------------------------------------//

function nNewReciboCliente( cNumFac, cTipRec, cFacCliP )

   local nCon
   local nRec
   local nOrd

   DEFAULT cTipRec   := Space( 1 )

   nCon              := 1
   nRec              := ( cFacCliP )->( Recno() )
   nOrd              := ( cFacCliP )->( OrdSetFocus( "nNumFac" ) )

   if ( cFacCliP )->( dbSeek( cNumFac ) )

      while ( cFacCliP )->cSerie + Str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac == cNumFac .and. !( cFacCliP )->( eof() )

         if ( cFacCliP )->cTipRec == cTipRec
            ++nCon
         end if

         ( cFacCliP )->( dbSkip() )

      end do

   end if

   ( cFacCliP )->( OrdSetFocus( nOrd ) )
   ( cFacCliP )->( dbGoTo( nRec ) )

return ( nCon )

//------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( D():FacturasClientesCobros( nView ) )
      CreateUserFilter( "", D():FacturasClientesCobros( nView ), .f., , , "all" )
   else
      DestroyFastFilter( D():FacturasClientesCobros( nView ) )
      CreateUserFilter( "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox(), D():FacturasClientesCobros( nView ), .f., , , "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox() )
   end if

   ( D():FacturasClientesCobros( nView ) )->( dbGoTop() )

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, cFacCliP, oBrw, oDlg, nMode, lCompensar )

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

   if Empty( cFacCliP )
      cFacCliP       := D():FacturasClientesCobros( nView )
   end if

   lImpNeg     := ( cFacCliP )->nImporte < 0
   nImpFld     := abs( ( cFacCliP )->nImporte )
   nImpTmp     := abs( aTmp[ _NIMPORTE ] )
   cNumFac     := aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
   cNumRec     := aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] + Str( aTmp[ _NNUMREC ] )
   cNumRecTip  := aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] + Str( aTmp[ _NNUMREC ] ) + aTmp[ _CTIPREC ]
   lDevuelto   := aTmp[ _LDEVUELTO ]

   /*
   Condiciones antes de grabar-------------------------------------------------
   */

   if !aGet[ _NIMPCOB ]:lValid()
      return .f.
   end if

   if nImpTmp > nImpFld
      msgStop( "El importe no puede ser superior al actual." )
      return nil
   end if

   if !lExisteTurno( aGet[ _CTURREC ]:VarGet(), D():Turnos( nView ) )
      msgStop( "La sesión introducida no existe." )
      aGet[ _CTURREC ]:SetFocus()
      return nil
   end if

   oDlg:Disable()

   /*
   Comprobamos q los importes sean distintos-----------------------------------
   */

   if ( nImpFld != nImpTmp ) .and. Empty( aRecibosRelacionados )
   
      nRec                       := ( cFacCliP )->( Recno() )

      /*
      El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
      */

      nImp                       := ( nImpFld - nImpTmp ) * if( lImpNeg, - 1 , 1 )

      /*
      Obtnenemos el nuevo numero del contador----------------------------------
      */

      nCon                       := nNewReciboCliente( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], aTmp[ _CTIPREC ], cFacCliP )

      /*
      Añadimos el nuevo recibo-------------------------------------------------
      */

      ( cFacCliP )->( dbAppend() )

      ( cFacCliP )->cTurRec    := cCurSesion()
      ( cFacCliP )->cSerie     := aTmp[ _CSERIE  ]
      ( cFacCliP )->nNumFac    := aTmp[ _NNUMFAC ]
      ( cFacCliP )->cSufFac    := aTmp[ _CSUFFAC ]
      ( cFacCliP )->cTipRec    := aTmp[ _CTIPREC ]
      ( cFacCliP )->cCodCaj    := aTmp[ _CCODCAJ ]
      ( cFacCliP )->cCodCli    := aTmp[ _CCODCLI ]
      ( cFacCliP )->cNomCli    := aTmp[ _CNOMCLI ]
      ( cFacCliP )->dEntrada   := Ctod( "" )
      ( cFacCliP )->nImporte   := nImp
      ( cFacCliP )->nImpCob    := nImp
      ( cFacCliP )->cDescrip   := "Recibo nº" + AllTrim( Str( nCon ) ) + " de factura " + if( !Empty( aTmp[ _CTIPREC ] ), "rectificativa ", "" ) + aTmp[ _CSERIE ] + '/' + AllTrim( Str( aTmp[ _NNUMFAC ] ) ) + '/' + aTmp[ _CSUFFAC ]
      ( cFacCliP )->dPreCob    := dFecFacCli( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], D():FacturasClientes( nView ) )
      ( cFacCliP )->cPgdoPor   := ""
      ( cFacCliP )->lCobrado   := .f.
      ( cFacCliP )->nNumRec    := nCon
      ( cFacCliP )->cDivPgo    := aTmp[ _CDIVPGO ]
      ( cFacCliP )->nVdvPgo    := aTmp[ _NVDVPGO ]
      ( cFacCliP )->cCodPgo    := aTmp[ _CCODPGO ]
      ( cFacCliP )->lConPgo    := .f.
      ( cFacCliP )->dFecCre    := GetSysDate()
      ( cFacCliP )->cHorCre    := SubStr( Time(), 1, 5 )

      ( cFacCliP )->( dbUnLock() )

      ( cFacCliP )->( dbGoTo( nRec ) )

   end if

   /*
   Estado de la contabilizacion------------------------------------------------
   */

   if ( lOldDevuelto != lDevuelto )
      aTmp[ _LCONPGO ]           := .f.
   end if

   /*
   Grabamos el recibo----------------------------------------------------------
   */

   WinGather( aTmp, aGet, cFacCliP, oBrw, nMode )

   /*
   Anotamos los recibos asociados----------------------------------------------
   */

   if lCompensar                       .and.;
      isArray( aRecibosRelacionados )  .and.;
      len( aRecibosRelacionados ) > 1

      nRec                       := ( cFacCliP )->( Recno() )
      nOrdAnt                    := ( cFacCliP )->( OrdSetFocus( "nNumFac" ) )

      for each cNumRec in aRecibosRelacionados

         if cNumRec != cNumRecTip
            if ( cFacCliP )->( dbSeek( cNumRec ) ) .and. dbDialogLock( cFacCliP )
               ( cFacCliP )->cNumMtr := cNumRecTip
               ( cFacCliP )->( dbUnLock() )
            end if 
         end if

      next 

      ( cFacCliP )->( dbGoTo( nRec ) )
      ( cFacCliP )->( OrdSetFocus( nOrdAnt ) )

   end if 

   /*
   Si es Devuelto creamos el tiket nuevo---------------------------------------
   */

   if lOldDevuelto != lDevuelto

      nRec                             := ( cFacCliP )->( Recno() )

      if lDevuelto

         nOrdAnt                       := ( cFacCliP )->( OrdSetFocus( "nNumFac" ) )

         if ( cFacCliP )->( dbSeek( cNumRec ) )
            aTabla                     := dbScatter( cFacCliP )
         end if

         nCon                          := nNewReciboCliente( aTabla[ _CSERIE ] + Str( aTabla[ _NNUMFAC ] ) + aTabla[ _CSUFFAC ], aTabla[ _CTIPREC ], cFacCliP )

         if aTabla != nil

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
            ( cFacCliP )->cDesCriP   := "Recibo Nº" + AllTrim( Str( nCon ) ) + " generado de la devolución del recibo " + aTabla[ _CSERIE ] + "/" + AllTrim( Str( aTabla[ _NNUMFAC ] ) ) + "/" + aTabla[ _CSUFFAC ] + " - " + AllTrim( Str( aTabla[ _NNUMREC ] ) )
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
            ( cFacCliP )->cCodUsr    := oUser():cCodigo()
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

   if ( cFacCliP )->( dbSeek( cNumFac ) )
      
      if Empty( ( cFacCliP )->cTipRec )
         ChkLqdFacCli( nil, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), cFacCliP, D():AnticiposClientes( nView ), D():TiposIva( nView ), D():Divisas( nView ), .f. )
      else
         ChkLqdFacRec( nil, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ), cFacCliP, D():TiposIva( nView ), D():Divisas( nView ) )
      end if

   end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oDlg:Enable()

   oDlg:End( IDOK )

return .t.

//--------------------------------------------------------------------------//

function nEstadoRecibo( uFacCliP )

Return ( hGetPos( hEstadoRecibo, cEstadoRecibo( uFacCliP ) ) )

//---------------------------------------------------------------------------//

function cEstadoRecibo( uFacCliP )

   local cEstadoRecibo  := ""

   DEFAULT uFacCliP     := D():FacturasClientesCobros( nView )

   if empty( uFacCliP )
      Return ( cEstadoRecibo )
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

Return ( cEstadoRecibo )

//---------------------------------------------------------------------------//

Function lReciboMatriz( cNumRec, uFacCliP )
   
   DEFAULT uFacCliP        := D():FacturasClientesCobros( nView )
   DEFAULT cNumRec         := ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec

   if dbSeekInOrd( cNumRec, "cNumMtr", uFacCliP )
      Return .t.
   end if 

Return .f.

//---------------------------------------------------------------------------//

static function nEstadoMatriz()

   local nRec
   local nOrd
   local nEstado     := 1
   local cNum        := ( D():FacturasClientesCobros( nView ) )->cSerie + Str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + Str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec

   nRec              := ( D():FacturasClientesCobros( nView ) )->( recno() )
   nOrd              := ( D():FacturasClientesCobros( nView ) )->( ordsetfocus( "cNumMtr" ) )

   if ( D():FacturasClientesCobros( nView ) )->( dbseek( cNum ) )
      nEstado        := 2
   end if 
  
   ( D():FacturasClientesCobros( nView ) )->( ordsetfocus( nOrd ) )
   ( D():FacturasClientesCobros( nView ) )->( dbgoto( nRec ) )

   if !Empty( ( D():FacturasClientesCobros( nView ) )->cNumMtr )
      nEstado        := 3
   end if

Return nEstado

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

return ( cCuentaEmpresaRecibo )

//---------------------------------------------------------------------------//

static function lUpdateSubCta( aGet, aTmp )

   if !Empty( aTmp[ _CCODPGO ] )

      if !Empty( aGet[ _CCTAREC ] )
         aGet[ _CCTAREC ]:cText( RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ), "cCtaCobro" ) )
         aGet[ _CCTAREC ]:Refresh()
      end if

      if !Empty( aGet[ _CCTAGAS ] )
         aGet[ _CCTAGAS ]:cText( RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ), "cCtaGas" ) )
         aGet[ _CCTAGAS ]:Refresh()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

static function lValidCompensado( aTmp )

   local cNumRec  := aTmp[ _CSERIE ] + "/" + allTrim( Str( aTmp[ _NNUMFAC ] ) ) + "/" + aTmp[ _CSUFFAC ] + "-" + AllTrim( Str( aTmp[ _NNUMREC ] ) )

   if aTmp[ _LCOBRADO ]
      msgStop( "Recibo ya cobrado.", "Recibo: " + cNumRec )
      Return .f.
   end if 

   if aTmp[ _LREMESA ]
      msgStop( "Recibo ya remesado.", "Recibo: " + cNumRec )
      Return .f.
   end if 

   if !Empty( aTmp[ _CNUMMTR ] )
      msgStop( "Recibo ya pertenece a otra matriz.", "Recibo: " + cNumRec )
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//