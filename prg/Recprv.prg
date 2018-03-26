//
#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Print.ch"
#include "Report.ch"
#include "Factu.ch"

#define _MENUITEM_               "01027"

/*
Defines para las lineas de Pago
*/

#define _CSERFAC                 1      //   C      1     0
#define _NNUMFAC                 2      //   N      9     0
#define _CSUFFAC                 3      //   N      9     0
#define _NNUMREC                 4      //   N      2     0
#define _CTIPREC                 5      //   N      2     0
#define _CCODCAJ                 6      //   C     12     0
#define _CCODPRV                 7      //   C     12     0
#define _CNOMPRV                 8      //   C     12     0
#define _DENTRADA                9      //   D      8     0
#define _NIMPORTE               10      //   N     10     0
#define _CDESCRIP               11      //   C    100     0
#define _DPRECOB                12      //   C      8     0
#define _CPGDOPOR               13      //   C     50     0
#define _LCOBRADO               14      //   C      1     0
#define _LCONPGO                15      //   L      1     0
#define _CDIVPGO                16      //   C      3     0
#define _NVDVPGO                17      //
#define _CCTAREC                18      //   C     12     0
#define _LRECIMP                19      //   L      1     0
#define _DFECVTO                20      //   D      8     8
#define _CCODUSR                21      //
#define _DFECCHG                22      //   D      8     0
#define _CTIMCHG                23      //   C      5     0
#define _CTURREC                24      //   C      6     0
#define _LCLOPGO                25      //   L      1     0
#define _DFECIMP                26      //   D      8     0
#define _CHORIMP                27      //   C      5     0
#define _CCODBNC                28      //   C      4     0
#define _CCODPGO                29      //   C      2     0
#define _LNOTARQUEO             30      //   L      1     0
#define _LDEVUELTO              31      //   L      1     0
#define _DFECDEV                32      //   D      8     0
#define _CMOTDEV                33      //   C    250     0
#define _CRECDEV                34      //   C     14     0
#define _CBNCEMP                35
#define _CBNCPRV                36
#define _CEPAISIBAN             37
#define _CECTRLIBAN             38
#define _CENTEMP                39
#define _CSUCEMP                40
#define _CDIGEMP                41
#define _CCTAEMP                42
#define _CPAISIBAN              43
#define _CCTRLIBAN              44
#define _CENTPRV                45
#define _CSUCPRV                46
#define _CDIGPRV                47
#define _CCTAPRV                48
#define _CCENTROCOSTE           49

memvar cDbf
memvar cDbfCol
memvar cDbfRec
memvar cDbfPrv
memvar cDbfPgo
memvar cDbfDiv
memvar cPirDivRec
memvar nPagina
memvar lEnd

static oWndBrw
static dbfDiv
static oBandera
static dbfPrv
static dbfFacPrvP
static dbfFacPrvT
static dbfFacPrvL
static dbfRctPrvT
static dbfFPago
static dbfIva

static oCentroCoste

static nView

static hEstadoRecibo          := {  "Pendiente"             => "bCancel",;
                                    "Cobrado"               => "bSel",;
                                    "Devuelto"              => "bAlert" }

static oMenu
static cFiltroUsuario   := ""
static lOldDevuelto     := .f.
static lOpenFiles       := .f.
static bEdtRec          := { |aTmp, aGet, dbf, oBrw, lRectificativa, bValid, nMode| EdtPag( aTmp, aGet, dbf, oBrw, lRectificativa, bValid, nMode ) }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp )

   local oBlock

   DEFAULT cPatEmp      := cPatEmp()

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      nView             := D():CreateView()

      D():FacturasProveedoresPagos( nView )

      D():FacturasProveedores( nView )

      D():FacturasProveedoresLineas( nView )

      D():FacturasRectificativasProveedores( nView )

      D():Divisas( nView )

      D():Proveedores( nView )

      D():FormasPago( nView )

      D():TiposIva( nView )

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( ordSetFocus( "cTipo" ) )

      D():Empresa( nView )

      D():Contadores( nView )

      D():BancosProveedores( nView )
      ( D():BancosProveedores( nView ) )->( ordSetFocus( "cCodDef" ) )

      D():Cajas( nView )

      oBandera          := TBandera():New()

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )
         cFiltroUsuario := "Field->cCodUsr == '" + Auth():Codigo()  + "' .and. Field->cCodCaj == '" + Application():CodigoCaja() + "'"
      end if

      oCentroCoste            := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if 

      EnableAcceso()

   RECOVER

      lOpenFiles        := .f.

      EnableAcceso()

      msgStop( "Imposible abrir todas las bases de datos de recibos de proveedores" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( D():FacturasProveedoresPagos( nView ), .t., .t. )

   if !empty( oCentroCoste )
      oCentroCoste:CloseFiles()
   end if

   CodigosPostales():GetInstance():CloseFiles()

   oBandera    := nil
   oWndBrw     := nil

   oWndBrw     := nil

   lOpenFiles  := .f.

   EnableAcceso()

RETURN .T.

//--------------------------------------------------------------------------//

FUNCTION RecPrv( oMenuItem, oWnd, aNumRec )

   local oImp
   local oPrv
   local oFlt
   local oPdf
   local oMail
   local lEur           := .f.
   local nLevel
   local oRotor
   local lFound
   local nOrdAnt
   local oBtnEur

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  aNumRec     := Array( 1 )

   /*
   Obtenemos el nivel de acceso
   */

   nLevel               := Auth():Level( oMenuItem )
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

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Pagos de facturas de proveedores" ;
      ALIAS    ( D():FacturasProveedoresPagos( nView ) );
      MRU      "gc_briefcase2_businessman_16";
      BITMAP   Rgb( 0, 114, 198 ) ;
      PROMPTS  "Número",;
               "Código",;
               "Nombre proveedor",;
               "Expedición",;
               "Vencimiento",;
               "Sesión",;
               "Pago",;
               "Importe";
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():FacturasProveedoresPagos( nView ) ) ) ;
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():FacturasProveedoresPagos( nView ) ) ) ;
      DELETE   ( DelPgoPrv( oWndBrw:oBrw ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

   oWndBrw:lFechado     := .t.
   oWndBrw:bChgIndex    := {|| if( SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() ), CreateFastFilter( cFiltroUsuario, D():FacturasProveedoresPagos( nView ), .f., , cFiltroUsuario ), CreateFastFilter( "", D():FacturasProveedoresPagos( nView ), .f. ) ) }

   oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Sesión cerrada"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->lCloPgo }
      :nWidth           := 20
      :lHide            := .t.
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "gc_lock2_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Pagado"
      :nHeadBmpNo       := 4
      :bStrData         := {|| "" }
      :bBmpData         := {|| nEstadoReciboProveedor( D():FacturasProveedoresPagos( nView ) ) }
      :nWidth           := 20
      :AddResource( "Cnt16" )
      :AddResource( "Sel16" )
      :AddResource( "gc_money2_16" )
      :AddResource( "gc_money2_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Contabilizado"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->lConPgo }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "gc_folder2_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Impreso"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->lRecImp }
      :nWidth           := 20
      :lHide            := .t.
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "gc_printer2_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Tipo"
      :bEditValue       := {|| if( !empty( ( D():FacturasProveedoresPagos( nView ) )->cTipRec ), "Rectificativa", "" ) }
      :nWidth           := 60
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Número"
      :cSortOrder       := "nNumFac"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cSerFac + "/" + AllTrim( Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) ) + "-" + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ) }
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nWidth           := 80
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Delegación"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cSufFac  }
      :nWidth           := 20
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Sesión"
      :bEditValue       := {|| Trans( ( D():FacturasProveedoresPagos( nView ) )->cTurRec, "######" ) }
      :cSortOrder       := "cTurRec"
      :nWidth           := 60
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t.
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Expedición"
      :cSortOrder       := "dPreCob"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->dPreCob }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nDataStrAlign    := 3
      :nHeadStrAlign    := 3
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Caja"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cCodCaj }
      :nWidth           := 40
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Usuario"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cCodUsr }
      :nWidth           := 40
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Vencimiento"
      :cSortOrder       := "dFecVto"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->dFecVto }
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nWidth           := 80
      :nDataStrAlign    := 3
      :nHeadStrAlign    := 3
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Pago"
      :cSortOrder       := "dEntrada"
      :bEditValue       := {|| Dtoc( ( D():FacturasProveedoresPagos( nView ) )->dEntrada ) }
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nWidth           := 80
      :nDataStrAlign    := 3
      :nHeadStrAlign    := 3
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Código"
      :cSortOrder       := "cCodPrv"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cCodPrv }
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nWidth           := 80
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Nombre proveedor"
      :cSortOrder       := "cNomPrv"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cNomPrv }
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nWidth           := 180
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Descripción"
      :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cDescrip }
      :nWidth           := 200
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Importe"
      :cSortOrder       := "nImporte"
      :bEditValue       := {|| nTotRecPrv( D():FacturasProveedoresPagos( nView ), D():Divisas( nView ), if( lEur, cDivChg(), cDivEmp() ), .t. ) }
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nWidth           := 80
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Div."
      :bEditValue       := {|| cSimDiv( if( lEur, cDivChg(), ( D():FacturasProveedoresPagos( nView ) )->cDivPgo ), D():Divisas( nView ) ) }
      :nWidth           := 30
   end with

   with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():FacturasProveedoresPagos( nView ) )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

   oWndBrw:lAutoSeek    := .f.
   oWndBrw:cHtmlHelp    := "Recibo de proveedor"

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

   DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oImp RESOURCE "IMP", "IMPDOC2" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenRecPrv( IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

   lGenRecPrv( oWndBrw:oBrw, oImp, IS_PRINTER )

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenRecPrv( IS_SCREEN ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

   lGenRecPrv( oWndBrw:oBrw, oPrv, IS_SCREEN )

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenRecPrv( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenRecPrv( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenRecPrv( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenRecPrv( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   #ifndef __TACTIL__

   DEFINE BTNSHELL RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( InfPrevisionPagos():New( "Listado de previsión de pagos" ):Play() ) ;
      TOOLTIP  "Pre(v)isión";
      HOTKEY   "V";
      LEVEL    ACC_ZOOM

   #endif

   DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw GROUP ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Pagar" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TraRecPrv( oWndBrw:oBrw ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TraRecPrv( oWndBrw:oBrw, "Cambiar estado de recibos", "Contabilizado", .t. ) ) ;
         TOOLTIP  "Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEur := !lEur, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, D():FacturasProveedoresPagos( nView ), aItmRecPrv() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

   end if

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )

   end if

   DEFINE BTNSHELL RESOURCE "Sel" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( FilterRecibos( .t. ) );
      TOOLTIP  "Solo cob(r)ados" ;
      HOTKEY   "R";

   DEFINE BTNSHELL RESOURCE "Cnt" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( FilterRecibos( .f. ) );
      TOOLTIP  "Solo (p)endientes" ;
      HOTKEY   "P";

   DEFINE BTNSHELL RESOURCE "gc_undo_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( FilterRecibos() );
      TOOLTIP  "Solo de(v)ueltos" ;
      HOTKEY   "V";

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_BUSINESSMAN_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtPrv( ( D():FacturasProveedoresPagos( nView ) )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfProveedor( ( D():FacturasProveedoresPagos( nView ) )->cCodPrv ) );
         TOOLTIP  "Informe proveedor" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_BUSINESSMAN_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ZooFacPrv( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac ) );
         TOOLTIP  "Visualizar factura" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmRecPrv() )
      oWndBrw:oActiveFilter:SetFilterType( REC_PRV )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if isArray( aNumRec ) .and. !empty( aNumRec[ 1 ] )
         externalPago( aNumRec )
      end if

   end if 

Return .t.

//--------------------------------------------------------------------------//

Static Function ExternalPago( aNumRec )

   local nOrdAnt  := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( "nNumFac" ) )

   if ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( aNumRec[ 1 ] ) ) .and. !empty( oWndBrw )
      oWndBrw:Refresh()
      oWndBrw:RecEdit()
   end if

   ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( nOrdAnt ) )

   aNumRec        := Array( 1 )

