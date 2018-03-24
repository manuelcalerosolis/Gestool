#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

#define  fldRecibosClientes      oFld:aDialogs[ 1 ]
#define  fldRecibosProveedores   oFld:aDialogs[ 2 ]
#define  fldIncidencias          oFld:aDialogs[ 3 ]

static nView

static nLevel

static oFecIniCli
static oFecFinCli
static dFecIniCli
static dFecFinCli

static oEstadoCli
static aEstadoCli    := { "Pendientes", "Pagados", "Todos" }
static cEstadoCli

static oPeriodoCli
static aPeriodoCli   := {}
static cPeriodoCli

static cCodigoCliente
static cNombreCliente
static cTelefonoCliente

static oFecIniPrv
static oFecFinPrv
static dFecIniPrv
static dFecFinPrv

static oEstadoPrv
static aEstadoPrv    := { "Pendientes", "Pagados", "Todos" }
static cEstadoPrv

static oPeriodoPrv
static aPeriodoPrv   := {}
static cPeriodoPrv

static cCodigoProveedor
static cNombreProveedor

static nFolder

static oDlg
static oFld

static oBrwInc
static oBrwRecCli
static oBrwRecPrv

static oBmpCobros
static oBmpPagos
static oBmpIncidencias

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      nView       := D():CreateView()
   
      D():Get( "Client", nView )
      D():Get( "CliInc", nView )
      
      D():Get( "FacPrvT", nView )
      D():Get( "FacPrvL", nView )
      D():Get( "FacPrvP", nView )
   
      D():Get( "FacRecT", nView )
      D():Get( "FacRecL", nView )
   
      D():Get( "AntCliT", nView )
   
      D():Get( "FacPrvT", nView )
      D():Get( "FacPrvL", nView )
      D():Get( "FacPrvP", nView )
   
      D():Get( "RctPrvT", nView )
      D():Get( "RctPrvL", nView )
   
      D():Get( "TIva", nView )
      D():Get( "Divisas", nView )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   D():DeleteView( nView )  

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PageIni( oMenuItem, oWnd )

   local oError
   local oBlock

   DEFAULT  oMenuItem      := "gestion_de_cartera"
   DEFAULT  oWnd           := oWnd()

   // Obtenemos el nivel de acceso

   nLevel                  := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Abrimos las tablas necesarias-----------------------------------------------
   */

   if !OpenFiles()
      return nil
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Cargamos los valores por defecto-----------------------------------------

   cPeriodoCli             := "Hoy"
   cEstadoCli              := "Pendientes"
   aPeriodoCli             := aCreaArrayPeriodos()

   cPeriodoPrv             := "Hoy"
   cEstadoPrv              := "Pendientes"
   aPeriodoPrv             := aCreaArrayPeriodos()

   /*
   Caja de dialogo_____________________________________________________________
   */

   DEFINE DIALOG oDlg RESOURCE "PAGEINI" OF oWnd

      REDEFINE FOLDER oFld ;
         ID          200 ;
         OF          oDlg ;
         PROMPT      "&Cobros",;
                     "&Pagos";
         DIALOGS     "PAGEINI_01",;
                     "PAGEINI_02"

      nFolder        := 1

      PageIniCobros()

      nFolder++

      PageIniPagos()

      // Redefinimos el meter--------------------------------------------------

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         ACTION      ( oDlg:End() )

      oDlg:bStart     := {|| StartPageIni() }

   ACTIVATE DIALOG oDlg CENTER

   // Guardamos la configuracion de los browse------------------------------------

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible cargar gestión de cartera" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Cerramos las tablas abiertas------------------------------------------------
   */

   CloseFiles()

   /*
   Matamos el objeto imagen----------------------------------------------------
   */

   if !Empty( oBmpCobros )
      oBmpCobros:End()
   end if

   if !empty( oBmpPagos )
      oBmpPagos:End()
   end if

   if !empty( oBmpIncidencias ) 
      oBmpIncidencias:End()
   end if 

RETURN ( NIL )

//----------------------------------------------------------------------------//

