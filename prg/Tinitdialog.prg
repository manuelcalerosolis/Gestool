//959411131

#include "FiveWin.Ch"
#include "Splitter.ch"
#include "Factu.ch" 
#include "Constant.ch"

#define NUMERO_DOCUMENTOS     5

#define LINEA_HORIZONTAL      70

#define WM_ERASEBKGND         20       // 0x14
#define WM_CHILDACTIVATE      34       // 0x22
#define WM_ICONERASEBKGND     39       // 0x27

//------------------------------------------------------------------------//

CLASS TInitDialog

   DATA  oDlg
   DATA  oFont
   DATA  oIcon
   DATA  cTitle

   DATA  aDocuments

   DATA  bDestroy

   DATA  oImageList

   DATA  oBtnTop

   DATA  oTreeAccessos
   DATA  oTreeDocumentos
   DATA  oTreeRecibosCompras
   DATA  oTreeRecibosVentas
   DATA  oTreeAgenda

   DATA  cPorDiv
   DATA  cPirDiv

   DATA  oGraph

   DATA  lOnProcess

   DATA  lAdministrador

   Method New()                        CONSTRUCTOR

   Method Create()                     INLINE ( Self )

   Method End()

   Method Destroy()

   Method Display()                    INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   Method HelpTopic()

   Method ClickTree()                  VIRTUAL

   Method ClickDocuments()

   Method KillProcess()                INLINE ( ::lOnProcess := .f. )

   Method LoadInformacion()

   Method LoadAccesos()

   Method LoadDocuments()

   Method LoadRecibosProveedores()

   Method LoadRecibosClientes()

   Method LoadNotas()

   Method LoadBackup()

   Method LoadGraph()

   Method LoadDivisa()

   Method Ajusta()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New()

   local aRect

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd() != nil
      oWnd():CloseAll()
   end if

   // Adaptamos la longitud de pantalla a la resolución------------------------

   aRect                := GetWndRect( GetDeskTopWindow() )

   // Cargamos las divisas-----------------------------------------------------

   ::LoadDivisa()

   // Documentos---------------------------------------------------------------

   ::aDocuments         := {}

   // Imagelist----------------------------------------------------------------

   ::oImageList         := TImageList():New( 16, 16 )

   ::oImageList:AddMasked( TBitmap():Define( "gc_object_cube_16", ,                 Self ), Rgb( 255, 0, 255 ) )  // 0
   ::oImageList:AddMasked( TBitmap():Define( "gc_user_16", ,                       Self ), Rgb( 255, 0, 255 ) )  // 1
   ::oImageList:AddMasked( TBitmap():Define( "gc_businessman_16", ,                 Self ), Rgb( 255, 0, 255 ) )  // 2
   ::oImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_businessman_16", , Self ), Rgb( 255, 0, 255 ) )  // 3
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_empty_businessman_16", ,  Self ), Rgb( 255, 0, 255 ) )  // 4
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16", ,        Self ), Rgb( 255, 0, 255 ) )  // 5
   ::oImageList:AddMasked( TBitmap():Define( "gc_briefcase2_businessman_16", ,          Self ), Rgb( 255, 0, 255 ) )  // 6
   ::oImageList:AddMasked( TBitmap():Define( "gc_notebook_user_16", ,              Self ), Rgb( 255, 0, 255 ) )  // 7
   ::oImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_user_16", ,       Self ), Rgb( 255, 0, 255 ) )  // 8
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_empty_16", ,        Self ), Rgb( 255, 0, 255 ) )  // 9
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16", ,              Self ), Rgb( 255, 0, 255 ) )  //10
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_money2_16", ,             Self ), Rgb( 255, 0, 255 ) )  //11
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_delete2_16", ,             Self ), Rgb( 255, 0, 255 ) )  //12
   ::oImageList:AddMasked( TBitmap():Define( "gc_briefcase2_user_16", ,             Self ), Rgb( 255, 0, 255 ) )  //13
   ::oImageList:AddMasked( TBitmap():Define( "gc_cash_register_user_16", ,               Self ), Rgb( 255, 0, 255 ) )  //14
   ::oImageList:AddMasked( TBitmap():Define( "gc_cash_register_touch_16", ,          Self ), Rgb( 255, 0, 255 ) )  //15
   ::oImageList:AddMasked( TBitmap():Define( "gc_shield_16", ,                      Self ), Rgb( 255, 0, 255 ) )  //16
   ::oImageList:AddMasked( TBitmap():Define( "gc_satellite_dish2_16", ,              Self ), Rgb( 255, 0, 255 ) )  //17
   ::oImageList:AddMasked( TBitmap():Define( "gc_pda_16", ,                         Self ), Rgb( 255, 0, 255 ) )  //18
   ::oImageList:AddMasked( TBitmap():Define( "gc_note_16", ,                        Self ), Rgb( 255, 0, 255 ) )  //19
   ::oImageList:AddMasked( TBitmap():Define( "gc_bell_16", ,                        Self ), Rgb( 255, 0, 255 ) )  //20
   ::oImageList:AddMasked( TBitmap():Define( "gc_window_delete_16", ,               Self ), Rgb( 255, 0, 255 ) )  //21
   ::oImageList:AddMasked( TBitmap():Define( "End16", ,                          Self ), Rgb( 255, 0, 255 ) )  //22
   ::oImageList:AddMasked( TBitmap():Define( "gc_flash_16", ,                       Self ), Rgb( 255, 0, 255 ) )  //23
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_16", ,                    Self ), Rgb( 255, 0, 255 ) )  //24

   ::lAdministrador     := oUser():lAdministrador()

   do case
   case aRect[4] == 800 .and. ::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_Admin_800x600"    TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case aRect[4] == 800 .and. !::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_User_800x600"     TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case aRect[4] == 1024 .and. ::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_Admin_1024x768"   TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case aRect[4] == 1024 .and. !::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_User_1024x768"    TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case aRect[4] == 1280 .and. ::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_Admin_1280x1024"  TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case aRect[4] == 1280 .and. !::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_User_1280x1024"   TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case ::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_Admin_800x600"    TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   case !::lAdministrador
      DEFINE DIALOG  ::oDlg RESOURCE "Hoy_User_800x600"     TITLE "Bienvenido : " + Capitalize( oUser():cNombre() ) OF oWnd()
   end case

      REDEFINE BITMAP RESOURCE "Acceso_Directo" ID 110 OF ::oDlg

      ::oTreeAccessos               := TTreeView():Redefine( 100, ::oDlg )
      ::oTreeAccessos:SetItemHeight( 20 )
      ::oTreeAccessos:OnClick       := {|| ::ClickDocuments( ::oTreeAccessos ) }

      REDEFINE BITMAP RESOURCE "Ultimos_Documentos" ID 210 OF ::oDlg

      ::oTreeDocumentos             := TTreeView():Redefine( 200, ::oDlg )
      ::oTreeDocumentos:SetItemHeight( 20 )
      ::oTreeDocumentos:OnClick     := {|| ::ClickDocuments( ::oTreeDocumentos ) }

      REDEFINE BITMAP RESOURCE "Utilidades" ID 310 OF ::oDlg

      ::oTreeAgenda                 := TTreeView():Redefine( 300, ::oDlg )
      ::oTreeAgenda:SetItemHeight( 20 )
      ::oTreeAgenda:OnClick         := {|| ::ClickDocuments( ::oTreeAgenda ) }

      if ::lAdministrador

      REDEFINE BITMAP RESOURCE "Pagos" ID 410 OF ::oDlg

      ::oTreeRecibosCompras         := TTreeView():Redefine( 400, ::oDlg )
      ::oTreeRecibosCompras:SetItemHeight( 20 )
      ::oTreeRecibosCompras:OnClick := {|| ::ClickDocuments( ::oTreeRecibosCompras ) }

      REDEFINE BITMAP RESOURCE "Cobros" ID 510 OF ::oDlg

      ::oTreeRecibosVentas          := TTreeView():Redefine( 500, ::oDlg )
      ::oTreeRecibosVentas:SetItemHeight( 20 )
      ::oTreeRecibosVentas:OnClick  := {|| ::ClickDocuments( ::oTreeRecibosVentas ) }

      REDEFINE BITMAP RESOURCE "Graficos" ID 610 OF ::oDlg

      ::oGraph             := TGraph():ReDefine( 600, ::oDlg )
      ::oGraph:aSeries     := {}
      ::oGraph:aData       := {}
      ::oGraph:aSTemp      := {}
      ::oGraph:aDTemp      := {}
      ::oGraph:cTitle      := "Evolución mensual de ventas"
      ::oGraph:l3D         := .f.
      ::oGraph:lcTitle     := .f.
      ::oGraph:lLegends    := .f.
      ::oGraph:lxVal       := .f.
      ::oGraph:lyVal       := .t.
      ::oGraph:lViewVal    := .t.
      ::oGraph:nClrT       := Rgb( 55, 55, 55 )
      ::oGraph:nClrX       := CLR_BLUE
      ::oGraph:nClrY       := CLR_RED
      ::oGraph:cPicture    := ::cPorDiv

      ::oGraph:bRClicked   := {|| GraphPropierties( ::oGraph ) }

      end if

   ::oDlg:bStart           := {|| ::LoadInformacion() }

   ::oDlg:Activate( , , ,.f.,,, {|| ::Ajusta() } )

   if ::oDlg:nResult == IDOK
      if ValType( ::bDestroy ) == "B"
         Eval( ::bDestroy )
      end if
   end if