Return .t.

//--------------------------------------------------------------------------//

Static Function lValCheck( aGet, aTmp )

   if aTmp[ _LCOBRADO ]
      aGet[ _DENTRADA ]:cText( GetSysDate() )
      aGet[ _CTURREC  ]:cText( cCurSesion( nil, .f. ) )
      aGet[ _CCODCAJ  ]:cText( Application():CodigoCaja() )      
      aGet[ _CCODCAJ  ]:lValid()
   else
      aGet[ _DENTRADA ]:cText( Ctod( "" ) )
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function EdtPag( aTmp, aGet, dbf, oBrw, lRectificativa, bValid, nMode )

   local oDlg
   local oBmpDiv
   local oGetCaj
   local cGetCaj
   local oGetSubCta
   local cGetSubCta
   local cPirDiv           := cPirDiv( aTmp[ _CDIVPGO ], D():Divisas( nView ) )
   local nDinDiv           := nRinDiv( aTmp[ _CDIVPGO ], D():Divisas( nView ) )
   local oFld
   local oBmpGeneral
   local oBmpDevolucion
   local oBmpBancos

   if empty( aTmp[ _CCODCAJ ] )
      aTmp[ _CCODCAJ ]     := Application():CodigoCaja()
   end if

   if empty( aTmp[ _CPAISIBAN ] )
      aTmp[ _CPAISIBAN ]   := "ES"
   end if

   lOldDevuelto            := aTmp[ _LDEVUELTO ]

   DEFINE DIALOG oDlg RESOURCE "Recibos" TITLE "Recibos de proveedor"

      REDEFINE FOLDER oFld ;
         ID       500;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Bancos",;
                  "Devolución" ;
         DIALOGS  "RecibosProveedoresGeneral",;
                  "RecibosProveedoresBancos",;
                  "Recibos_2"

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_money2_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DPRECOB ] VAR aTmp[ _DPRECOB ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DPRECOB ]:cText( Calendario( aTmp[ _DPRECOB ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DFECVTO ] VAR aTmp[ _DFECVTO ] ;
         ID       250 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DFECVTO ]:cText( Calendario( aTmp[ _DFECVTO ] ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DENTRADA ] VAR aTmp[ _DENTRADA ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DENTRADA ]:cText( Calendario( aTmp[ _DENTRADA ] ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODPRV ] VAR aTmp[ _CCODPRV ] ;
         ID       120 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CNOMPRV ] VAR aTmp[ _CNOMPRV ];
         ID       121 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CTURREC ] VAR aTmp[ _CTURREC ] ;
         ID       335 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
         ID       310 ;
         IDTEXT   311 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ _CCODPGO ], D():FormasPago( nView ), aGet[ _CCODPGO ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], aGet[ _CCODPGO ]:oHelpText ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDESCRIP ] VAR aTmp[ _CDESCRIP ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CPGDOPOR ] VAR aTmp[ _CPGDOPOR ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NIMPORTE ] VAR aTmp[ _NIMPORTE ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( cPirDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LRECIMP ] VAR aTmp[ _LRECIMP ];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       161 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       162 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDIVPGO ] VAR aTmp[ _CDIVPGO ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], @cPirDiv, @nDinDiv, nil, nil, nil, nil, nil, D():Divisas( nView ), oBandera ) );
         PICTURE  "@!";
         ID       170 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], D():Divisas( nView ), oBandera ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE BITMAP oBmpDiv ;
         ID       171;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LCOBRADO ] VAR aTmp[ _LCOBRADO ];
         ID       220 ;
         ON CHANGE( lValCheck( aGet, aTmp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      REDEFINE CHECKBOX aGet[ _LNOTARQUEO ] VAR aTmp[ _LNOTARQUEO ];
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCTAREC ] VAR aTmp[ _CCTAREC ] ;
         ID       240 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAREC ], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAREC ], { aTmp[ _CCTAREC ] }, oGetSubCta ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       260 ;
         IDTEXT   261 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpBancos ;
         ID       500 ;
         RESOURCE "gc_central_bank_euro_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Bnco de empresa----------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBNCEMP ] VAR aTmp[ _CBNCEMP ];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ _CBNCEMP ], aGet[ _CEPAISIBAN ], aGet[ _CECTRLIBAN ], aGet[ _CENTEMP ], aGet[ _CSUCEMP ], aGet[ _CDIGEMP ], aGet[ _CCTAEMP ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CEPAISIBAN ] VAR aTmp[ _CEPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CECTRLIBAN ] VAR aTmp[ _CECTRLIBAN ] ;
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTEMP ] VAR aTmp[ _CENTEMP ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCEMP ] VAR aTmp[ _CSUCEMP ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGEMP ] VAR aTmp[ _CDIGEMP ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAEMP ] VAR aTmp[ _CCTAEMP ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lIbanDigit( aTmp[ _CEPAISIBAN ], aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CECTRLIBAN ] ),;
                     aGet[ _CEPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      /*
      Bnco de proveedor--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBNCPRV ] VAR aTmp[ _CBNCPRV ];
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncPrv( aGet[ _CBNCPRV ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTPRV ], aGet[ _CSUCPRV ], aGet[ _CDIGPRV ], aGet[ _CCTAPRV ], aTmp[ _CCODPRV ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTPRV ], aTmp[ _CSUCPRV ], aTmp[ _CDIGPRV ], aTmp[ _CCTAPRV ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTPRV ], aTmp[ _CSUCPRV ], aTmp[ _CDIGPRV ], aTmp[ _CCTAPRV ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTPRV ] VAR aTmp[ _CENTPRV ];
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTPRV ], aTmp[ _CSUCPRV ], aTmp[ _CDIGPRV ], aTmp[ _CCTAPRV ], aGet[ _CDIGPRV ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCPRV ] VAR aTmp[ _CSUCPRV ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTPRV ], aTmp[ _CSUCPRV ], aTmp[ _CDIGPRV ], aTmp[ _CCTAPRV ], aGet[ _CDIGPRV ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGPRV ] VAR aTmp[ _CDIGPRV ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTPRV ], aTmp[ _CSUCPRV ], aTmp[ _CDIGPRV ], aTmp[ _CCTAPRV ], aGet[ _CDIGPRV ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAPRV ] VAR aTmp[ _CCTAPRV ];
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTPRV ], aTmp[ _CSUCPRV ], aTmp[ _CDIGPRV ], aTmp[ _CCTAPRV ], aGet[ _CDIGPRV ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      /*
      Tercera Caja de Diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpDevolucion ;
         ID       500 ;
         RESOURCE "gc_money2_delete_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE CHECKBOX aGet[ _LDEVUELTO ] VAR aTmp[ _LDEVUELTO ];
         ID       100 ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( startEdtPag( aGet, aTmp, .f. ) ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _DFECDEV ] VAR aTmp[ _DFECDEV ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CMOTDEV ] VAR aTmp[ _CMOTDEV ] ;
         ID       120 ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CRECDEV ] VAR aTmp[ _CRECDEV ] ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbf, oBrw, oDlg, nDinDiv, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )


   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbf, oBrw, oDlg, nDinDiv, nMode ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp ("Pagos") } )

   oDlg:bStart    := {|| startEdtPag( aGet, aTmp, .t. ) }

   ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT ( EdtRecMenu( aTmp, oDlg ) )

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

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, dbf, oBrw, oDlg, nDinDiv, nMode )

   local nImp
   local nCon
   local nRec        := ( dbf )->( Recno() )
   local lImpNeg     := ( dbf )->nImporte < 0
   local nImpFld     := round( abs( ( dbf )->nImporte ), nDinDiv )
   local nImpTmp     := round( abs( aTmp[ _NIMPORTE ] ), nDinDiv )
   local cNumFac     := aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
   local cNumRec     := aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] + Str( aTmp[ _NNUMREC ] )
   local lDevuelto   := aTmp[ _LDEVUELTO ]
   local aTabla
   local nOrdAnt

   /*
   El importe no puede ser mayor q el importe anterior
   */

   if nImpTmp > nImpFld
      msgStop( "El importe no puede ser superior al actual." )
      return nil
   end if

   if !lExisteTurno( aGet[ _CTURREC ]:VarGet() )
      msgStop( "La sesión introducida no existe." )
      aGet[ _CTURREC ]:SetFocus()
      return nil
   end if

   oDlg:Disable()

   aTmp[ _DFECCHG ]  := GetSysDate()
   aTmp[ _CTIMCHG ]  := Time()

   /*
   Comprobamos q los importes sean distintos
   */

   if nImpFld != nImpTmp

      /*
      El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
      */

      nImp                          := ( nImpFld - nImpTmp ) * if( lImpNeg, - 1 , 1 )

      /*
      Obtnenemos el nuevo numero del contador
      */

      nCon                          := nNewReciboProveedor( aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], aTmp[ _CTIPREC ], D():FacturasProveedoresPagos( nView ) )

      /*
      Añadimos el nuevo recibo
      */

      ( dbf )->( dbAppend() )
      ( dbf )->cSerFac       := aTmp[ _CSERFAC ]
      ( dbf )->nNumFac       := aTmp[ _NNUMFAC ]
      ( dbf )->cSufFac       := aTmp[ _CSUFFAC ]
      ( dbf )->nNumRec       := nCon
      ( dbf )->dEntrada      := Ctod( "" )
      ( dbf )->nImporte      := nImp
      ( dbf )->cDescrip      := "Recibo nº" + AllTrim( Str( nCon ) ) + " de factura " + aTmp[ _CSERFAC ] + '/' + AllTrim( Str( aTmp[ _NNUMFAC ] ) ) + '/' + aTmp[ _CSUFFAC ]
      ( dbf )->dPreCob       := GetSysDate()
      ( dbf )->cPgdoPor      := ""
      ( dbf )->lCobrado      := .f.
      ( dbf )->cDivPgo       := aTmp[ _CDIVPGO ]
      ( dbf )->nVdvPgo       := aTmp[ _NVDVPGO ]
      ( dbf )->cCodPrv       := aTmp[ _CCODPRV ]
      ( dbf )->cNomPrv       := aTmp[ _CNOMPRV ]
      ( dbf )->cCodPgo       := aTmp[ _CCODPGO ] 
      ( dbf )->lConPgo       := .f.
      ( dbf )->cTurRec       := cCurSesion()
      ( dbf )->lCloPgo       := .f.
      ( dbf )->( dbUnLock() )

   end if

   ( dbf )->( DbGoTo( nRec ) )

   /*
   Grabamos el registro--------------------------------------------------------
   */

   WinGather( aTmp, aGet, dbf, oBrw, nMode, , .f. )

   /*
   Si es Devuelto creamos el tiket nuevo---------------------------------------
   */

   nRec     := ( dbf )->( Recno() )

   if lOldDevuelto != lDevuelto

      if lDevuelto

         nOrdAnt                        := ( dbf )->( OrdSetFocus( "nNumFac" ) )

         if ( dbf )->( dbSeek( cNumRec ) )
            aTabla                      := DBScatter( dbf )
         end if

         nCon                           := nNewReciboProveedor( aTabla[ _CSERFAC ] + Str( aTabla[ _NNUMFAC ] ) + aTabla[ _CSUFFAC ], aTabla[ _CTIPREC ], dbf )

         if aTabla != nil

            ( dbf )->( dbAppend() )
            ( dbf )->cSerFac     := aTabla[ _CSERFAC ]
            ( dbf )->nNumFac     := aTabla[ _NNUMFAC ]
            ( dbf )->cSufFac     := aTabla[ _CSUFFAC ]
            ( dbf )->nNumRec     := nCon
            ( dbf )->cTipRec     := aTabla[ _CTIPREC ]
            ( dbf )->cCodCaj     := aTabla[ _CCODCAJ ]
            ( dbf )->cCodPrv     := aTabla[ _CCODPRV ]
            ( dbf )->cNomPrv     := aTabla[ _CNOMPRV ]
            ( dbf )->nImporte    := aTabla[ _NIMPORTE ]
            ( dbf )->cDescrip    := "Recibo Nº" + AllTrim( Str( nCon ) ) + " generado de la devolución del recibo " + aTabla[ _CSERFAC ] + "/" + AllTrim( Str( aTabla[ _NNUMFAC ] ) ) + "/" + aTabla[ _CSUFFAC ] + " - " + AllTrim( Str( aTabla[ _NNUMREC ] ) )
            ( dbf )->dPreCob     := GetSysDate()
            ( dbf )->cDivPgo     := aTabla[ _CDIVPGO ]
            ( dbf )->nVdvPgo     := aTabla[ _NVDVPGO ]
            ( dbf )->dFecVto     := GetSysDate()
            ( dbf )->cCodUsr     := Auth():Codigo() 
            ( dbf )->dFecChg     := GetSysDate()
            ( dbf )->cTimChg     := Time()
            ( dbf )->cTurRec     := cCurSesion()
            ( dbf )->cCodPgo     := aTabla[ _CCODPGO ]
            ( dbf )->cRecDev     := cNumRec
            ( dbf )->( dbUnLock() )

         end if

         ( dbf )->( OrdSetFocus( nOrdAnt ) )

      else

         nOrdAnt                        := ( dbf )->( OrdSetFocus( "cRecDev" ) )

         if ( dbf )->( dbSeek( cNumRec ) ) .and. dbDialogLock( dbf )
            ( dbf )->( dbDelete() )
            ( dbf )->( dbUnLock() )
         end if

         ( dbf )->( OrdSetFocus( nOrdAnt ) )

      end if

   end if

   ( dbf )->( dbGoTo( nRec ) )

   /*
   Comprobamos el estado de la factura---------------------------------------
   */

   if ( D():FacturasProveedores( nView ) )->( dbSeek( cNumFac ) )
      ChkLqdFacPrv( nil, D():FacturasProveedores( nView ), D():FacturasProveedoresLineas( nView ), D():FacturasProveedoresPagos( nView ), D():TiposIva( nView ), D():Divisas( nView ) )
   end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oDlg:Enable()

   oDlg:end( IDOK )