FUNCTION PageIniClient( View )

   local oError
   local oBlock

   // Obtenemos el nivel de acceso---------------------------------------------

   nLevel                  := Auth():Level( "gestion_de_cartera" )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   nView                   := View

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cCodigoCliente          := ( D():Get( "Client", nView ) )->Cod
   cNombreCliente          := ( D():Get( "Client", nView ) )->Titulo
   cTelefonoCliente        := ( D():Get( "Client", nView ) )->Telefono

   // Cargamos los valores por defecto-----------------------------------------

   cPeriodoCli             := "Todos"
   cEstadoCli              := "Pendientes"
   aPeriodoCli             := aCreaArrayPeriodos()

   // Caja de dialogo_____________________________________________________________

   DEFINE DIALOG     oDlg ;
      RESOURCE       "PageIni" ;
      TITLE          "Gestión de cartera : " + alltrim( cCodigoCliente ) + space( 1 ) + alltrim( cNombreCliente )

      REDEFINE FOLDER oFld ;
         ID          200 ;
         OF          oDlg ;
         PROMPT      "&Cobros",;
                     "Incidencias" ;
         DIALOGS     "PageIni_01",;
                     "PageIni_03"

      nFolder        := 1

      PageIniCobros()

      nFolder++

      PageIniIncidecias()

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         ACTION      ( oDlg:End() )

      oDlg:bStart    := {|| lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli ), LoadPageClient() }

   ACTIVATE DIALOG oDlg ;
      ON INIT  ( oBrwRecCli:Load(), oBrwInc:Load() );
      CENTER

   // Guardamos la configuracion de los browse------------------------------------

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible cargar gestión de cartera" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

   DestroyFastFilter( D():Get( "FacPrvP", nView ) )

   DestroyFastFilter( D():Get( "FacPrvP", nView ) )

   /*
   Guardamos el orden de los browse--------------------------------------------
   */

   oBrwRecCli:CloseData()
   oBrwInc:CloseData()

   /*
   Matamos el objeto imagen----------------------------------------------------
   */

   if !Empty( oBmpCobros )
      oBmpCobros:End()
   end if

   if !empty( oBmpIncidencias ) 
      oBmpIncidencias:End()
   end if 

RETURN ( NIL )

//----------------------------------------------------------------------------//

Static Function StartPageIni()

   lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli )

   lRecargaFecha( oFecIniPrv, oFecFinPrv, cPeriodoPrv )

   LoadPageClient()

   LoadPageProveedor()

RETURN ( NIL )

//----------------------------------------------------------------------------//