RETURN Self

//----------------------------------------------------------------------------//

METHOD LoadInformacion()

   ::oTreeAccessos:SetImagelist(          ::oImageList )
   ::oTreeDocumentos:SetImagelist(        ::oImageList )
   ::oTreeAgenda:SetImagelist(            ::oImageList )

   if ::lAdministrador
      ::oTreeRecibosCompras:SetImagelist( ::oImageList )
      ::oTreeRecibosVentas:SetImagelist(  ::oImageList )
   end if

   oMsgProgress()
   oMsgProgress():SetRange( 0, 20 )

   oMsgText( "Accesos directos" )

   ::LoadAccesos()

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Documentos recientes" )

   ::LoadDocuments()

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Notas" )

   ::LoadNotas()

   oMsgProgress():Deltapos( 1 )

   ::LoadBackup()

   oMsgProgress():Deltapos( 1 )

   ::oTreeAgenda:Add( "No volver a mostrar página de inicio",  21, {|| SetNotIni( cCurUsr() ), ::oDlg:End() } )
   ::oTreeAgenda:Add( "Salir de página de inicio",             22, {|| ::oDlg:End() } )

   oMsgProgress():Deltapos( 1 )

   if ::lAdministrador

      oMsgText( "Recibos de proveedor" )
      ::LoadRecibosProveedores()

   end if

   oMsgProgress():Deltapos( 1 )

   if ::lAdministrador

      oMsgText( "Recibos de clientes" )
      ::LoadRecibosClientes()

   end if

   if ::lAdministrador

      oMsgText( "Cargando gráfico" )
      ::LoadGraph()

   end if

   oMsgProgress():Deltapos( 1 )

   oMsgText()

   EndProgress()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method ClickDocuments( oTree )

   local oItem := oTree:GetSelected()

   do case
      case !Empty( oItem ) .and. oItem:ClassName() == "TTVITEM" .and. Valtype( oItem:bAction ) == "A"
         Eval( oItem:bAction[ 1 ], oItem:bAction[ 2 ] )
      case !Empty( oItem ) .and. oItem:ClassName() == "TTVITEM" .and. Valtype( oItem:bAction ) == "B"
         Eval( oItem:bAction )
   end case