return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oRad
   local nRad        := 1
   local oSerIni
   local oSerFin
   local oFmtRec
   local cFmtRec     := cSelPrimerDoc( "RP" )
   local oSayRec
   local cSayRec
   local oNotRem
   local lNotRem     := .f.
   local lNotImp     := .f.
   local lNotCob     := .f.
   local oCodPgo
   local cCodPgo     := Space( 3 )
   local oTxtPgo
   local cTxtPgo     := ""
   local nRecno      := ( D():FacturasProveedoresPagos( nView ) )->( recno() )
   local nOrdAnt     := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( 1 ) )
   local dFecIni     := CtoD( "01/" + Str( Month( GetSysDate() ), 2 ) + "/" + Str( Year( Date() ) ) )
   local dFecFin     := GetSysDate()
   local cSerIni     := ( D():FacturasProveedoresPagos( nView ) )->cSerFac
   local cSerFin     := ( D():FacturasProveedoresPagos( nView ) )->cSerFac
   local nDocIni     := ( D():FacturasProveedoresPagos( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasProveedoresPagos( nView ) )->nNumFac
   local cSufIni     := ( D():FacturasProveedoresPagos( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasProveedoresPagos( nView ) )->cSufFac
   local nNumIni     := ( D():FacturasProveedoresPagos( nView ) )->nNumRec
   local nNumFin     := ( D():FacturasProveedoresPagos( nView ) )->nNumRec
   local nCopPrn     := 1
   local oPrinter
   local cPrinter    := PrnGetName()
   local lInvOrden   := .f.

   cSayRec           := cNombreDoc( cFmtRec )

   DEFINE DIALOG oDlg RESOURCE "IMPSERREC"

   REDEFINE RADIO oRad VAR nRad ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE GET oFmtRec VAR cFmtRec ;
      ID       100 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtRec, oSayRec, D():Documentos( nView ) ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtRec, oSayRec, "RP" ) ) ;
      OF       oDlg

   REDEFINE GET oSayRec VAR cSayRec ;
      ID       101 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
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
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       190 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

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

   REDEFINE GET nCopPrn;
      ID       260 ;
      VALID    nCopPrn > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       320 ;
      OF       oDlg

   TBtnBmp():ReDefine( 321, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE CHECKBOX lInvOrden ;
      ID       500 ;
      OF       oDlg

   /*
   Formas de pago_____________________________________________________________________
   */

   REDEFINE GET oCodPgo VAR cCodPgo;
      ID       210 ;
      PICTURE  "@!" ;
      VALID    ( cFPago( oCodPgo, D():FormasPago( nView ), oTxtPgo ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFPago( oCodPgo, oTxtPgo ) );
      OF       oDlg

   REDEFINE GET oTxtPgo VAR cTxtPgo;
      ID       220 ;
      WHEN     .F. ;
      COLOR    CLR_GET ;
      OF       oDlg

   REDEFINE CHECKBOX oNotRem VAR lNotRem;
      ID       230 ;
		OF 		oDlg

   REDEFINE CHECKBOX lNotImp;
      ID       240 ;
		OF 		oDlg

   REDEFINE CHECKBOX lNotCob;
      ID       250 ;
		OF 		oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni, 2 ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, oDlg, nCopPrn, cPrinter, lInvOrden ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni, 2 ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, oDlg, nCopPrn, cPrinter, lInvOrden ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oNotRem:Hide() )

   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasProveedoresPagos( nView ) )->( ordSetFocus( nOrdAnt ) )

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cCodDoc, nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodPgo, lNotRem, lNotImp, lNotCob, oDlg, nCopPrn, cPrinter, lInvOrden )

   local nOrd
   local nImpYet     := 1

   DEFAULT nCopPrn   := 1

   if empty( cCodDoc )
      return nil
   end if

   oDlg:disable()

   if !lInvOrden

      if nRad == 1
         nOrd        := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( "DENTRADA" ) )
         ( D():FacturasProveedoresPagos( nView ) )->( DbSeek( dFecIni, .t. ) )
      else
         nOrd        := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( "NNUMFAC" ) )
         ( D():FacturasProveedoresPagos( nView ) )->( DbSeek( cDocIni, .t. ) )
      end if

      while !( D():FacturasProveedoresPagos( nView ) )->( eof() )

         if (  if( nRad == 1, ( ( D():FacturasProveedoresPagos( nView ) )->dEntrada >= dFecIni .and. ( D():FacturasProveedoresPagos( nView ) )->dEntrada <= dFecFin ), .t. )                  .and. ;
               if( nRad == 2, ( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ) >= cDocIni           .and. ;
                                ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ) <= cDocFin ), .t. )  .and. ;
               if( !empty( cCodPgo ), cCodPgo == cPgoFacPrv( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac, 9 ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac, D():FacturasProveedores( nView ) ), .t. ) .and. ;
               if( lNotImp, !( D():FacturasProveedoresPagos( nView ) )->lRecImp, .t. )                                                                             .and. ;
               if( lNotCob, !( D():FacturasProveedoresPagos( nView ) )->lCobrado, .t. ) )

            while nImpYet <= nCopPrn
               GenRecPrv( IS_PRINTER, "Imprimiendo recibo : " + ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac, , cPrinter )
               nImpYet++
            end while

         end if

         nImpYet := 1
         ( D():FacturasProveedoresPagos( nView ) )->( dbSkip( 1 ) )

      end while

      ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( nOrd ) )

   else

      if nRad == 1
         nOrd        := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( "DENTRADA" ) )
         ( D():FacturasProveedoresPagos( nView ) )->( DbSeek( dFecFin ) )
      else
         nOrd        := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( "NNUMFAC" ) )
         ( D():FacturasProveedoresPagos( nView ) )->( DbSeek( cDocFin ) )
      end if

      while !( D():FacturasProveedoresPagos( nView ) )->( Bof() )

         if (  if( nRad == 1, ( ( D():FacturasProveedoresPagos( nView ) )->dEntrada >= dFecIni .and. ( D():FacturasProveedoresPagos( nView ) )->dEntrada <= dFecFin ), .t. )                  .and. ;
               if( nRad == 2, ( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac >= cDocIni           .and. ;
                                ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac <= cDocFin ), .t. )  .and. ;
               if( !empty( cCodPgo ), cCodPgo == cPgoFacPrv( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac, 9 ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac, D():FacturasProveedores( nView ) ), .t. ) .and. ;
               if( lNotImp, !( D():FacturasProveedoresPagos( nView ) )->lRecImp, .t. )                                                                             .and. ;
               if( lNotCob, !( D():FacturasProveedoresPagos( nView ) )->lCobrado, .t. ) )

               while nImpYet <= nCopPrn
                  GenRecPrv( IS_PRINTER, "Imprimiendo recibo : " + ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac, , cPrinter )
                  nImpYet++
               end while

         end if

         nImpYet := 1

         ( D():FacturasProveedoresPagos( nView ) )->( dbSkip( - 1 ) )

      end while

      ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( nOrd ) )

   end if

   oDlg:enable()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION GenRecPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo recibos"
   DEFAULT nCopies      := 1
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():FacturasProveedoresPagos( nView ) )->cSerFac, "nRecPrv", D():Contadores( nView ) )

   if empty( cCodDoc )
      cCodDoc           := cFirstDoc( "RP", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )

      PrintReportRecPrv( nDevice, nCopies, cPrinter, D():Documentos( nView ) )

   else

      private cDbf         := D():FacturasProveedores( nView )
      private cDbfCol      := D():FacturasProveedoresLineas( nView )
      private cDbfRec      := D():FacturasProveedoresPagos( nView )
      private cDbfPrv      := D():Proveedores( nView )
      private cDbfPgo      := D():FormasPago( nView )
      private cDbfDiv      := D():Divisas( nView )
      private cPirDivRec   := cPorDiv( ( D():FacturasProveedoresPagos( nView ) )->cDivPgo, D():Divisas( nView ) )

      ( D():FacturasProveedores( nView ))->( dbSeek( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac ) )
      ( D():Proveedores( nView )    )->( dbSeek( ( D():FacturasProveedores( nView ) )->cCodPrv ) )
      ( D():FormasPago( nView )  )->( dbSeek( ( D():FacturasProveedores( nView ) )->cCodPago) )

      if !empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      if !empty( oInf ) .and. oInf:lCreated

         oInf:lFinish            := .f.
         oInf:lNoCancel          := .t.
         oInf:bSkip              := {|| ( D():FacturasProveedoresPagos( nView ) )->( dbSkip() ) }

         oInf:oDevice:lPrvModal  := .t.

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

      if !empty( oInf )

         ACTIVATE REPORT oInf WHILE ( .f. ) ON ENDPAGE ( eItems( oInf ) )

         if nDevice == IS_PRINTER
            oInf:oDevice:end()
         end if

      end if

      oInf                 := nil

   end if

   //Marca para ya impreso

   if nDevice == IS_PRINTER .and. dbDialogLock( D():FacturasProveedoresPagos( nView ) )
      ( D():FacturasProveedoresPagos( nView ) )->lRecImp := .t.
      ( D():FacturasProveedoresPagos( nView ) )->dFecImp := GetSysDate()
      ( D():FacturasProveedoresPagos( nView ) )->cHorImp := SubStr( Time(), 1, 5 )
      ( D():FacturasProveedoresPagos( nView ) )->( dbUnLock() )
   end if

   /*
   Refrescamos la pantalla principal-------------------------------------------
   */

   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION eItems( oInf )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

	/*
	Reposicionamos en las distintas areas
	*/

   IF ( D():FacturasProveedoresPagos( nView ) )->cSerFac == "A"
      PrintItems( "RPA", oInf )
	ELSE
      PrintItems( "RPB", oInf )
	END IF