Static Function LoadPageClient()

   local cExpHead    := ""

   ( D():Get( "FacCliP", nView ) )->( OrdSetFocus( "dFecVto" ) )

   do case
      case oEstadoCli:nAt == 1
         cExpHead    := '!lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )'
      case oEstadoCli:nAt == 2
         cExpHead    := 'lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )'
      case oEstadoCli:nAt == 3
         cExpHead    := 'dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )'
   end case

   if !empty( cCodigoCliente )
      cExpHead       += ' .and. rtrim( cCodCli ) == "' + rtrim( cCodigoCliente ) + '"'
   end if

    CreateFastFilter( cExpHead, D():Get( "FacCliP", nView ), .f. )

   // Refrescamos los browse------------------------------------------------------

   if !Empty( oBrwRecCli )
      oBrwRecCli:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function LoadPageProveedor()

   local cExpHead    := ""

   ( D():Get( "FacPrvP", nView ) )->( OrdSetFocus( "dFecVto" ) )

   do case
      case oEstadoPrv:nAt == 1
         cExpHead    := '!lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniPrv ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinPrv ) + '" )'
      case oEstadoPrv:nAt == 2
         cExpHead    := 'lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniPrv ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinPrv ) + '" )'
      case oEstadoPrv:nAt == 3
         cExpHead    := 'dFecVto >= Ctod( "' + Dtoc( dFecIniPrv ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinPrv ) + '" )'
   end case

   if !empty( cCodigoCliente )
      cExpHead       += ' .and. rtrim( cCodPrv ) == "' + rtrim( cCodigoProveedor ) + '"'
   end if

   CreateFastFilter( cExpHead, D():Get( "FacPrvP", nView ), .f. )

   // Refrescamos los browse------------------------------------------------------

   if !Empty( oBrwRecPrv )
      oBrwRecPrv:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function PageIniCobros()

   local oBtnModificarRecibo

      REDEFINE BITMAP oBmpCobros ;
         ID          500 ;
         RESOURCE    "gc_safe_into_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE COMBOBOX oPeriodoCli ;
         VAR         cPeriodoCli ;
         ID          100 ;
         ITEMS       aPeriodoCli ;
         ON CHANGE   ( lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli ), LoadPageClient() ) ;
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE GET oFecIniCli VAR dFecIniCli;
         ID          110 ;
         SPINNER ;
         VALID       ( LoadPageClient() );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE GET oFecFinCli VAR dFecFinCli;
         ID          120 ;
         SPINNER ;
         VALID       ( LoadPageClient() );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE COMBOBOX oEstadoCli VAR cEstadoCli ;
         ID          130 ;
         ITEMS       aEstadoCli ;
         ON CHANGE   ( LoadPageClient() );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE BUTTON oBtnModificarRecibo ;
         ID          180 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      (  if ( !Empty( ( D():FacturasClientesCobros( nView ) )->cSerie ),;
                           EdtRecCli( D():FacturasClientesCobrosId( nView ), .f., !Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec ) ), ),;
                           oBrwRecCli:Refresh() )

      oBrwRecCli                 := IXBrowse():New( oFld:aDialogs[ nFolder ] )

      oBrwRecCli:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRecCli:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRecCli:cAlias          := ( D():Get( "FacCliP", nView ) )

      oBrwRecCli:nMarqueeStyle   := 6
      oBrwRecCli:lRecordSelector := .f.
      oBrwRecCli:cName           := "Recibos de Clientes.Inicio"

      oBrwRecCli:bLDblClick      := {|| oBtnModificarRecibo:Click() }

      oBrwRecCli:CreateFromResource( 170 )

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "E. Estado"
         :bStrData               := {|| "" }
         :bEditValue             := {|| ( D():Get( "FacCliP", nView ) )->lCobrado }
         :nWidth                 := 18
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "T. Tipo"
         :bEditValue             := {|| if( Empty( ( D():Get( "FacCliP", nView ) )->cTipRec ), "Factura", "Rectificativa" ) }
         :nWidth                 := 18
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Número"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacCliP", nView ) )->cSerie ) + "/" + AllTrim( Str( ( D():Get( "FacCliP", nView ) )->nNumFac ) ) + "/" +  AllTrim( ( D():Get( "FacCliP", nView ) )->cSufFac ) + "-" + AllTrim( Str( ( D():Get( "FacCliP", nView ) )->nNumRec ) ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Cliente"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacCliP", nView ) )->cCodCli ) }
         :nWidth                 := 60
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Nombre"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacCliP", nView ) )->cNomCli ) }
         :nWidth                 := 160
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Teléfono"
         :bEditValue             := {|| cTelefonoCliente }
         :nWidth                 := 160
         :lHide                  := .t.
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| Dtoc( ( D():Get( "FacCliP", nView ) )->dPreCob ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Vencimiento"
         :bEditValue             := {|| Dtoc( ( D():Get( "FacCliP", nView ) )->dFecVto ) }
         :bClrStd                := {|| { if( ( D():Get( "FacCliP", nView ) )->dFecVto < GetSysDate(), CLR_HRED, CLR_BLACK ), GetSysColor( COLOR_WINDOW )} }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Importe"
         :bEditValue             := {|| ( D():Get( "FacCliP", nView ) )->nImporte }
         :cEditPicture           := cPorDiv()
         :nWidth                 := 70
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      oFld:aDialogs[ nFolder ]:AddFastKey( VK_F3, {|| oBtnModificarRecibo:Click() } )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function PageIniPagos()

   local oBtnModificarRecibo

      REDEFINE BITMAP oBmpCobros ;
         ID          500 ;
         RESOURCE    "gc_safe_out_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE COMBOBOX oPeriodoPrv ;
         VAR         cPeriodoPrv ;
         ID          100 ;
         ITEMS       aPeriodoPrv ;
         ON CHANGE   ( lRecargaFecha( oFecIniPrv, oFecFinPrv, cPeriodoPrv ), LoadPageProveedor() ) ;
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE GET oFecIniPrv VAR dFecIniPrv;
         ID          110 ;
         SPINNER ;
         VALID       ( LoadPageProveedor() );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE GET oFecFinPrv VAR dFecFinPrv;
         ID          120 ;
         SPINNER ;
         VALID       ( LoadPageProveedor() );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE COMBOBOX oEstadoPrv VAR cEstadoPrv ;
         ID          130 ;
         ITEMS       aEstadoPrv ;
         ON CHANGE   ( LoadPageProveedor() );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE BUTTON oBtnModificarRecibo ;
         ID          180 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      (  if ( !Empty( ( D():FacturasProveedoresPagos( nView ) )->cSerFac ),;
                           EdtRecPrv( D():FacturasProveedoresPagosId( nView ), .f., !Empty( ( D():FacturasProveedoresPagos( nView ) )->cTipRec ) ), ),;
                           oBrwRecPrv:Refresh() )

      oBrwRecPrv                 := IXBrowse():New( oFld:aDialogs[ nFolder ] )

      oBrwRecPrv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRecPrv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRecPrv:cAlias          := ( D():Get( "FacPrvP", nView ) )

      oBrwRecPrv:nMarqueeStyle   := 6
      oBrwRecPrv:lRecordSelector := .f.
      oBrwRecPrv:cName           := "Recibos de Proveedores.Inicio"

      oBrwRecPrv:bLDblClick      := {|| oBtnModificarRecibo:Click() }

      oBrwRecPrv:CreateFromResource( 170 )

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "E. Estado"
         :bStrData               := {|| "" }
         :bEditValue             := {|| ( D():Get( "FacPrvP", nView ) )->lCobrado }
         :nWidth                 := 18
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "T. Tipo"
         :bEditValue             := {|| if( Empty( ( D():Get( "FacPrvP", nView ) )->cTipRec ), "Factura", "Rectificativa" ) }
         :nWidth                 := 18
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Número"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacPrvP", nView ) )->cSerFac ) + "/" + AllTrim( Str( ( D():Get( "FacPrvP", nView ) )->nNumFac ) ) + "/" +  AllTrim( ( D():Get( "FacPrvP", nView ) )->cSufFac ) + "-" + AllTrim( Str( ( D():Get( "FacPrvP", nView ) )->nNumRec ) ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Proveedor"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacPrvP", nView ) )->cCodPrv ) }
         :nWidth                 := 60
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Nombre"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacPrvP", nView ) )->cNomPrv ) }
         :nWidth                 := 160
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| Dtoc( ( D():Get( "FacPrvP", nView ) )->dPreCob ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Vencimiento"
         :bEditValue             := {|| Dtoc( ( D():Get( "FacPrvP", nView ) )->dFecVto ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Importe"
         :bEditValue             := {|| ( D():Get( "FacPrvP", nView ) )->nImporte }
         :cEditPicture           := cPorDiv()
         :nWidth                 := 70
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      oFld:aDialogs[ nFolder ]:AddFastKey( VK_F3, {|| oBtnModificarRecibo:Click() } )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function PageIniIncidecias()

   // Incidencias de Clientes ----------------------------------------------

   if !empty( cCodigoCliente )

      REDEFINE BITMAP oBmpIncidencias ;
         ID          500 ;
         RESOURCE    "gc_sign_warning_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ nFolder ] 

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ nFolder ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := D():Get( "CliInc", nView )
      oBrwInc:nMarqueeStyle   := 6
      oBrwInc:cName           := "Clientes.Incidencias"

      oBrwInc:bLDblClick      := {|| EdtIncidenciaCliente( nView, oBrwInc ) }

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Rs. Resuelta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( D():Get( "CliInc", nView ) )->lListo }
         :nWidth              := 18
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Fecha"
         :cSortOrder          := "cCodPrv"
         :bEditValue          := {|| Dtoc( ( D():Get( "CliInc", nView ) )->dFecInc ) }
         :nWidth              := 80
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( D():Get( "CliInc", nView ) )->mDesInc }
         :nWidth              := 350
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "cCodTip"
         :bEditValue          := {|| ( D():Get( "CliInc", nView ) )->cCodTip }
         :nWidth              := 40
      end with


      oBrwInc:CreateFromResource( 400 )

      REDEFINE BUTTON ;
         ID          100 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( AddIncidenciaCliente( nView, oBrwInc ) )

      REDEFINE BUTTON ;
         ID          110 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( EdtIncidenciaCliente( nView, oBrwInc ) )

      REDEFINE BUTTON ;
         ID          120 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( DelIncidenciaCliente( nView, oBrwInc ) )

      REDEFINE BUTTON ;
         ID          130 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( ZooIncidenciaCliente( nView, oBrwInc ) )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

static function aCreaArrayPeriodos()

   local aPeriodo := {}

   aAdd( aPeriodo, "Hoy" )

   aAdd( aPeriodo, "Ayer" )

   aAdd( aPeriodo, "Mes en curso" )

   aAdd( aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )
         aAdd( aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( aPeriodo, "Doce últimos meses" )

   aAdd( aPeriodo, "Año en curso" )

   aAdd( aPeriodo, "Año anterior" )

   aAdd( aPeriodo, "Todos" )

Return ( aPeriodo )

//---------------------------------------------------------------------------//

Static Function lRecargaFecha( oFechaInicio, oFechaFin, cPeriodo )

   do case
      case cPeriodo == "Hoy"

         oFechaInicio:cText( GetSysDate() )
         oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Ayer"

         oFechaInicio:cText( GetSysDate() -1 )
         oFechaFin:cText( GetSysDate() -1 )

      case cPeriodo == "Mes en curso"

         oFechaInicio:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Mes anterior"

         oFechaInicio:cText( BoM( AddMonth( GetSysDate(), -1 ) ) )
         oFechaFin:cText( EoM( AddMonth( GetSysDate(), -1 ) ) )

      case cPeriodo == "Primer trimestre"
         
         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Segundo trimestre"

         oFechaInicio:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Tercer trimestre"

         oFechaInicio:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Cuatro trimestre"

         oFechaInicio:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Doce últimos meses"

         oFechaInicio:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Año en curso"

         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Año anterior"

         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )
      
      case cPeriodo == "Todos"

         oFechaInicio:cText( CtoD( "01/01/2000" ) ) 
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

   end case

   oFechaInicio:Refresh()
   oFechaFin:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

 
























































