return ( Self )

//----------------------------------------------------------------------------//

METHOD End( lForceExit ) CLASS TShell

   DEFAULT lForceExit   := .f.

   if ::lOnProcess .and. !lForceExit
      Return ( .f. )
   end if

   ::oWndClient:ChildClose( Self )

   memory( -1 )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TShell

   if ::oTreeAccessos != nil
      ::oTreeAccessos:end()
   end if

   if ::oTreeDocumentos != nil
      ::oTreeDocumentos:end()
   end if

   if ::oTreeRecibosCompras != nil
      ::oTreeRecibosCompras:end()
   end if

   if ::oTreeRecibosVentas != nil
      ::oTreeRecibosVentas:end()
   end if

   if ::oTreeAgenda != nil
      ::oTreeAgenda:end()
   end if

   if ::oBtnTop != nil
      ::oBtnTop:end()
   end if

   if ::oMsgBar != nil
      ::oMsgBar:end()
   end if

   if ::oIcon != nil
      ::oIcon:end()
   end if

   if ::oCursor != nil
      ::oCursor:end()
   end if

   if ::oImageList != nil
      ::oImageList:End()
   end if

   if ::hWnd != 0
      Super:Destroy()
   endif

return ( Self )

//----------------------------------------------------------------------------//

Method LoadAccesos()

   local oTree

   // Añadimos la rama principal -------------------------------------------------

   oMsgText( "Accesos directos" )

   oTree    := ::oTreeAccessos:Add( "Accesos directos", 23 )

   oTree:Add( "Añadir artículo",               0, {|| ::oDlg:End(), AppArticulo( .t. ) }   )
   oTree:Add( "Añadir cliente",                1, {|| ::oDlg:End(), AppCli( .t. ) }        )
   oTree:Add( "Añadir proveedor",              2, {|| ::oDlg:End(), AppPrv( .t. ) }        )
   oTree:Add( "Añadir pedido de proveedor",    3, {|| ::oDlg:End(), AppPedPrv( nil, nil, .t. ) })
   oTree:Add( "Añadir albaran de proveedor",   4, {|| ::oDlg:End(), AppAlbPrv( nil, nil, .t. ) })
   oTree:Add( "Añadir factura de proveedor",   5, {|| ::oDlg:End(), AppFacPrv( nil, nil, .t. ) })
   oTree:Add( "Añadir presupuesto a cliente",  7, {|| ::oDlg:End(), AppPreCli( nil, nil, .t. ) })
   oTree:Add( "Añadir pedido a cliente",       8, {|| ::oDlg:End(), AppPedCli( nil, nil, .t. ) })
   oTree:Add( "Añadir albaran a cliente",      9, {|| ::oDlg:End(), AppAlbCli( nil, .t. ) })
   oTree:Add( "Añadir factura a cliente",      10,{|| ::oDlg:End(), AppFacCli( nil, nil, .t. ) })
   oTree:Add( "Añadir anticipos a cliente",    11,{|| ::oDlg:End(), AppAntCli( nil, .t. ) })
   oTree:Add( "Añadir factura rectificativa",  12,{|| ::oDlg:End(), AppFacCli( nil, nil, .t. ) })
   oTree:Add( "Añadir ticket a cliente",       14,{|| ::oDlg:End(), AppTikCli( nil, nil, .t. ) })

   oTree:Expand()