RETURN NIL

//-------------------------------------------------------------------------//

/*
Cambia el estado de un recibo
*/

STATIC FUNCTION ChgState( lState )

   DEFAULT lState := !( D():FacturasProveedoresPagos( nView ) )->lConPgo

   if ( D():FacturasProveedoresPagos( nView ) )->lConPgo != lState .and. dbLock( D():FacturasProveedoresPagos( nView ) )
      ( D():FacturasProveedoresPagos( nView ) )->lConPgo := lState
      ( D():FacturasProveedoresPagos( nView ) )->( dbUnLock() )
   end if

RETURN NIL

//-------------------------------------------------------------------------//

STATIC FUNCTION PasRec( cDocIni, cDocFin, nRad, cTipo, lSimula, lChgState, oBrw, oDlg, oTree, oMtrInf, oBtnCancel )

   local aPos
   local lWhile      := .t.
   local bWhile
   local aSimula     := {}
   local nOrden      := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( "nNumFac" ) )
   local nRecno      := ( D():FacturasProveedoresPagos( nView ) )->( Recno() )
   local lReturn

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lSimula
      aPos              := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   oDlg:Disable()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   oTree:Enable()
   oTree:DeleteAll()

   if nRad == 1

      ( D():FacturasProveedoresPagos( nView ) )->( dbGoTop() )

      bWhile         := {||   lWhile .and. !( D():FacturasProveedoresPagos( nView ) )->( eof() ) }

   else

      ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( cDocIni, .t. ) )

      bWhile         := {||   lWhile                                                                                                                         .and. ;
                              ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ) >= cDocIni .and. ;
                              ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ) <= cDocFin .and. ;
                              !( D():FacturasProveedoresPagos( nView ) )->( eof() ) }

   end if

   oMtrInf:Set( ( D():FacturasProveedoresPagos( nView ) )->( OrdKeyNo() ) )

   while ( Eval( bWhile ) )

      do case
         case ( cTipo == "Facturas" .or. cTipo == "Todas" )       .and. empty( ( D():FacturasProveedoresPagos( nView ) )->cTipRec )

            if lChgState
               lReturn  := ChgState( lSimula )
            else
               lReturn  := CntRecPrv( lSimula, oTree, nil, aSimula, .f., D():FacturasProveedores( nView ), D():FacturasProveedoresPagos( nView ), D():Proveedores( nView ), D():FormasPago( nView ), D():Divisas( nView ) )
            end if

         case ( cTipo == "Rectificativas" .or. cTipo == "Todas" ) .and. !empty( ( D():FacturasProveedoresPagos( nView ) )->cTipRec )

            if lChgState
               lReturn  := ChgState( lSimula )
            else
               lReturn  := CntRecPrv( lSimula, oTree, nil, aSimula, .f., D():FacturasRectificativasProveedores( nView ), D():FacturasProveedoresPagos( nView ), D():Proveedores( nView ), D():FormasPago( nView ), D():Divisas( nView ) )
            end if

      end case

      if IsFalse( lReturn )
         exit
      end if

      ( D():FacturasProveedoresPagos( nView ) )->( dbSkip() )

      oMtrInf:Set( ( D():FacturasProveedoresPagos( nView ) )->( OrdKeyNo() ) )

   end do

   oMtrInf:Set( ( D():FacturasProveedoresPagos( nView ) )->( OrdKeyCount() ) )

   ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( nOrden ) )
   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTo( nRecno ) )

   oBtnCancel:bAction   := {|| oDlg:End() }

   if lSimula
      WndCenter( oDlg:hWnd )
   end if

   oDlg:Enable()

Return nil

//------------------------------------------------------------------------//

static function ImpPrePago()

   local oDlg
   local oDesde
   local oHasta
   local oPrvDesde
   local oPrvHasta
   local oNomPrvDesde
   local oNomPrvHasta
   local cPrvDesde      := dbFirst( D():Proveedores( nView ) )
   local cPrvHasta      := dbLast( D():Proveedores( nView ) )
   local cNomPrvDesde   := dbFirst( D():Proveedores( nView ), 2 )
   local cNomPrvHasta   := dbFirst( D():Proveedores( nView ), 2 )
   local dDesde         := BoM( GetSysDate() ) 
   local dHasta         := EoM( GetSysDate() ) 
   local cTitulo        := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )
   local cSubTitulo     := Padr( "Previsión de pagos", 50 )

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_PREPAGOS"

      REDEFINE GET oDesde VAR dDesde;
         SPINNER ;
         ID       100 ;
         OF       oDlg

      REDEFINE GET oHasta VAR dHasta;
         SPINNER ;
         ID       110 ;
         OF       oDlg

      REDEFINE GET oPrvDesde VAR cPrvDesde;
         ID       120 ;
         COLOR    CLR_GET ;
         VALID    ( cProvee( oPrvDesde, D():Proveedores( nView ), oNomPrvDesde ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( oPrvDesde, oNomPrvDesde ) ) ;
         OF       oDlg

      REDEFINE GET oNomPrvDesde VAR cNomPrvDesde ;
         WHEN     .F. ;
         COLOR    CLR_GET ;
         ID       121 ;
         OF       oDlg

      REDEFINE GET oPrvHasta VAR cPrvHasta;
         ID       130 ;
         COLOR    CLR_GET ;
         VALID    ( cProvee( oPrvHasta, D():Proveedores( nView ), oNomPrvHasta ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( oPrvHasta, oNomPrvHasta ) ) ;
         OF       oDlg

      REDEFINE GET oNomPrvHasta VAR cNomPrvHasta ;
         WHEN     .F. ;
         COLOR    CLR_GET ;
         ID       131 ;
         OF       oDlg

		REDEFINE GET cTitulo ;
			ID 		160 ;
			OF 		oDlg

		REDEFINE GET cSubTitulo ;
			ID 		170 ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       508;
			OF 		oDlg ;
         ACTION   PrnPrePago( dDesde, dHasta, cPrvDesde, cPrvHasta, cTitulo, cSubTitulo, 1 )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   PrnPrePago( dDesde, dHasta, cPrvDesde, cPrvHasta, cTitulo, cSubTitulo, 2 )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function PrnPrePago( dDesde, dHasta, cPrvDesde, cPrvHasta, cTitulo, cSubTitulo, nDevice )

   local oReport
   local nRecno   := ( D():FacturasProveedoresPagos( nView ) )->( Recno() )
   local oFont1   := TFont():New( "Courier New", 0, -12, .F., .T. )
   local oFont2   := TFont():New( "Courier New", 0, -12, .F., .f. )

   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTop() )

   IF nDevice == 1

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
         FONT     oFont1, oFont2 ;
         HEADER   "Periodo   : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Proveedor : " + rtrim( cPrvDesde ) + " -> " + rtrim( cPrvHasta ),;
                  "Fecha     : " + dToc( Date() ) LEFT ;
         FOOTER   "Página    : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  cSubTitulo;
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
         HEADER   "Periodo   : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Proveedor : " + rtrim( cPrvDesde ) + " -> " + rtrim( cPrvHasta ),;
                  "Fecha     : " + dToc( Date() ) LEFT ;
         FOOTER   "Página    : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  cSubTitulo;
         TO PRINTER

	END IF

   COLUMN TITLE   "N. Recibo" ;
         DATA     (D():FacturasProveedoresPagos( nView ))->cSerFac + "/" + AllTrim( Str( (D():FacturasProveedoresPagos( nView ))->nNumFac ) ) + "/" + (D():FacturasProveedoresPagos( nView ))->cSufFac + "-" + AllTrim( Str( (D():FacturasProveedoresPagos( nView ))->nNumRec ) ) ;
         SIZE     18 ;
         FONT     2

   COLUMN TITLE   "F. Previs." ;
         DATA     DtoC( (D():FacturasProveedoresPagos( nView ))->DPRECOB );
         SIZE     10 ;
         FONT     2

   COLUMN TITLE   "Descripción" ;
         DATA     (D():FacturasProveedoresPagos( nView ))->CDESCRIP;
         SIZE     30 ;
         FONT     2

   COLUMN TITLE   "Importe" ;
         DATA     (D():FacturasProveedoresPagos( nView ))->nImporte / (D():FacturasProveedoresPagos( nView ))->nVdvPgo ;
         PICTURE  cPirDiv( (D():FacturasProveedoresPagos( nView ))->cDivPgo, D():Divisas( nView ) ) ;
         SIZE     12 ;
			TOTAL ;
			FONT 		2

	END REPORT

   IF !empty( oReport ) .and.  oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:bSkip := {|| ( D():FacturasProveedoresPagos( nView ) )->( dbSkip() ) }
   END IF

	ACTIVATE REPORT oReport	;
      FOR   ( D():FacturasProveedoresPagos( nView ) )->DPRECOB >= dDesde                .AND. ;
            ( D():FacturasProveedoresPagos( nView ) )->DPRECOB <= dHasta                .AND. ;
            cCodFacPrv( (D():FacturasProveedoresPagos( nView ))->cSerFac + Str( (D():FacturasProveedoresPagos( nView ))->nNumFac ) + (D():FacturasProveedoresPagos( nView ))->cSufFac, D():FacturasProveedores( nView ) ) >= cPrvDesde  .AND. ;
            cCodFacPrv( (D():FacturasProveedoresPagos( nView ))->cSerFac + Str( (D():FacturasProveedoresPagos( nView ))->nNumFac ) + (D():FacturasProveedoresPagos( nView ))->cSufFac, D():FacturasProveedores( nView ) ) <= cPrvHasta  .AND. ;
            empty( ( D():FacturasProveedoresPagos( nView ) )->dEntrada )                        ;
      WHILE !( D():FacturasProveedoresPagos( nView ) )->( eof() )

	oFont1:end()
	oFont2:end()

   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTo( nRecno ) )

RETURN NIL

//---------------------------------------------------------------------------//

static function lLiquida( oBrw )

   if !( D():FacturasProveedoresPagos( nView ) )->lCobrado
      if ( D():FacturasProveedoresPagos( nView ) )->( dbRLock() )
         ( D():FacturasProveedoresPagos( nView ) )->lCobrado   := .t.
         ( D():FacturasProveedoresPagos( nView ) )->dEntrada   := GetSysDate()
         ( D():FacturasProveedoresPagos( nView ) )->cTurRec    := cCurSesion()
         ( D():FacturasProveedoresPagos( nView ) )->( dbUnLock() )
      end if
   else
      msgStop( "Recibo ya cobrado" )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

return nil

//---------------------------------------------------------------------------//