Return ( Self )

//----------------------------------------------------------------------------//


Method LoadDocuments()

   local dbf
   local oTree
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local nDocumentos := 1

   BEGIN SEQUENCE

      USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Articulo", @dbf ) )
      SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de artículos' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Artículos recientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { Alltrim( ( dbf )->Codigo ) + " - " + Alltrim( ( dbf )->Nombre ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 0, { {| x | ::oDlg:End(), EdtArticulo( x, .t. ) }, ( dbf )->Codigo } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos( 1 )

   /*
   Cargamos los clientes-------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Client", @dbf ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Clientes recientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { Alltrim( ( dbf )->Cod ) + " - " + Alltrim( ( dbf )->Titulo ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 1, { {| x | ::oDlg:End(), EdtCli( x, .t. ) }, ( dbf )->Cod } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Cargamos los proveedores----------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbf ) )
      SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de artículos' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Proveedor recientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { Alltrim( ( dbf )->Cod ) + " - " + Alltrim( ( dbf )->Titulo ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 2, { {| x | ::oDlg:End(), EdtPrv( x, .t. ) }, ( dbf )->Cod } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Cargamos los pedidos a proveedores------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "PedProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "PedProvT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de pedidos de proveedor' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Pedidos de proveedor" )

   /*
   Añadimos la rama principal -------------------------------------------------
   */

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerPed + "/" + Alltrim( Str( ( dbf )->nNumPed ) ) + "/" + ( dbf )->cSufPed + " - " + Alltrim( ( dbf )->cCodPrv ) + " - " + Alltrim( ( dbf )->cNomPrv ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 3, { {| x | ::oDlg:End(), EdtPedPrv( x, .t. ) }, ( dbf )->cSerPed + Str( ( dbf )->nNumPed ) + ( dbf )->cSufPed } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Albaranes de proveedores ---------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de albaranes de proveedor' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Albaranes de proveedor" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerAlb + "/" + Alltrim( Str( ( dbf )->nNumAlb ) ) + "/" + ( dbf )->cSufAlb + " - " + Alltrim( ( dbf )->cCodPrv ) + " - " + Alltrim( ( dbf )->cNomPrv ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 4, { {| x | ::oDlg:End(), EdtAlbPrv( x, .t. ) }, ( dbf )->cSerAlb + Str( ( dbf )->nNumAlb ) + ( dbf )->cSufAlb } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Facturas de proveedores-----------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacPrvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas de proveedor' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Facturas de proveedor" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerFac + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + ( dbf )->cSufFac + " - " + Alltrim( ( dbf )->cCodPrv ) + " - " + Alltrim( ( dbf )->cNomPrv ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 5, { {| x | ::oDlg:End(), EdtFacPrv( x, .t. ) }, ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Presupuestos a clientes-----------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "PreCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de presupuestos a clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Presupuestos a clientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerPre + "/" + Alltrim( Str( ( dbf )->nNumPre ) ) + "/" + ( dbf )->cSufPre + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 7, { {| x | ::oDlg:End(), EdtPreCli( x, .t. ) }, ( dbf )->cSerPre + Str( ( dbf )->nNumPre ) + ( dbf )->cSufPre } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Pedidos a clientes----------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de pedidos a clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Pedido a clientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerPed + "/" + Alltrim( Str( ( dbf )->nNumPed ) ) + "/" + ( dbf )->cSufPed + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 8, { {| x | ::oDlg:End(), EdtPedCli( x, .t. ) }, ( dbf )->cSerPed + Str( ( dbf )->nNumPed ) + ( dbf )->cSufPed } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Albaranes a clientes--------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "AlbCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de albaranes a clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Albaranes a clientes" )

   /*
   Añadimos la rama principal -------------------------------------------------
   */

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerAlb + "/" + Alltrim( Str( ( dbf )->nNumAlb ) ) + "/" + ( dbf )->cSufAlb + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 9, { {| x | ::oDlg:End(), EdtAlbCli( x, .t. ) }, ( dbf )->cSerAlb + Str( ( dbf )->nNumAlb ) + ( dbf )->cSufAlb } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Facturas a clientes---------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      TDataCenter():OpenFacCliT( @dbf )
      
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas a clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Facturas a clientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + ( dbf )->cSufFac + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 10, { {| x | ::oDlg:End(), EdtFacCli( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Anticipos a clientes---------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "AntCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de anticipos a clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Anticipos a clientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerAnt + "/" + Alltrim( Str( ( dbf )->nNumAnt ) ) + "/" + ( dbf )->cSufAnt + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 11, { {| x | ::oDlg:End(), EdtAntCli( x, .t. ) }, ( dbf )->cSerAnt + Str( ( dbf )->nNumAnt ) + ( dbf )->cSufAnt } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Rectificativas a clientes---------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacRecT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas rectificativas' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Rectificativas a clientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCodUsr == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + ( dbf )->cSufFac + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 12, { {| x | ::oDlg:End(), EdtFacRec( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Tickets a clientes----------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "Tiket.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Tiket", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "Tiket.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas rectificativas' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Rectificativas a clientes" )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cCcjTik == cCurUsr() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
         nDocumentos ++
         aAdd( ::aDocuments, { ( dbf )->cSerTik + "/" + AllTrim( ( dbf )->cNumTik ) + "/" + ( dbf )->cSufTik + " - " + Alltrim( ( dbf )->cCliTik ) + " - " + Alltrim( ( dbf )->cNomTik ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 14, { {| x | ::oDlg:End(), EdtTikCli( x, .t. ) }, ( dbf )->cSerTik + ( dbf )->cNumTik + ( dbf )->cSufTik } } )
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oMsgProgress():Deltapos(1)

   /*
   Ordenamos el array con los documentos---------------------------------------
   */

   aSort( ::aDocuments, , , {|x,y| x[2] > y[2] } )

   oTree    := ::oTreeDocumentos:Add( "Documentos recientes", 24 )

   aEval( ::aDocuments, {|a| oTree:Add( a[1], a[3], a[4]  ) } )

   oTree:Expand()

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadRecibosProveedores()

   local dbf
   local dbfPrv
   local dbfDiv
   local oTree
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local nTotRecibos    := 0
   local nTotVencidos   := 0

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacPrvP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvP.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "lCobrado" ) )

      USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE

      USE ( cPatDat() + "Divisas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "Divisas.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de recibos de proveedor' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   ( dbf )->( dbGoTop() )
   while !( dbf )->( eof() )

      nTotRecibos       += nTotRecPrv( dbf, dbfDiv, cDivEmp(), .f. )

      if ( dbf )->dFecVto <= GetSysDate()
         nTotVencidos   += nTotRecPrv( dbf, dbfDiv, cDivEmp(), .f. )
      end if

      ( dbf )->( dbSkip() )

   end while

   /*
   Añadimos la rama principal -------------------------------------------------
   */

   oTree                := ::oTreeRecibosCompras:Add( "Pagos vencidos [" + Trans( nTotVencidos, ::cPirDiv ) + "]", 6 )

   ( dbf )->( dbGoTop() )
   while !( dbf )->( eof() )
      if ( dbf )->dFecVto <= GetSysDate()
         oTree:Add( ( dbf )->cSerFac + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodPrv ) + Space( 1 ) + Rtrim( RetProvee( ( dbf )->cCodPrv, dbfPrv ) ) + "[" + nTotRecPrv( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 6, { {| x | ::oDlg:End(), EdtRecPrv( x, .t. ) }, ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
      end if
      ( dbf )->( dbSkip() )
   end while

   oTree:Expand()

   oTree                := ::oTreeRecibosCompras:Add( "Total pagos [" + Trans( nTotRecibos, ::cPirDiv ) + "]", 6 )

   ( dbf )->( dbGoTop() )
   while !( dbf )->( eof() )
      oTree:Add( ( dbf )->cSerFac + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodPrv ) + Space( 1 ) + Rtrim( RetProvee( ( dbf )->cCodPrv, dbfPrv ) ) + "[" + nTotRecPrv( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 6, { {| x | ::oDlg:End(), EdtRecPrv( x, .t. ) }, ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
      ( dbf )->( dbSkip() )
   end while

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   if !Empty( dbfPrv )
      ( dbfPrv )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv )->( dbCloseArea() )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadRecibosClientes()

   local dbf
   local dbfCli
   local dbfDiv
   local oTree
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local nTotRecibos    := 0
   local nTotVencidos   := 0

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacCliP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "fNumFac" ) )

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Client", @dbfCli ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatDat() + "Divisas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "Divisas.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de recibos de clientes' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   ( dbf )->( dbGoTop() )
   while !( dbf )->( eof() )

      nTotRecibos       += nTotRecCli( dbf, dbfDiv, cDivEmp(), .f. )

      if ( dbf )->dFecVto <= GetSysDate()
         nTotVencidos   += nTotRecCli( dbf, dbfDiv, cDivEmp(), .f. )
      end if

      ( dbf )->( dbSkip() )

   end while

   oMsgText( "Recibos de clientes" )

   /*
   Añadimos la rama principal -------------------------------------------------
   */

   oTree                := ::oTreeRecibosVentas:Add( "Cobros a clientes vencidos [" + Trans( nTotVencidos, ::cPorDiv ) + "]", 13 )

   ( dbf )->( dbGoTop() )
   while !( dbf )->( eof() )
      if ( dbf )->dFecVto <= GetSysDate()
         oTree:Add( ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodCli ) + Space( 1 ) + Rtrim( RetClient( ( dbf )->cCodCli, dbfCli ) ) + "[" + nTotRecCli( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 13, { {| x | ::oDlg:End(), EdtRecCli( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
      end if
      ( dbf )->( dbSkip() )
   end while

   oTree:Expand()

   oTree                := ::oTreeRecibosVentas:Add( "Total cobros a clientes [" + Trans( nTotRecibos, ::cPorDiv ) + "]", 13 )

   ( dbf )->( dbGoTop() )
   while !( dbf )->( eof() )
      oTree:Add( ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodCli ) + Space( 1 ) + Rtrim( RetClient( ( dbf )->cCodCli, dbfCli ) ) + "[" + nTotRecCli( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 13, { {| x | ::oDlg:End(), EdtRecCli( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
      ( dbf )->( dbSkip() )
   end while

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   if !Empty( dbfCli )
      ( dbfCli )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv )->( dbCloseArea() )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadNotas()

   local dbf
   local oTree
   local oError
   local oBlock

   if !File( cPatDat() + "AgendaUsr.Dbf" ) .or. !File( cPatDat() + "AgendaUsr.Cdx" )
      Return ( Self )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatDat() + "AgendaUsr.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Notes", @dbf ) )
      SET ADSINDEX TO ( cPatDat() + "AgendaUsr.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cUsrNot" ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de agenda' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Agenda" )

   /*
   Añadimos la rama principal -------------------------------------------------
   */

   oTree             := ::oTreeAgenda:Add( "Nueva nota de agenda", 19, {|| ::oDlg:End(), AppendNotas() } )

   if ( dbf )->( dbSeek( cCurUsr(), .f., .t. ) )
      while ( dbf )->cUsrNot == cCurUsr() .and. !( dbf )->( bof() )
         if !( dbf )->lVisNot
            oTree:Add( Dtoc( ( dbf )->dFecNot ) + Space( 1 ) + Rtrim( ( dbf )->cTexNot ), if( ( dbf )->lAlrNot, 20, 19 ), { {| x | ::oDlg:End(), EditNotas( x ) }, ( dbf )->( Recno() ) } )
         end if
         ( dbf )->( dbSkip( -1 ) )
      end while
   end if

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

   oTree:Expand()

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadBackup()

   local dbf
   local oTree
   local oError
   local oBlock

   if !File( cPatDat() + "BackUp.Dbf" ) .or. !File( cPatDat() + "BackUp.Cdx" )
      Return ( Self )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatDat() + "BackUp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "BackUp", @dbf ) )
      SET ADSINDEX TO ( cPatDat() + "BackUp.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "dFecha" ) )
      ( dbf )->( dbGoBottom() )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases copias de seguridad' )
      Return ( Self )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText( "Copia de seguridad" )

   /*
   Añadimos la rama principal -------------------------------------------------
   */

   oTree             := ::oTreeAgenda:Add( "Realizar nueva copia de seguridad [" + Dtoc( ( dbf )->Fecha ) + "]", 16, {|| ::oDlg:End(), TBackup():New( "01076", oWnd() ) } )

   if !Empty( dbf )
      ( dbf )->( dbCloseArea() )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadGraph()

   local aVta        := aTotVentasCliente( nil, Year( GetSysDate() ), .f. )

   ::oGraph:AddSerie( { aVta[ 1, 3 ], aVta[ 2, 3 ], aVta[ 3, 3 ], aVta[ 4, 3 ], aVta[ 5, 3 ], aVta[ 6, 3 ], aVta[ 7, 3 ], aVta[ 8, 3 ], aVta[ 9, 3 ], aVta[ 10, 3 ], aVta[ 11, 3 ], aVta[ 12, 3 ] }, "", Rgb( 255, 171, 63 ) )
   ::oGraph:SetYVals( { 'E', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D' } )

Return ( Self )

//----------------------------------------------------------------------------//

Method Ajusta()

   local rctParent := oWnd():oWndClient:GetRect()
   ::oDlg:SetCoors( TRect():New( rctParent:nTop, rctParent:nLeft, rctParent:nBottom, rctParent:nRight ) )

return nil

//----------------------------------------------------------------------------//

Method LoadDivisa()

   local dbfDiv
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatDat() + "Divisas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "Divisas.Cdx" ) ADDITIVE

      ::cPorDiv         := cPorDiv( cDivEmp(), dbfDiv )
      ::cPirDiv         := cPirDiv( cDivEmp(), dbfDiv )

      CLOSE ( dbfDiv )

   RECOVER

      ::cPorDiv         := "@E 999.999.999,99"
      ::cPirDiv         := "@E 999.999.999,99"

      msgStop( "Imposible abrir todas las bases de datos de divisas" )
      CLOSE ( dbfDiv )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//