static function lGenRecPrv( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   IF !( D():Documentos( nView ) )->( dbSeek( "RP" ) )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay recibos de clientes predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->CTIPO == "RP" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenRecPrv( nDevice, ( D():Documentos( nView ) )->Codigo, "Imprimiendo recibos de clientes" )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      END DO

   END IF

return nil

//---------------------------------------------------------------------------//

static function bGenRecPrv( nDevice, cCodDoc, cTitle )

   local nDev  := by( nDevice )
   local cCod  := by( cCodDoc )
   local cTit  := by( cTitle  )

return {|| GenRecPrv( nDev, cTit, cCod ) }

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Visualizar factura";
            MESSAGE  "Visualiza la factura de la que procede" ;
            RESOURCE "gc_document_text_businessman_16" ;
            ACTION   ( ZooFacPrv( aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] ) )

            SEPARATOR

            MENUITEM "&2. Modificar proveedor";
            MESSAGE  "Modifica el proveedor de la factura" ;
            RESOURCE "Businessman_16";
            ACTION   ( EdtPrv( aTmp[ _CCODPRV ] ) )

            MENUITEM "&3. Informe proveedor";
            MESSAGE  "Informe del proveedor de la factura" ;
            RESOURCE "Info16";
            ACTION   ( InfProveedor( aTmp[ _CCODPRV ] ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return ( oMenu:End() )

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Recibos", ( D():FacturasProveedoresPagos( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Recibos", cItemsToReport( aItmRecPrv() ) )

   oFr:SetWorkArea(     "Facturas", ( D():FacturasProveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacPrv() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Bancos", ( D():BancosProveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aPrvBnc() ) )

   oFr:SetMasterDetail( "Recibos", "Facturas",                 {|| ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Empresa",                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Recibos", "Proveedor",                {|| ( D():FacturasProveedoresPagos( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Recibos", "Formas de pago",           {|| ( D():FacturasProveedoresPagos( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Recibos", "Bancos",                   {|| ( D():FacturasProveedoresPagos( nView ) )->cCodPrv } )

   oFr:SetResyncPair(   "Recibos", "Facturas" )
   oFr:SetResyncPair(   "Recibos", "Empresa" )
   oFr:SetResyncPair(   "Recibos", "Proveedor" )
   oFr:SetResyncPair(   "Recibos", "Formas de pago" )
   oFr:SetResyncPair(   "Recibos", "Bancos" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Recibos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Recibos", "Total factura",               "CallHbFunc('nTotFactProvee')" )
   oFr:AddVariable(     "Recibos", "Importe formato texto",       "CallHbFunc('cTxtRecPrv')" )
   oFr:AddVariable(     "Recibos", "Mes creación recibo",         "CallHbFunc('cMonthFecEnt')" )
   oFr:AddVariable(     "Recibos", "Mes vencimiento recibo",      "CallHbFunc('cMonthFecVto')" )
   oFr:AddVariable(     "Recibos", "Cuenta bancaria proveedor",   "CallHbFunc('cCtaRecPrv')" )

Return nil

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( D():FacturasProveedoresPagos( nView ) )
      CreateUserFilter( "", D():FacturasProveedoresPagos( nView ), .f., , , "all" )
   else
      DestroyFastFilter( D():FacturasProveedoresPagos( nView ) )
      CreateUserFilter( "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox(), D():FacturasProveedoresPagos( nView ), .f., , , "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox() )
   end if

   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTop() )

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function FilterRecibos( lCobrado )

   local cFilterExpresion

   do case
      case IsTrue( lCobrado )
         cFilterExpresion  := "lCobrado .and. !lDevuelto"
      case IsFalse( lCobrado )
         cFilterExpresion  := "!lCobrado .and. !lDevuelto"
      case IsNil( lCobrado )
         cFilterExpresion  := "lDevuelto"
   end case

   CreateFastFilter( cFilterExpresion, D():FacturasProveedoresPagos( nView ), .f. )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*------------------------FUNCIONES GLOBALESS--------------------------------*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


/*
Contabiliza los recibos
*/

FUNCTION TraRecPrv( oBrw, cTitle, cOption, lChgState )

   local oDlg
   local oMtrInf
   local nMtrInf
   local oSerIni
   local oSerFin
   local oDocIni
   local oDocFin
   local nRad        := 2
   local oSimula
   local lSimula     := .t.
   local nRecno      := ( D():FacturasProveedoresPagos( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( 1 ) )
   local cSerIni     := ( D():FacturasProveedoresPagos( nView ) )->cSerFac
   local cSerFin     := ( D():FacturasProveedoresPagos( nView ) )->cSerFac
   local nDocIni     := ( D():FacturasProveedoresPagos( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasProveedoresPagos( nView ) )->nNumFac
   local cSufIni     := ( D():FacturasProveedoresPagos( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasProveedoresPagos( nView ) )->cSufFac
   local nNumIni     := ( D():FacturasProveedoresPagos( nView ) )->nNumRec
   local nNumFin     := ( D():FacturasProveedoresPagos( nView ) )->nNumRec
   local cTipo       := "Todas"
   local oTree
   local oImageList
   local oBtnCancel

   DEFAULT cTitle    := "Contabilizar recibos"
   DEFAULT cOption   := "Simular resultados"
   DEFAULT lChgState := .f.

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ), Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ), Rgb( 255, 0, 255 ) )

   DEFINE DIALOG oDlg RESOURCE "ConSerRec"

   REDEFINE COMBOBOX cTipo ;
      ITEMS    { "Todas", "Facturas", "Rectificativas" } ;
      ID       80 ;
      OF       oDlg

   REDEFINE RADIO nRad ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni;
      ID       100 ;
      PICTURE  "@!" ;
      WHEN     ( nRad == 2 );
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       oDlg ;
      RESOURCE "Up16" ;
      NOBORDER ;
      ACTION   ( dbFirst( D():FacturasProveedores( nView ), "nNumFac", oDocIni, cSerIni, "nNumFac" ) )

   REDEFINE GET oSerFin VAR cSerFin;
      ID       110 ;
      PICTURE  "@!" ;
      WHEN     ( nRad == 2 );
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       111 ;
      OF       oDlg ;
      RESOURCE "Down16" ;
      NOBORDER ;
      ACTION   ( dbLast( D():FacturasProveedores( nView ), "nNumFac", oDocFin, cSerFin, "nNumFac" ) )

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      WHEN     ( nRad == 2 );
      PICTURE  "999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
      WHEN     ( nRad == 2 );
      PICTURE  "999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      WHEN     ( nRad == 2 );
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      WHEN     ( nRad == 2 );
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE GET nNumIni ;
      ID       160 ;
      WHEN     ( nRad == 2 );
      PICTURE  "99" ;
      OF       oDlg

   REDEFINE GET nNumFin ;
      ID       170 ;
      WHEN     ( nRad == 2 );
      PICTURE  "99" ;
      OF       oDlg

   REDEFINE CHECKBOX oSimula VAR lSimula;
      ID       190 ;
      OF       oDlg

   oTree       := TTreeView():Redefine( 180, oDlg )

   REDEFINE APOLOMETER oMtrInf ;
      VAR      nMtrInf ;
      NOPERCENTAGE ;
      ID       200;
      OF       oDlg

   oMtrInf:SetTotal( ( D():FacturasProveedoresPagos( nView ) )->( OrdKeyCount() ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( PasRec( cSerIni + Str( nDocIni ) + cSufIni + Str( nNumIni ), cSerFin + Str( nDocFin ) + cSufFin + Str( nNumFin ), nRad, cTipo, lSimula, lChgState, oBrw, oDlg, oTree, oMtrInf, oBtnCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| PasRec( cSerIni + Str( nDocIni ) + cSufIni + Str( nNumIni ), cSerFin + Str( nDocFin ) + cSufFin + Str( nNumFin ), nRad, cTipo, lSimula, lChgState, oBrw, oDlg, oTree, oMtrInf, oBtnCancel ) } )

   oDlg:bStart := {|| oSerIni:SetFocus(), SetWindowText( oSimula:hWnd, cOption ), oSimula:Refresh() }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasProveedoresPagos( nView ) )->( OrdSetFocus( nOrdAnt ) )

   if oBrw != nil
      oBrw:refresh()
   end if

RETURN NIL

//------------------------------------------------------------------------//

Function SynRecPrv( cPatEmp )

   local nCon
   local oError
   local oBlock      
   local nTotFac
   local nTotRec

   BEGIN SEQUENCE
   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   USE ( cPatEmp + "FACPRVP.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVP", @dbfFacPrvP ) )
   SET ADSINDEX TO ( cPatEmp + "FACPRVP.CDX" ) ADDITIVE
   
   USE ( cPatEmp + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp + "FACPRVT.CDX" ) ADDITIVE
   
   USE ( cPatEmp + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp + "FACPRVL.CDX" ) ADDITIVE

   USE ( cPatEmp + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "RctPrvT", @dbfRctPrvT ) )
   SET ADSINDEX TO ( cPatEmp + "RctPrvT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
   SET ADSINDEX TO ( cPatEmp() + "PROVEE.CDX" ) ADDITIVE

   USE ( cPatEmp + "FPAGO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   // Rellenamos los campos----------------------------------------------------
   
   ( dbfFacPrvP )->( OrdSetFocus( 0 ) )
   ( dbfFacPrvP )->( dbGoTop() )

   while !( dbfFacPrvP )->( eof() )

      if empty( ( dbfFacPrvP )->cSufFac )
         ( dbfFacPrvP )->cSufFac := "00"
      end if

      if empty( ( dbfFacPrvP )->cCodPrv )
         ( dbfFacPrvP )->cCodPrv := RetFld( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT, "cCodPrv" )
      end if

      if empty( ( dbfFacPrvP )->cNomPrv )
         ( dbfFacPrvP )->cNomPrv := RetFld( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT, "cNomPrv" )
      end if

      if empty( ( dbfFacPrvP )->cCodCaj )
         ( dbfFacPrvP )->cCodCaj := RetFld( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT, "cCodCaj" )
      end if

      if empty( ( dbfFacPrvP )->cCodUsr )
         ( dbfFacPrvP )->cCodUsr := RetFld( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT, "cCodUsr" )
      end if

      if !empty( ( dbfFacPrvP )->cCtaEmp )

         if empty( ( dbfFacPrvP )->cEPaisIBAN )
            ( dbfFacPrvP )->cEPaisIBAN  := "ES"
         end if 

         if empty( ( dbfFacPrvP )->cECtrlIBAN )
            ( dbfFacPrvP )->cECtrlIBAN  := IbanDigit( ( dbfFacPrvP )->cEPaisIBAN, ( dbfFacPrvP )->cECtrlIBAN, ( dbfFacPrvP )->cEntEmp, ( dbfFacPrvP )->cSucEmp, ( dbfFacPrvP )->cDigEmp, ( dbfFacPrvP )->cCtaEmp )
         end if 

      end if 

      if !empty( ( dbfFacPrvP )->cCtaPrv )

         if empty( ( dbfFacPrvP )->cPaisIBAN )
            ( dbfFacPrvP )->cPaisIBAN  := "ES"
         end if 

         if empty( ( dbfFacPrvP )->cCtrlIBAN )
            ( dbfFacPrvP )->cCtrlIBAN  := IbanDigit( ( dbfFacPrvP )->cPaisIBAN, ( dbfFacPrvP )->cCtrlIBAN, ( dbfFacPrvP )->cEntPrv, ( dbfFacPrvP )->cSucPrv, ( dbfFacPrvP )->cDigPrv, ( dbfFacPrvP )->cCtaPrv )
         end if 

      end if 

      ( dbfFacPrvP )->( dbSkip() )

   end while
   
   ( dbfFacPrvP )->( OrdSetFocus( 1 ) )

   // Repasamos los totales ---------------------------------------------------

   ( dbfFacPrvT )->( OrdSetFocus( 1 ) )
   ( dbfFacPrvT )->( dbGoTop() )

   while !( dbfFacPrvT )->( eof() )

      GenPgoFacPrv( ( dbfFacPrvT )->cSerFac + Str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac, dbfFacPrvT, dbfFacPrvL, dbfFacPrvP, dbfPrv, dbfIva, dbfFPago, dbfDiv )
      ChkLqdFacPrv( , dbfFacPrvT, dbfFacPrvL, dbfFacPrvP, dbfIva, dbfDiv )

      ( dbfFacPrvT )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible sincronizar recibos de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !empty( dbfFacPrvP )
      ( dbfFacPrvP )->( dbCloseArea() )
   end if
   
   if !empty( dbfFacPrvT )
      ( dbfFacPrvT )->( dbCloseArea() )
   end if
   
   if !empty( dbfFacPrvL )
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfRctPrvT )
      ( dbfRctPrvT )->( dbCloseArea() )
   end if

   if !empty( dbfDiv )    
      ( dbfDiv )->( dbCloseArea() )
   end if

   if !empty( dbfPrv )    
      ( dbfPrv )->( dbCloseArea() )
   end if

   if !empty( dbfFPago )
      ( dbfFPago )->( dbCloseArea() )
   end if

   if !empty( dbfIva ) 
      ( dbfIva )->( dbCloseArea() )
   end if

return nil

//------------------------------------------------------------------------//

function nTotRecPrv( uFacPrvP, uDiv, cDivRet, lPic )

   local cPirDiv
   local cCodDiv
   local nTotalRec

   DEFAULT uFacPrvP  := D():FacturasProveedoresPagos( nView )
   DEFAULT uDiv      := D():Divisas( nView )
   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   do case
      case ValType( uFacPrvP ) == "O"
         cCodDiv     := uFacPrvP:cDivPgo
         nTotalRec   := uFacPrvP:nImporte

      case ValType( uFacPrvP ) == "C"
         cCodDiv     := ( uFacPrvP )->cDivPgo
         nTotalRec   := ( uFacPrvP )->nImporte
   end case

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotalRec      := nCnv2Div( nTotalRec, cCodDiv, cDivRet, uDiv )
      cPirDiv        := cPirDiv( cDivRet, uDiv )
   else
      cPirDiv        := cPirDiv( cCodDiv, uDiv )
   end if

return ( if( lPic, Trans( nTotalRec, cPirDiv ), nTotalRec ) )

//------------------------------------------------------------------------//

function nVtaRecPrv( cCodPrv, dDesde, dHasta, cFacPrvP, cIva, cDiv )

   local nCon     := 0
   local nRec     := ( cFacPrvP )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cFacPrvP )->( dbSeek( cCodPrv ) )

      while ( cFacPrvP )->cCodPrv == cCodPrv .and. !( cFacPrvP )->( Eof() )

         if ( dDesde == nil .or. ( cFacPrvP )->dPreCob >= dDesde )    .and.;
            ( dHasta == nil .or. ( cFacPrvP )->dPreCob <= dHasta )

            nCon  += nTotRecPrv( cFacPrvP, cDiv, cDivEmp(), .f. )

         end if

         ( cFacPrvP )->( dbSkip() )

      end while

   end if

   ( cFacPrvP )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//


FUNCTION aDocRecPrv()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Recibos",         "RP" } )
   aAdd( aDoc, { "Factura",         "FP" } )
   aAdd( aDoc, { "Proveedor",       "PR" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//--------------------------------------------------------------------------//

/*
Crea los ficheros de la facturaci¢n
*/

FUNCTION mkRecPrv( cPath, oMeter, lReindex ) 

   DEFAULT lReindex  := .t.

   if oMeter != NIL
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   if !lExistTable( cPath + "FacPrvP.Dbf", cLocalDriver() )
      dbCreate( cPath + "FacPrvP.Dbf", aSqlStruct( aItmRecPrv() ), cLocalDriver() )
   end if 

   if lReindex
      rxRecPrv( cPath, cLocalDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxRecPrv( cPath, cDriver )

   local dbfFacPrvP

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   mkRecPrv( cPath, nil, .f. )

   fEraseIndex( cPath + "FacPrvP.CDX", cDriver )

   dbUseArea( .t., cDriver, cPath + "FacPrvP.DBF", cCheckArea( "FacPrvP", @dbfFacPrvP ), .f. )

   if !( dbfFacPrvP )->( neterr() )

      ( dbfFacPrvP )->( __dbPack() )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "cCodPrv", "cCodPrv", {|| Field->cCodPrv } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "cNomPrv", "cNomPrv", {|| Field->cNomPrv } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "dEntrada", "dEntrada", {|| Field->dEntrada } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "dPreCob", "dPreCob", {|| Field->dPreCob } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "dFecVto", "dFecVto", {|| Field->dFecVto } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) ) 
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "nImporte", "nImporte", {|| Field->nImporte } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted() .AND. !Field->lCobrado", {|| !Deleted() .and. !Field->lCobrado } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "lCobrado", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "cTurRec", "cTurRec + cSufFac + cCodCaj", {|| Field->cTurRec + Field->cSufFac + Field->cCodCaj } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted() .and. !empty( Field->cTipRec )", {|| !Deleted() .and. !empty( Field->cTipRec ) } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "rNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted() .and. empty( Field->cTipRec )", {|| !Deleted() .and. empty( Field->cTipRec ) } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "fNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "cRecDev", "cRecDev", {|| Field->cRecDev } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted() .and. Field->lCobrado", {|| !Deleted() .and. Field->lCobrado } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.Cdx", "lCtaBnc", "Field->cEPaisIBAN + Field->cECtrlIBAN + Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp", {|| Field->cEPaisIBAN + Field->cECtrlIBAN + Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.CDX", "cCtrCoste", "cCtrCoste", {|| Field->cCtrCoste } ) )

      ( dbfFacPrvP )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFacPrvP )->( ordCreate( cPath + "FacPrvP.Cdx", "iNumFac", "'19' + cSerFac + str( nNumFac ) + space( 1 ) + cSufFac + str( nNumRec )", {|| '19' + Field->cSerFac + str( Field->nNumFac ) + space( 1 ) + Field->cSufFac + str( Field->nNumRec ) } ) )

      ( dbfFacPrvP )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de recibos de proveedores" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

function aItmRecPrv()

   local aRecFacPrv := {}

   aAdd( aRecFacPrv, { "cSerFac"    ,"C",  1, 0, "Serie de factura",                      "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "nNumFac"    ,"N",  9, 0, "Número de factura",                     "'999999999'", "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cSufFac"    ,"C",  2, 0, "Sufijo de factura",                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "nNumRec"    ,"N",  2, 0, "Número del recibo",                     "'99'",        "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cTipRec"    ,"C",  1, 0, "Tipo de recibo",                        "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "CCODCAJ"    ,"C",  3, 0, "Código de caja",                        "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "CCODPRV"    ,"C", 12, 0, "Código de proveedor",                   "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cNomPrv"    ,"C",150, 0, "Nombre de proveedor",                   "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "DENTRADA"   ,"D",  8, 0, "Fecha de entrada",                      "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "NIMPORTE"   ,"N", 16, 6, "Importe del pago",                      "cPirDivRec",  "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "CDESCRIP"   ,"C",100, 0, "Concepto del pago",                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "DPRECOB"    ,"D",  8, 0, "Fecha de previsión de pago",            "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "CPGDOPOR"   ,"C", 50, 0, "Pagado por" ,                           "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "LCOBRADO"   ,"L",  1, 0, "Lógico de pagado" ,                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "LCONPGO"    ,"L",  1, 0, "Lógico de contabilizado" ,              "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "CDIVPGO"    ,"C",  3, 0, "Código de la divisa" ,                  "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "NVDVPGO"    ,"N", 16, 6, "Cambio de la divisa" ,                  "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "CCTAREC"    ,"C", 12, 0, "Cuenta de contabilidad",                "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "LRECIMP"    ,"L",  1, 0, "Recibo ya impreso",                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "DFECVTO"    ,"D",  8, 0, "Fecha de vencimiento",                  "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCodUsr"    ,"C",  3, 0, "Código de usuario",                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "dFecChg"    ,"D",  8, 0, "Fecha de última modificación",          "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cTimChg"    ,"C",  5, 0, "Hora de última modificación",           "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cTurRec"    ,"C",  6, 0, "Sesión del recibo",                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "lCloPgo"    ,"L",  1, 0, "Lógico de turno cerrado",               "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "dFecImp"    ,"D",  8, 0, "Última fecha de impresión" ,            "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cHorImp"    ,"C",  5, 0, "Hora de la última impresión",           "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCodBnc"    ,"C",  4, 0, "Código del banco",                      "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCodPgo"    ,"C",  2, 0, "Código de la forma de pago",            "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "lNotArqueo" ,"L",  1, 0, "Lógico de no incluir en arqueo",        "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "lDevuelto"  ,"L",  1, 0, "Lógico recibo devuelto" ,               "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "dFecDev"    ,"D",  8, 0, "Fecha devolución" ,                     "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cMotDev"    ,"C",250, 0, "Motivo devolución" ,                    "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cRecDev"    ,"C", 14, 0, "Recibo de procedencia" ,                "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cBncEmp"    ,"C", 50, 0, "Banco de la empresa para el recibo" ,   "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cBncPrv"    ,"C", 50, 0, "Banco del proveedor para el recibo" ,   "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cEPaisIBAN" ,"C",  2, 0, "País IBAN de la cuenta de empresa",    "",             "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cECtrlIBAN" ,"C",  2, 0, "Digito de control IBAN de la cuenta de empresa", "",   "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cEntEmp"    ,"C",  4, 0, "Entidad de la cuenta de la empresa",    "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cSucEmp"    ,"C",  4, 0, "Sucursal de la cuenta de la empresa",   "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cDigEmp"    ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",     "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCtaEmp"    ,"C", 10, 0, "Cuenta bancaria de la empresa",         "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cPaisIBAN"  ,"C",  2, 0, "País IBAN de la cuenta del proveedor",    "",          "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCtrlIBAN"  ,"C",  2, 0, "Digito de control IBAN de la cuenta del proveedor", "","", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cEntPrv"    ,"C",  4, 0, "Entidad de la cuenta del proveedor",    "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cSucPrv"    ,"C",  4, 0, "Sucursal de la cuenta del proveedor",   "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cDigPrv"    ,"C",  2, 0, "Dígito de control de la cuenta del proveedor", "",     "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCtaPrv"    ,"C", 10, 0, "Cuenta bancaria del proveedor",         "",            "", "( cDbfRec )" } )
   aAdd( aRecFacPrv, { "cCtrCoste"  ,"C",  9, 0, "Código del centro de coste",            "",            "", "( cDbfRec )" } )

return ( aRecFacPrv )

//---------------------------------------------------------------------------//

FUNCTION aCalRecPrv()

   local aCalRecPrv  := {}

   aAdd( aCalRecPrv, {"nImpRecPrv( cDbfRec, cDbfDiv )", "N", 16, 6, "Importe del recibo", "",  "", "" } )
   aAdd( aCalRecPrv, {"cTxtRecPrv( cDbfRec, cDbfDiv )", "C",100, 0, "Importe en letras",  "",  "", "" } )

return ( aCalRecPrv )

//---------------------------------------------------------------------------//

Function EdtRecPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            WinEdtRec( nil, bEdtRec, D():FacturasProveedoresPagos( nView ) )
         else
            MsgStop( "No se encuentra recibo" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

Function ZooRecPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            WinZooRec( nil, bEdtRec, D():FacturasProveedoresPagos( nView ) )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

Function DelRecPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            oWndBrw:RecDel()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            dbDelRec( oWndBrw:oBrw, D():FacturasProveedoresPagos( nView ) )
         else
            MsgStop( "No se encuentra recibo" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//----------------------------------------------------------------------------//

Function PrnRecPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            GenRecPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            GenRecPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra recibo" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function VisRecPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            GenRecPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasProveedoresPagos( nView ) )
            GenRecPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra recibo" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Function DesignReportRecPrv( oFr, cDoc )

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
                                                   "CallHbFunc('nTotRecPrv');"                                 + Chr(13) + Chr(10) + ;
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

Function PrintReportRecPrv( nDevice, nCopies, cPrinter, cDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "ReciboProveedor" + StrTran( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + "-" + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ), " ", "" ) + ".Pdf"

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

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( cDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !empty( ( cDoc )->mReport )

      oFr:LoadFromBlob( ( cDoc )->( Select() ), "mReport")

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
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf  )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .f. )
            oFr:DoExport(     "PDFExport" )

            if file( cFilePdf )

               with object ( TGenMailing():New() )

                  :SetTypeDocument( "nRecPrv" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( D():FacturasProveedoresPagos( nView ) )->cCodPrv, D():Proveedores( nView ), "cMeiInt" ) )
                  :SetAsunto(       "Envío de  recibo de factura de proveedor número " + StrTran( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + "/" + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + "-" + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ), " ", "" ) )
                  :SetMensaje(      "Adjunto le remito nuestro recibo de factura de proveedor " + StrTran( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + "/" + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac + "-" + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumRec ), " ", "" ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( D():FacturasProveedoresPagos( nView ) )->dPreCob ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( D():FacturasProveedoresPagos( nView ), aItmRecPrv() )

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

function nTotFactProvee( cNumRec, cFacPrvT, cFacPrvL, cDbfIva, cDbfDiv, cFacPrvP )

   DEFAULT cNumRec   := ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac
   DEFAULT cFacPrvT  := D():FacturasProveedores( nView )
   DEFAULT cFacPrvL  := D():FacturasProveedoresLineas( nView )
   DEFAULT cDbfIva   := D():TiposIva( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )
   DEFAULT cFacPrvP  := D():FacturasProveedoresPagos( nView )

Return ( nTotFacPrv( cNumRec, cFacPrvT, cFacPrvL, cDbfIva, cDbfDiv, cFacPrvP, nil, nil, .f. ) )

//---------------------------------------------------------------------------//

function cTxtRecPrv( cFacPrvP, cDbfDiv )

   local cImp
   local lMas        := .t.

   DEFAULT cFacPrvP  := D():FacturasProveedoresPagos( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )

   lMas              := lMasDiv( ( cFacPrvP )->cDivPgo, cDbfDiv )
   cImp              := Num2Text( nTotRecPrv( cFacPrvP, cDbfDiv, ( cFacPrvP )->cDivPgo, .f. ), lMas )

RETURN ( cImp )

//---------------------------------------------------------------------------//

Function cCtaRecPrv( cFacPrvP, cBncPrv )

   DEFAULT cFacPrvP  := D():FacturasProveedoresPagos( nView )
   DEFAULT cBncPrv   := D():BancosProveedores( nView )

Return ( cProveeCuenta( ( cFacPrvP )->cCodPrv, cBncPrv ) )

//---------------------------------------------------------------------------//

function cMonthFecVto( cFacPrvP )

   DEFAULT cFacPrvP  := D():FacturasProveedoresPagos( nView )

RETURN ( cMonthToStr( ( D():FacturasProveedoresPagos( nView ) )->dFecVto ) )

//---------------------------------------------------------------------------//

function cMonthFecEnt( cFacPrvP )

   DEFAULT cFacPrvP  := D():FacturasProveedoresPagos( nView )

RETURN ( cMonthToStr( ( D():FacturasProveedoresPagos( nView ) )->dEntrada ) )

//---------------------------------------------------------------------------//

Function DelPgoPrv( oBrw, dbfRctPrvP )

   if ( dbfRctPrvP )->lCloPgo .and. !oUser():lAdministrador()
      MsgStop( "Solo pueden eliminar los recibos cerrados los administradores." )
      return .f.
   end if

   if ( dbfRctPrvP )->lCobrado .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta cobrado.", "Imposible eliminar" )
      return .f.
   end if

   WinDelRec( oBrw, dbfRctPrvP )

Return .t.

//---------------------------------------------------------------------------//

Function startEdtPag( aGet, aTmp, lIntro )

   DEFAULT lIntro := .f.

   if aTmp[ _LDEVUELTO ]

      if !lIntro
         aGet[ _DFECDEV ]:cText( GetSysDate() )
      end if

      aGet[ _DPRECOB    ]:HardDisable()
      aGet[ _DFECVTO    ]:HardDisable()
      aGet[ _NIMPORTE   ]:HardDisable()
      aGet[ _LCOBRADO   ]:HardDisable()
      aGet[ _DENTRADA   ]:HardDisable()
      aGet[ _CCODPGO    ]:HardDisable()
      aGet[ _CDESCRIP   ]:HardDisable()
      aGet[ _CPGDOPOR   ]:HardDisable()
      aGet[ _LRECIMP    ]:HardDisable()
      aGet[ _DFECIMP    ]:HardDisable()
      aGet[ _CHORIMP    ]:HardDisable()
      aGet[ _LNOTARQUEO ]:HardDisable()
      aGet[ _CCTAREC    ]:HardDisable()

   else

      if !lIntro
         aGet[ _DFECDEV ]:cText( Ctod( "" ) )
         aGet[ _CMOTDEV ]:cText( Space( 250 ) )
      end if

      aGet[ _DPRECOB    ]:HardEnable()
      aGet[ _DFECVTO    ]:HardEnable()
      aGet[ _NIMPORTE   ]:HardEnable()
      aGet[ _LCOBRADO   ]:HardEnable()
      aGet[ _DENTRADA   ]:HardEnable()
      aGet[ _CCODPGO    ]:HardEnable()
      aGet[ _CPGDOPOR   ]:HardEnable()
      aGet[ _LRECIMP    ]:HardEnable()
      aGet[ _DFECIMP    ]:HardEnable()
      aGet[ _CHORIMP    ]:HardEnable()
      aGet[ _LNOTARQUEO ]:HardEnable()
      aGet[ _CCTAREC    ]:HardEnable()

   end if

   if empty( aTmp[ _CRECDEV ] )
      aGet[ _CRECDEV ]:Disable()
   else
      aGet[ _CRECDEV ]:Enable()
   end if

   if lIntro
      aGet[ _CDIVPGO ]:lValid()
      aGet[ _CCTAREC ]:lValid()
      aGet[ _CCODPGO ]:lValid()
   end if 

   if !empty( aGet[ _CCENTROCOSTE ] )
      aGet[ _CCENTROCOSTE ]:lValid()
   endif

return .t.

//---------------------------------------------------------------------------//

FUNCTION ExtEdtRecPrv( cFacPrvP, nExternalView, lRectificativa, oCtrCoste )

   local nLevel            := Auth():Level( _MENUITEM_ )

   DEFAULT lRectificativa  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   oCentroCoste            := oCtrCoste

   nView                   := nExternalView

   WinEdtRec( nil, bEdtRec, cFacPrvP, lRectificativa )

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ExtDelRecPrv( cFacPrvP )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   DelPgoPrv( nil, cFacPrvP )

Return .t.

//----------------------------------------------------------------------------//

function nEstadoReciboProveedor( uFacCliP )

Return ( hGetPos( hEstadoRecibo, cEstadoReciboProveedor( uFacCliP ) ) )

//---------------------------------------------------------------------------//

function cEstadoReciboProveedor( uFacCliP )

   local cEstadoRecibo  := ""

   DEFAULT uFacCliP     := D():FacturasProveedoresPagos( nView )

   if empty( uFacCliP )
      Return ( cEstadoRecibo )
   end if 

   do case
      case ( uFacCliP )->lCobrado .and. !( uFacCliP )->lDevuelto 
         cEstadoRecibo  := "Cobrado"
      case ( uFacCliP )->lCobrado .and. ( uFacCliP )->lDevuelto
         cEstadoRecibo  := "Devuelto"
      case !( uFacCliP )->lCobrado 
         cEstadoRecibo  := "Pendiente"
   end case

Return ( cEstadoRecibo )

//---------------------------------------------------------------------------//
