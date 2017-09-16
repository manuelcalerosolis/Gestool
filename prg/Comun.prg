#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Empresa.ch"
#include "hbxml.ch"
#include "Xbrowse.ch"

#define CS_DBLCLKS      8

#define NUMERO_TARIFAS  6

static oWnd
static oWndBar
static oDlgProgress

static oMsgUser
static oMsgDelegacion
static oMsgCaja
static oMsgSesion
static oMsgProgress

static cCodigoEmpresaEnUso
static cCodigoDelegacionEnUso

static aEmpresa
static aDelegacion

static cCodEmp          := ""

static aMnuNext         := {}
static aMnuPrev         := {}
static aDlgEmp          := {}

static hVariables       := {=>}

static nError           := 0

static lDemoMode        := .t. 

static nHndCaj
static nHndReport

static aEmpresasGrupo   := {}

static cDefPicIn
static cDefPicOut

static lAds             := .f.
static lAIS             := .f.
static lCdx             := .f.

static cAdsIp           := ""
static cAdsPort         := ""
static cAdsData         := ""
static nAdsServer       := 7
static cAdsFile         := "Gestool.Add"

static appParamsMain    := ""
static appParamsSecond  := ""
static appParamsThird   := ""

static cCodigoAgente    := ""

static dSysDate

static cEmpUsr          := ""
static cPatGrp          := ""
static cPatCli          := ""
static cPatArt          := ""
static cPatPrv          := ""
static cPatAlm          := ""
static cPatEmp          := ""
static cPatScriptEmp    := ""
static cPatTmp          := ""
static cPathPC          := ""
static cNombrePc        := ""

static cBmpVersion
static cNameVersion
static cTypeVersion     := ""

static lStandard
static lProfesional
static lOsCommerce

static oMsgAlmacen

static cUsrTik

static oFastReport

static hMapaAjuste      :=  { "#,#0"   => { "Round" => 1,  "Incrementa" => 0.00,    "Decrementa" => 0.00,   "Ceros" => .t. } ,;
                              "#,#5"   => { "Round" => 1,  "Incrementa" => 0.05,    "Decrementa" => -0.05,  "Ceros" => .f. } ,;
                              "#,#9"   => { "Round" => 1,  "Incrementa" => 0.09,    "Decrementa" => -0.01,  "Ceros" => .f. } ,;
                              "#,10"   => { "Round" => 0,  "Incrementa" => 0.10,    "Decrementa" => -0.90,  "Ceros" => .f. } ,;
                              "#,20"   => { "Round" => 0,  "Incrementa" => 0.20,    "Decrementa" => -0.80,  "Ceros" => .f. } ,;
                              "#,50"   => { "Round" => 0,  "Incrementa" => 0.50,    "Decrementa" => -0.50,  "Ceros" => .f. } ,;
                              "#,90"   => { "Round" => 0,  "Incrementa" => 0.90,    "Decrementa" => -0.10,  "Ceros" => .f. } ,;
                              "#,95"   => { "Round" => 0,  "Incrementa" => 0.95,    "Decrementa" => -0.05,  "Ceros" => .f. } ,;
                              "#,99"   => { "Round" => 0,  "Incrementa" => 0.99,    "Decrementa" => -0.01,  "Ceros" => .f. } ,;
                              "#,00"   => { "Round" => 0,  "Incrementa" => 1.00,    "Decrementa" => -9.00,  "Ceros" => .t. } ,;
                              "1,00"   => { "Round" => -1, "Incrementa" => 11.00,   "Decrementa" => -19.00, "Ceros" => .f. } ,;
                              "5,00"   => { "Round" => -1, "Incrementa" => 15.00,   "Decrementa" => -15.00, "Ceros" => .f. } ,;
                              "9,00"   => { "Round" => -1, "Incrementa" => 19.00,   "Decrementa" => -19.00, "Ceros" => .f. } ,;
                              "10,00"  => { "Round" => -2, "Incrementa" => 110.00,  "Decrementa" => 110.00, "Ceros" => .f. } ,;
                              "20,00"  => { "Round" => -2, "Incrementa" => 120.00,  "Decrementa" => 120.00, "Ceros" => .f. } ,;
                              "50,00"  => { "Round" => -2, "Incrementa" => 150.00,  "Decrementa" => 150.00, "Ceros" => .f. } ,;
                              "100,00" => { "Round" => -3, "Incrementa" => 200.00,  "Decrementa" => 200.00, "Ceros" => .f. } }

//----------------------------------------------------------------------------//

FUNCTION oWnd() ; RETURN oWnd

//---------------------------------------------------------------------------//

FUNCTION oWndBar() ; RETURN oWndBar

//---------------------------------------------------------------------------//

FUNCTION CreateMainWindow( oIconApp )

   // Carga o no la imagen de fondo--------------------------------------------

   DEFINE WINDOW oWnd ;
      FROM     0, 0 TO 26, 82;
      TITLE    __GSTROTOR__ + Space( 1 ) + __GSTVERSION__; 
      MDI ;
      COLORS   Rgb( 0, 0, 0 ), Rgb( 231, 234, 238 ) ;
      ICON     oIconApp ;
      MENU     ( BuildMenu() )

   oWndBar                    := CreateAcceso( oWnd )
   oWndBar:CreateButtonBar( oWnd )

   // Set the bar messages-----------------------------------------------------

   oWnd:Cargo                 := appParamsMain()

   oWnd:bKeyDown              := { | nKey | StdKey( nKey ) }  

   // Mensajes-----------------------------------------------------------------

   oWnd:oMsgBar               := TMsgBar():New( oWnd, __GSTCOPYRIGHT__ + Space(2) + cNameVersion(), .f., .f., .f., .f., Rgb( 0,0,0 ), Rgb( 255,255,255 ), , .f. )
   oWnd:oMsgBar:setFont( oFontLittelTitle() )

   oDlgProgress               := TMsgItem():New( oWnd:oMsgBar, "", 100, , , , .t. )

   oWnd:oMsgBar:oDate         := TMsgItem():New( oWnd:oMsgBar, Dtoc( GetSysDate() ), oWnd:oMsgBar:GetWidth( dtoc( getsysdate() ) ) + 12,,,, .t., { || SelSysDate() } )
   oWnd:oMsgBar:oDate:lTimer  := .t.
   oWnd:oMsgBar:oDate:bMsg    := {|| GetSysDate() }
   oWnd:oMsgBar:CheckTimer()

   oMsgUser                   := TMsgItem():New( oWnd:oMsgBar, "Usuario : " + Rtrim( oUser():cNombre() ), 200,,,, .t. )

   oMsgDelegacion             := TMsgItem():New( oWnd:oMsgBar, "Delegación : " + Rtrim( oUser():cDelegacion() ), 200,,,, .t., {|| if( oUser():lCambiarEmpresa, SelectDelegacion( oMsgDelegacion ), ) } )

   oMsgCaja                   := TMsgItem():New( oWnd:oMsgBar, "Caja : "  + oUser():cCaja(), 100,,,, .t., {|| SelectCajas(), chkTurno() } )

   oMsgAlmacen                := TMsgItem():New( oWnd:oMsgBar, "Almacén : " + Rtrim( oUser():cAlmacen() ), 100,,,, .t., {|| SelectAlmacen() } )

   oMsgSesion                 := TMsgItem():New( oWnd:oMsgBar, "Sesión : ", 100,,,, .t., {|| dbDialog() } ) 

   // Abrimos la ventana-------------------------------------------------------

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT    ( WndPaint( hDC, oWnd ) ); 
      ON RESIZE   ( WndResize( oWnd ) );
      ON INIT     ( lStartCheck() );
      VALID       ( EndApp() ) 

   SysRefresh()

RETURN nil

//-----------------------------------------------------------------------------//

FUNCTION BuildMenu()

   local oMenu

   MENU oMenu
   ENDMENU

RETURN oMenu

//---------------------------------------------------------------------------//

FUNCTION lStartCheck()

   CursorWait()

   // Chequeamos los cambios de versiones--------------------------------------

   oMsgText( 'Chequeando versión de empresa' )

   ChkAllEmp()

   // Controla de acceso a la aplicación---------------------------------------

   oMsgText( 'Control de acceso a la aplicación' )

   ControlAplicacion()

   // Titulo de la aplicacion con la empresa y version-------------------------
 
   SetTituloEmpresa()

   // Opciones de inicio-------------------------------------------------------

   oMsgText( 'Selección del cajón' )

   SelectCajon()

   oMsgText( 'Selección del la caja' )

   if uFieldEmpresa( "lSelCaj", .f. )
      SelectCajas()
   end if

   oMsgText( 'Selección del almacen' )

   if uFieldEmpresa( "lSelAlm", .f. )
      SelectAlmacen()
   end if

   // Lanzamos para los documentos automáticos---------------------------------

   oMsgText( 'Facturas automáticas' )

   lFacturasAutomaticas()

   // Aviso de pedidos pendientes de procesar----------------------------------

   oMsgText( 'Pedidos por la web' )

   lPedidosWeb()

   // Evento de inicio de aplicacion-------------------------------------------

   oMsgText( 'Comprobando scripts de inicio' )
   
   runEventScript( "IniciarAplicacion" )

   // Colocamos la sesion actual-----------------------------------------------

   chkTurno()
 
   if !empty( oMsgSesion() )
      oMsgSesion():setText( "Sesión : " + Transform( cCurSesion(), "######" ) )
   end if

   // Colocamos los avisos pa las notas----------------------------------------

   oMsgText( 'Servicios de timers' )
   
   initServices()

   // Navegación---------------------------------------------------------------

   oMsgText( 'Abriendo panel de navegación' )

   // if !empty( oWnd() ) .and. !( os_iswtsclient() )
      // openWebBrowser()
   // end if

   // Texto limpio y a trabajar------------------------------------------------

   oMsgText()

   CursorWe()

   Test()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION Test()

   // msgalert( hb_valtoexp( TiposImpresorasRepository():getAll() ), "TiposImpresorasRepository" )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION WndResize( oWnd )

   local oBlock
   local oError

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !empty( oWnd )

      aEval( oWnd:oWndClient:aWnd, {|o| oWnd:oWndClient:ChildMaximize( o ) } )

      if !empty( oWndBar )
         oWndBar:CreateLogo()
      end if

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN nil

//-----------------------------------------------------------------------------//

FUNCTION oMsgProgress()

   if empty( oMsgProgress ) .and. !empty( oWnd() )
      oMsgProgress   := TProgress():New( 3, oDlgProgress:nLeft() - 2 , oWnd():oMsgBar, 0, , , .t., .f., oDlgProgress:nWidth - 2, 16 )
   end if

RETURN ( oMsgProgress )

//--------------------------------------------------------------------------//

FUNCTION EndProgress()

   oMsgProgress:End()

   oMsgProgress      := nil

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION Titulo( cTxt )

RETURN ( if( oWnd() != nil, oWnd():cTitle( cTxt ), "" ) )

//--------------------------------------------------------------------------//

FUNCTION oMsgSesion() ; RETURN ( oMsgSesion )

//--------------------------------------------------------------------------//

FUNCTION oMsgText( cText )

   DEFAULT cText     := __GSTCOPYRIGHT__ + Space(2) + cNameVersion()

   if empty( oWnd() )
      RETURN nil 
   end if 

   if _isData( oWnd(), "oMsgBar" ) .and. ( oWnd():oMsgBar != nil ) 
      oWnd():oMsgBar:SetMsg( cText )
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

Static FUNCTION StdKey( nKey )

   do case
      case nKey == 65 .and. GetKeyState( VK_CONTROL ) // Crtl + A
         CreateInfoArticulo()
      case nKey == 66 .and. GetKeyState( VK_CONTROL ) // Crtl + B
         BrwSelArticulo()
      case nKey == 68 .and. GetKeyState( VK_CONTROL ) // Crtl + C
         BrwClient()
      case nKey == 38 .and. GetKeyState( VK_CONTROL ) // Ctrl + Down
         NextEmpresa()
      case nKey == 40 .and. GetKeyState( VK_CONTROL ) // Ctrl + Up
         PriorEmpresa()
      case nKey == 48 .and. GetKeyState( VK_CONTROL ) // Ctrl + 0
         dbDialog()
   end case

RETURN Nil

//---------------------------------------------------------------------------//

STATIC FUNCTION EndApp()

   local oAni
   local oDlg
   local oError
   local oBlock
   local oBrush
   local oBtnOk
   local oBtnZip
   local lFinish
   local oBtnCancel
   local oBmpVersion

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      SysRefresh()

      if !empty( oWnd() )
         oWnd():CloseAll()
      end if

      SysRefresh()

      DEFINE BRUSH oBrush COLOR Rgb( 255, 255, 255 ) // FILE ( cBmpVersion() )

      DEFINE DIALOG oDlg RESOURCE "EndApp" BRUSH oBrush

         REDEFINE BITMAP oBmpVersion ;
            RESOURCE     cBmpVersion() ;
            ID          600 ;
            OF          oDlg

         TWebBtn():Redefine( 100,,,,,, oDlg,,,,, "LEFT",,,,, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ):SetTransparent()
         TWebBtn():Redefine( 110,,,,,, oDlg,,,,, "LEFT",,,,, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ):SetTransparent()
         TWebBtn():Redefine( 120,,,,,, oDlg,,,,, "LEFT",,,,, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ):SetTransparent()

         oAni                       := TAnimat():Redefine( oDlg, 200, { "BAR_01" }, 1 )

         REDEFINE BUTTON oBtnZip    ID 3          OF oDlg ACTION ( CompressEmpresa( cCodEmp(), nil, { oBtnZip, oBtnOk, oBtnCancel }, nil, oAni, nil, oDlg ) )

         REDEFINE BUTTON oBtnOk     ID IDOK       OF oDlg ACTION ( CompressEmpresa( cCodEmp(), nil, { oBtnZip, oBtnOk, oBtnCancel }, nil, oAni, nil, oDlg, .f. ) )

         REDEFINE BUTTON oBtnCancel ID IDCANCEL   OF oDlg ACTION ( oDlg:end() )

         oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )

         oDlg:bStart                := {|| oAni:Hide() }

      ACTIVATE DIALOG oDlg CENTER

      if !empty( oBrush )
         oBrush:End()
      end if

      if !empty( oBmpVersion )
         oBmpVersion:End()
      end if 

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

   lFinish     := !empty( oDlg ) .and. ( oDlg:nResult == IDOK )

   if ( lFinish )
      FinishAplication()
   end if

RETURN ( lFinish )

//-----------------------------------------------------------------------------//

//Procesos de comprobaciones iniciales y lectura de archivos .INI, cuando existan
//

FUNCTION ControlAplicacion()

   local oDlg
   local oBmpPerpetua
   local oBmpSaas
   local oBmpDemo
   local oSayDemo
   local oSerialHD
   local nSerialHD
   local oSerialUSR
   local nSerialUSR
   local oLicencia
   local nlicencia      
   local oSayPerpetua   
   local oSayAlquiler   
   local cSayAlquiler   

   if lControlAcceso() 
      RETURN .t.
   end if 

   nSerialHD      := Abs( nSerialHD() )
   nSerialUSR     := 0
   nlicencia      := 1
   oSayPerpetua   := Array( 2 )
   oSayAlquiler   := Array( 8 )
   cSayAlquiler   := Array( 8 )

   DEFINE DIALOG oDlg RESOURCE "GetSerialNo" TITLE "Sistema de protección"

   REDEFINE BITMAP oBmpPerpetua ;
      RESOURCE    "gc_certificate_32" ;
      TRANSPARENT ;
      ID          500;
      OF          oDlg

   REDEFINE BITMAP oBmpSaas ;
      RESOURCE    "gc_piggy_bank_32" ;
      TRANSPARENT ;
      ID          510;
      OF          oDlg
      
   REDEFINE BITMAP oBmpDemo ;
      RESOURCE    "gc_lock2_32" ;
      TRANSPARENT ;
      ID          520;
      OF          oDlg

   /*
   Licencia perpetua-----------------------------------------------------------
   */

   REDEFINE RADIO oLicencia ;
      VAR         nLicencia ;
      ID          100, 200, 300 ;
      ON CHANGE   ( ChangeLicenciaMode( nLicencia, oSerialHd, oSerialUsr, oSayPerpetua, oSayAlquiler, oSayDemo ) ) ;
      OF          oDlg

   REDEFINE SAY   oSerialHD ;
      PROMPT      nSerialHD ;
      ID          110 ;
      OF          oDlg

   REDEFINE SAY   oSayPerpetua[1] ID 111 OF oDlg   

   REDEFINE GET   oSerialUsr ;
      VAR         nSerialUSR ;
      ID          120 ;
      IDSAY       121 ;
      PICTURE     "99999999999999" ;
      OF          oDlg

   REDEFINE SAY   oSayPerpetua[2] ID 130 OF oDlg

   /*
   Licencia Alquiler-----------------------------------------------------------
   */

   REDEFINE GET   oSayAlquiler[1] ;
      VAR         cSayAlquiler[1] ;
      ID          210 ;
      IDSAY       211 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[2] ;
      VAR         cSayAlquiler[2] ;
      ID          220 ;
      IDSAY       221 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[3] ;
      VAR         cSayAlquiler[3] ;
      ID          230 ;
      IDSAY       231 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[4] ;
      VAR         cSayAlquiler[4] ;
      ID          240 ;
      IDSAY       241 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[5] ;
      VAR         cSayAlquiler[5] ;
      ID          250 ;
      IDSAY       251 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[6] ;
      VAR         cSayAlquiler[6] ;
      ID          260 ;
      IDSAY       261 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[7] ;
      VAR         cSayAlquiler[7] ;
      ID          270 ;
      IDSAY       271 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[8] ;
      VAR         cSayAlquiler[8] ;
      ID          280 ;
      OF          oDlg

   /*
   Licencia demo---------------------------------------------------------------
   */

   REDEFINE SAY oSayDemo ID 310 OF oDlg

   with object ( TWebBtn():Redefine( 400,,,,,  {|| goWeb( __GSTWEB__ ) }, oDlg,,,,, "LEFT",,,,, Rgb( 0, 0, 255 ), Rgb( 0, 0, 255 ),,,, "Ir a la página web de " + __GSTFACTORY__ ) )
      :SetTransparent()
      :SetText( __GSTWEB__ )
   end with 

   REDEFINE BUTTON ;
      ID          IDOK ; 
      OF          oDlg ;
      ACTION      ( ExitDialog( oDlg, nLicencia, nSerialHD, nSerialUSR, oSerialUsr, oSayAlquiler, cSayAlquiler ) )

      oDlg:bStart := {|| ChangeLicenciaMode( nLicencia, oSerialHd, oSerialUsr, oSayPerpetua, oSayAlquiler, oSayDemo ) }

   ACTIVATE DIALOG oDlg CENTER

   oBmpPerpetua:end()
   oBmpSaas:end()
   oBmpDemo:end() 

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION ExitDialog( oDlg, nLicencia, nSerialHD, nSerialUSR, oSerialUsr, oSayAlquiler, cSayAlquiler )

   local n 
   local nSerialCRC
   local aSerialCRC     := {}
   local cFileIni       := FullCurDir() + "2Ktorce.Num"

   do case
      case nLicencia == 1

         if lCheckPerpetuoMode( nSerialUSR )

            MsgInfo( "Programa registrado con éxito" )

            oDlg:End( IDOK )

         else
            
            MsgStop( "Número invalido" )

            oSerialUsr:SetFocus()

         end if 

      case nLicencia == 2

         if empty( cSayAlquiler[1] )
            MsgStop( "El campo N.I.F./ C.I.F. no puede estar vacío" )
            oSayAlquiler[1]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[2] )
            MsgStop( "El campo nombre no puede estar vacío" )
            oSayAlquiler[2]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[3] )
            MsgStop( "El campo domicilio no puede estar vacío" )
            oSayAlquiler[3]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[4] )
            MsgStop( "El campo población no puede estar vacío" )
            oSayAlquiler[4]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[5] )
            MsgStop( "El campo código postal no puede estar vacío" )
            oSayAlquiler[5]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[6] )
            MsgStop( "El campo email no puede estar vacío" )
            oSayAlquiler[6]:SetFocus()
            RETURN .f.
         end if

         if !lValidMail( cSayAlquiler[6] )
            MsgStop( "El campo email no es valido" )
            oSayAlquiler[6]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[7] )
            MsgStop( "El campo teléfono no puede estar vacío" )
            oSayAlquiler[7]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[8] )
            MsgStop( "El campo provincia no puede estar vacío" )
            oSayAlquiler[8]:SetFocus()
            RETURN .f.
         end if

         CursorWait()

         lEnviarCorreoWatchdog( cSayAlquiler, oDlg )

         lEnviarCorreoCliente( cSayAlquiler, oDlg )

         oDlg:End( IDOK )
   
         CursorWE()

      case nLicencia == 3

         cTypeVersion( "[VERSIÓN DEMO]" )

         oDlg:End( IDOK )

   end case      

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION ChangeLicenciaMode( nLicencia, oSerialHd, oSerialUsr, oSayPerpetua, oSayAlquiler, oSayDemo )

   do case
      case nLicencia == 1

         oSerialHd:Show()
         oSerialUsr:Show()
         aEval( oSayPerpetua, { |o| o:Show() } )
         aEval( oSayAlquiler, { |o| o:Hide() } )
         oSayDemo:Hide()   

      case nLicencia == 2

         oSerialHd:Hide()
         oSerialUsr:Hide()
         aEval( oSayPerpetua, { |o| o:Hide() } )
         aEval( oSayAlquiler, { |o| o:Show() } )   
         oSayDemo:Hide()   

      case nLicencia == 3

         oSerialHd:Hide()
         oSerialUsr:Hide()
         aEval( oSayPerpetua, { |o| o:Hide() } )
         aEval( oSayAlquiler, { |o| o:Hide() } ) 
         oSayDemo:Show()   

   end case

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION About()

   local oDlg
   local oTree
   local oBrush
   local oImgLst

   DEFINE BRUSH oBrush FILE ( cBmpVersion() )

   DEFINE DIALOG oDlg RESOURCE "About" BRUSH oBrush TITLE "Acerca de " + __GSTROTOR__ + Space( 1 ) + __GSTVERSION__

      oImgLst        := TImageList():New( 24, 24 )
      oImgLst:Add( TBitmap():Define( "gc_businessman_24", ,      oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_businessman2_24", ,   oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_dude4_24", ,          oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_mail2_24", ,          oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_user_telephone_24", , oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_mail_earth_24", ,     oDlg ) )

      oTree          := TTreeView():Redefine( 100, oDlg  )
      oTree:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

      REDEFINE SAY ID 200 COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) OF oDlg

      REDEFINE BUTTON ID IDCANCEL OF oDlg ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      ON INIT     (  oTree:SetImageList( oImgLst ),;
                     oTree:Add( "Manuel Calero Solís",                  0 ),;
                     oTree:Add( "Antonio Ebrero Burgos",                1 ),;
                     oTree:Add( "Dario Cruz Mauro",                     2 ),;
                     oTree:Add( "C. Ronda de legionarios, 58",          3 ),;
                     oTree:Add( "21700 - La Palma del Condado - Huelva",3 ),;
                     oTree:Add( "902 930 252",                          4 ),;
                     oTree:Add( "mcalero@gestool.es",                   5 ),;
                     oTree:Add( "aebrero@gestool.es",                   5 ),;
                     oTree:Add( "dario@gestool.es",                     5 ) ) ;
      CENTER

   oBrush:End()

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION RunAsistenciaRemota()

   local nHnd

   if File( FullCurDir() + "Client\Client.Exe" )

      nHnd     := WinExec( FullCurDir() + "Client\Client.Exe" , 1 )

      if !( nHnd > 21 .or. nHnd < 0 )
         MsgStop( "Error en la ejecución de la asistencia remota" )
      end if

   else

      goWeb( __GSTWEB__ + "/Client.exe" )

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION lEnviarCorreoWatchdog( cSay, oDlg )

   oDlg:Disable()

   CursorWait()

   with object ( TGenMailing():Create() )

      /*
      Introducimos los datos del servidor a fuego------------------------------
      */

      :MailServer          := "smtp.gestool.es"
      :MailServerPort      := 587
      :MailServerUserName  := "info@gestool.es"
      :MailServerPassword  := "123Ab456"

      /*
      Creamos el cuerpo del mensaje--------------------------------------------
      */

      :SetDe(              "Gestool sistema de registro" )
      :SetPara(            "registro@gestool.es" )
      :SetAsunto(          "Registro de usuario de Gestool SAAS." )
      :cGetMensaje         := "Datos de registro de usuario de Gestool SAAS" + "<br>"
      :cGetMensaje         += "NIF: "           + AllTrim( cSay[1] ) + "<br>"
      :cGetMensaje         += "Nombre: "        + AllTrim( cSay[2] ) + "<br>"
      :cGetMensaje         += "Domicilio: "     + AllTrim( cSay[3] ) + "<br>"
      :cGetMensaje         += "Población: "     + AllTrim( cSay[4] ) + "<br>"
      :cGetMensaje         += "Cod. postal: "   + AllTrim( cSay[5] ) + "<br>"
      :cGetMensaje         += "Provincia: "     + AllTrim( cSay[8] ) + "<br>"
      :cGetMensaje         += "Email: "         + AllTrim( cSay[6] ) + "<br>"
      :cGetMensaje         += "Teléfono: "      + AllTrim( cSay[7] ) + "<br>"
      :cGetMensaje         += "<br>"
      :cGetMensaje         += "Serial : "       + Str( Abs( nSerialHD() ) ) + "<br>"

      /*
      Mandamos el Mail---------------------------------------------------------
      */

      :lExternalSend()

   end with

   CursorWe()

   oDlg:Enable()

RETURN ( .t. )

//---------------------------------------------------------------------------//
         
FUNCTION lEnviarCorreoCliente( cSay, oDlg )

   oDlg:Disable()

   CursorWait()

   with object ( TGenMailing():Create() )

      /*
      Introducimos los datos del servidor a fuego------------------------------
      */

      :MailServer            := "smtp.gestool.es"
      :MailServerPort        := 587
      :MailServerUserName    := "info@gestool.es"
      :MailServerPassword    := "123Ab456"

      /*
      Creamos el cuerpo del mensaje--------------------------------------------
      */

      :SetDe(                "Gestool sistema de registro" )
      :SetPara(              AllTrim( cSay[6] ) )
      :SetAsunto(            "Registro de Gestool." )
      :cGetMensaje           := "Su petición de registro está siendo procesada. En breve nos pondremos en contacto con usted "
      :cGetMensaje           += "para finalizar el proceso de registro." + "<br>"
      :cGetMensaje           += "Puede ponerse en contacto con nosotros mediante email en registro@gestool.es; o en el teléfono 902 930 252" + "<br>"
      :cGetMensaje           += "de 09:00 a 15:00"

      /*
      Mandamos el Mail---------------------------------------------------------
      */

      :lExternalSend()

   end with

   CursorWe()

   oDlg:Enable()

RETURN ( .t. )

//---------------------------------------------------------------------------//
// Remember to use 'exit' procedures to asure that resources are
// freed on a possible application error

Static FUNCTION FinishAplication() //  Static FUNCTION

   CursorWait()

   if !empty( cCodEmp() )
      WritePProString( "main", "Ultima Empresa", cCodEmp(), cIniAplication() )
   end if 

   // liberar el usuario-------------------------------------------------------

   lFreeUser()

   // Cerramos las auditorias--------------------------------------------------

   stopServices()

   // Cerramos el Activex------------------------------------------------------

   closeWebBrowser()

   // Limpiamos los recursos estaticos-----------------------------------------

   TAcceso():End()

   TBandera():Destroy()

   freeResources()

   cursorWE()

   checkRes()

   // winExec( "notepad checkres.txt" )

RETURN nil

//---------------------------------------------------------------------------//

Static FUNCTION addMenu( oMenu, oTree )

   local n
   local cPrompt
   local oItem

   for n = 1 to len( oMenu:aItems )

      cPrompt     := oMenu:aItems[ n ]:cPrompt

      if ValType( oMenu:aItems[ n ]:bAction ) == "O"

         oItem    := oTree:add( strtran( cPrompt, "&", "" ) )
         addMenu( oMenu:aItems[ n ]:bAction, oItem )

      else

         if !empty( cPrompt )
            oItem := oTree:add( strtran( cPrompt, "&", "" ) )
         end if

      endif

   next

RETURN .t.

//----------------------------------------------------------------------------//

static FUNCTION nLeft( oMsgBar )

   local n
   local nLen  := Len( oMsgBar:aItems )
   local nPos  := oMsgBar:nRight - 3

   if nLen > 0
      for n := 1 to nLen
         nPos -= ( oMsgBar:aItems[ n ]:nWidth + 4 )
      next
   end if

RETURN nPos

//------------------------------------------------------------------------------------------------------------------------------

STATIC PROCEDURE GoToWeb()

   WinExec( "Start " + __GSTWEB__, 0 )

RETURN

//---------------------------------------------------------------------------//

static FUNCTION WndPaint( hDC, oWnd )

   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !empty( oWnd ) .and. !empty( oWnd:oWndClient )

         if len( oWnd:oWndClient:aWnd ) > 0
            aTail( oWnd:oWndClient:aWnd ):SetFocus()
         end if

      end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cNbrUsr( cNbr )

   if cNbr != nil .and. oMsgUser != nil
      oMsgUser:SetText( "Usuario : " + RTrim( cNbr ) )
   end if

RETURN cNbr

//---------------------------------------------------------------------------//

FUNCTION cCajUsr( cCaj )

   if !empty( cCaj ) .and. oMsgCaja != nil
      oMsgCaja:SetText( "Caja : " + RTrim( cCaj ) )
   end if

RETURN ( cCaj )

//---------------------------------------------------------------------------//

FUNCTION cDlgUsr( cDlg )

   if cDlg != nil .and. oMsgDelegacion != nil
      oMsgDelegacion:SetText( "Delegación : " + RTrim( cDlg ) )
   end if

RETURN ( cDlg )

//---------------------------------------------------------------------------//

FUNCTION EnableAcceso()

RETURN ( nil ) // if( !empty( oWndBar ), oWndBar:Enable(), ) )

//---------------------------------------------------------------------------//

FUNCTION DisableAcceso()

RETURN ( nil ) // if( !empty( oWndBar ), oWndBar:Disable(), ) )

//---------------------------------------------------------------------------//

FUNCTION CreateAcceso( oWnd )

   local oAcceso
   local oGrupo

   local oItem
   local oItemArchivo
   local oItemCompras
   local oItemAlmacen
   local oItemProduccion
   local oItemExpediente
   local oItemVentas
   local oItemTpv
   local oItemHerramientas
   local oItemAyudas
   local oItemReporting

   oAcceso              := TAcceso():New()

   oItemArchivo         := oAcceso:Add()
   oItemArchivo:cPrompt := 'ARCHIVOS'
   oItemArchivo:cBmp    := "gc_folder_open_16"
   oItemArchivo:cBmpBig := "gc_folder_open_32"
   oItemArchivo:lShow   := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Inicio'
   oGrupo:cLittleBitmap := "gc_clock_16"
   oGrupo:cBigBitmap    := "gc_clock_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Gestión de cartera'
   oItem:cMessage       := 'Gestión de cartera'
   oItem:bAction        := {|| PageIni( "01004", oWnd() ) }
   oItem:cId            := "01004"
   oItem:cBmp           := "gc_briefcase_16"
   oItem:cBmpBig        := "gc_briefcase_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Iniciar sesión'
   oItem:cMessage       := 'Inicia una nueva sesión de trabajo'
   oItem:bAction        := {|| ChkTurno( "01000", oWnd() ) }
   oItem:cId            := "01000"
   oItem:cBmp           := "gc_clock_play_16"
   oItem:cBmpBig        := "gc_clock_play_32"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Arqueo parcial (X)'
   oItem:cMessage       := 'Inicia una nueva sesión de trabajo'
   oItem:bAction        := {|| CloseTurno( "01001", oWnd(), .t. ) }
   oItem:cId            := "01001"
   oItem:cBmp           := "gc_clock_refresh_16"
   oItem:cBmpBig        := "gc_clock_refresh_32"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cerrar sesión (Z)'
   oItem:cMessage       := 'Cierra la sesión de trabajo actual'
   oItem:bAction        := {|| CloseTurno( "01006", oWnd() ) }
   oItem:cId            := "01006"
   oItem:cBmp           := "gc_clock_stop_16"
   oItem:cBmpBig        := "gc_clock_stop_32"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Sesiones'
   oItem:cMessage       := 'Sesiones de trabajo'
   oItem:bAction        := {|| Turnos( "01002", oWnd() ) }
   oItem:cId            := "01002"
   oItem:cBmp           := "gc_clock_16"
   oItem:cBmpBig        := "gc_clock_32"

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Empresa'
   oGrupo:cLittleBitmap := "gc_factory_16"
   oGrupo:cBigBitmap    := "gc_factory_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Empresa'
   oItem:cMessage       := 'Acceso al fichero de empresas'
   oItem:bAction        := {|| Empresa() }
   oItem:cId            := "01003"
   oItem:cBmp           := "gc_factory_16"
   oItem:cBmpBig        := "gc_factory_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Configurar empresa'
   oItem:cMessage       := 'Configurar empresa en curso'
   oItem:bAction        := {|| ConfEmpresa( oWnd() ) }
   oItem:cId            := "01005"
   oItem:cBmp           := "gc_wrench_16"
   oItem:cBmpBig        := "gc_wrench_32"
   oItem:lShow          := .t.

   // Articulos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:nLittleItems  := 3
   oGrupo:cPrompt       := 'Artículos'
   oGrupo:cLittleBitmap := "gc_object_cube_16"
   oGrupo:cBigBitmap    := "gc_object_cube_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos de familias'
   oItem:cMessage       := 'Acceso al fichero de grupos de familias'
   oItem:bAction        := {|| TGrpFam():New( cPatArt(), oWnd(), "01011" ):Play() }
   oItem:cId            := "01011"
   oItem:cBmp           := "gc_folder_cubes_16"
   oItem:cBmpBig        := "gc_folder_cubes_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Familias'
   oItem:cMessage       := 'Acceso al fichero de familias'
   oItem:bAction        := {|| Familia( "01012", oWnd() ) }
   oItem:cId            := "01012"
   oItem:cBmp           := "gc_cubes_16"
   oItem:cBmpBig        := "gc_cubes_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Artículos'
   oItem:cMessage       := 'Acceso al fichero de artículo'
   oItem:bAction        := {|| Articulo( "01014", oWnd ) }
   oItem:cId            := "01014"
   oItem:cBmp           := "gc_object_cube_16"
   oItem:cBmpBig        := "gc_object_cube_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Fabricantes'
   oItem:cMessage       := 'Clasificación de artículos por fabricantes'
   oItem:bAction        := {|| TFabricantes():New( cPatArt(), oWnd, "01070" ):Activate() }
   oItem:cId            := "01070"
   oItem:cBmp           := "gc_bolt_16"
   oItem:cBmpBig        := "gc_bolt_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Comentarios'
   oItem:cMessage       := 'Acceso a los comentarios de los artículos'
   oItem:bAction        := {|| TComentarios():New( cPatArt(), cDriver(), oWnd, "04002" ):Activate() }
   oItem:cId            := "04002"
   oItem:cBmp           := "gc_message_16"
   oItem:cBmpBig        := "gc_message_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Propiedades'
   oItem:cMessage       := 'Acceso a las propiedades los artículos'
   oItem:bAction        := {|| Prop( "01015", oWnd ) }
   oItem:cId            := "01015"
   oItem:cBmp           := "gc_coathanger_16"
   oItem:cBmpBig        := "gc_coathanger_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Factores conversión'
   oItem:cMessage       := 'Acceso a los factores de conversion de los artículos'
   oItem:bAction        := {|| TblCnv( "01016", oWnd ) }
   oItem:cId            := "01016"
   oItem:cBmp           := "gc_objects_transform_16"
   oItem:cBmpBig        := "gc_objects_transform_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Unidades medición'
   oItem:cMessage       := 'Unidades de medición'
   oItem:bAction        := {|| UniMedicion():New( cPatEmp(), oWnd, "01103" ):Activate() }
   oItem:cId            := "01103"
   oItem:cBmp           := "gc_tape_measure2_16"
   oItem:cBmpBig        := "gc_tape_measure2_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos'
   oItem:cMessage       := 'Clasificación de artículos por tipos'
   oItem:bAction        := {|| TTipArt():New( cPatArt(), cDriver(), oWnd, "01013" ):Activate() }
   oItem:cId            := "01013"
   oItem:cBmp           := "gc_objects_16"
   oItem:cBmpBig        := "gc_objects_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := getConfigTraslation( 'Temporadas' )
   oItem:cMessage       := 'Acceso al fichero de ' + getConfigTraslation( 'temporadas' )
   oItem:bAction        := {|| Temporada( "01114", oWnd() ) }
   oItem:cId            := "01114"
   oItem:cBmp           := "gc_cloud_sun_16"
   oItem:cBmpBig        := "gc_cloud_sun_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Envasado"
   oItem:cMessage       := 'Acceso al fichero de envasado'
   oItem:bAction        := {|| TFrasesPublicitarias():New():Activate() }
   oItem:cId            := "01129"
   oItem:cBmp           := "gc_box_closed_16"
   oItem:cBmpBig        := "gc_box_closed_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Categorías"
   oItem:cMessage       := 'Acceso al fichero de categorías'
   oItem:bAction        := {|| Categoria( "01130", oWnd() ) }
   oItem:cId            := "01130"
   oItem:cBmp           := "gc_photographic_filters_16"
   oItem:cBmpBig        := "gc_photographic_filters_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Tarifas------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Tarifas'
   oGrupo:cLittleBitmap := "gc_symbol_percent_16"
   oGrupo:cBigBitmap    := "gc_symbol_percent_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tarifas de precios'
   oItem:cMessage       := 'Acceso a las tarifas de precios'
   oItem:bAction        := {|| Tarifa( "01019", oWnd ) }
   oItem:cId            := "01019"
   oItem:cBmp           := "gc_symbol_percent_16"
   oItem:cBmpBig        := "gc_symbol_percent_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ofertas'
   oItem:cMessage       := 'Acceso a las ofertas de artículos'
   oItem:bAction        := {|| Oferta( "01020", oWnd ) }
   oItem:cId            := "01020"
   oItem:cBmp           := "gc_star2_16"
   oItem:cBmpBig        := "gc_star2_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Promociones'
   oItem:cMessage       := 'Acceso a las promociones comerciales'
   oItem:bAction        := {|| Promocion( "01021", oWnd ) }
   oItem:cId            := "01021"
   oItem:cBmp           := "gc_star2_blue_16"
   oItem:cBmpBig        := "gc_star2_blue_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Busquedas----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := if( lAIS(), 3, 2 )
   oGrupo:cPrompt       := 'Búsquedas'
   oGrupo:cLittleBitmap := "gc_package_binocular_16"
   oGrupo:cBigBitmap    := "gc_package_binocular_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Búsqueda por series'
   oItem:cMessage       := 'Búsqueda por series'
   oItem:bAction        := {|| TSeaNumSer():Activate( "01022", oWnd ) }
   oItem:cId            := "01022"
   oItem:cBmp           := "gc_package_binocular_16"
   oItem:cBmpBig        := "gc_package_binocular_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Búsqueda por lotes'
   oItem:cMessage       := 'Búsqueda por lotes'
   oItem:bAction        := {|| TTrazarLote():Activate( "01023", oWnd ) }
   oItem:cId            := "01023"
   oItem:cBmp           := "gc_package_lupa_16"
   oItem:cBmpBig        := "gc_package_lupa_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .f.

   if lAIS()

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Búsqueda especial'
   oItem:cMessage       := 'Búsqueda especial'
   oItem:bAction        := {|| tSpecialSearchArticulo():New( "01127", oWnd ) }
   oItem:cId            := "01127"
   oItem:cBmp           := "gc_zoom_in_16"
   oItem:cBmpBig        := "gc_zoom_in_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .f.

   end if


   // Impuestos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Impuestos'
   oGrupo:cLittleBitmap := "gc_moneybag_16"
   oGrupo:cBigBitmap    := "gc_moneybag_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de " + cImp()
   oItem:cMessage       := "Acceso a los tipos de " + cImp()
   oItem:bAction        := {|| Tiva( "01036", oWnd ) }
   oItem:cId            := "01036"
   oItem:cBmp           := "gc_moneybag_16"
   oItem:cBmpBig        := "gc_moneybag_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Impuestos especiales"
   oItem:cMessage       := "Impuestos especiales"
   oItem:bAction        := {|| NewImp( "01037", oWnd ) }
   oItem:cId            := "01037"
   oItem:cBmp           := "gc_moneybag_euro_16"
   oItem:cBmpBig        := "gc_moneybag_euro_32"
   oItem:lShow          := .f.

   // Impuestos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Pagos'
   oGrupo:cLittleBitmap := "gc_currency_euro_16"
   oGrupo:cBigBitmap    := "gc_currency_euro_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Divisas monetarias"
   oItem:cMessage       := "Acceso a divisas monetarias"
   oItem:bAction        := {|| Divisas( "01038", oWnd ) }
   oItem:cId            := "01038"
   oItem:cBmp           := "gc_currency_euro_16"
   oItem:cBmpBig        := "gc_currency_euro_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Bancos'
   oItem:cMessage       := 'Acceso a las entidades bancarias'
   oItem:bAction        := {|| TBancos():New( cPatEmp(), oWnd, "01106" ):Activate() }
   oItem:cId            := "01106"
   oItem:cBmp           := "gc_central_bank_euro_16"
   oItem:cBmpBig        := "gc_central_bank_euro_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cuentas bancarias'
   oItem:cMessage       := 'Acceso a las cuentas bancarias'
   oItem:bAction        := {|| TCuentasBancarias():New( cPatEmp(), oWnd, "01106" ):Activate() }
   oItem:cId            := "01106"
   oItem:cBmp           := "gc_central_bank_euro_text_16"
   oItem:cBmpBig        := "gc_central_bank_euro_text_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Formas de pago"
   oItem:cMessage       := "Acceso a formas de pago"
   oItem:bAction        := {|| Fpago( "01039", oWnd ) }
   oItem:cId            := "01039"
   oItem:cBmp           := "gc_credit_cards_16"
   oItem:cBmpBig        := "gc_credit_cards_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cuentas de remesas"
   oItem:cMessage       := "Acceso a las cuentas de remesas"
   oItem:bAction        := {|| TCtaRem():New( cPatCli(), cDriver(), oWnd, "01044" ):Activate() }
   oItem:cId            := "01044"
   oItem:cBmp           := "gc_portfolio_folder_16"
   oItem:cBmpBig        := "gc_portfolio_folder_32"
   oItem:lShow          := .f.

   // Otros--------------------------------------------------------------------

   oGrupo               := TGrupoAcceso() 
   oGrupo:nBigItems     := 13
   oGrupo:cPrompt       := 'Global'
   oGrupo:cLittleBitmap := "gc_folder2_16"
   oGrupo:cBigBitmap    := "gc_folder2_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cajas"
   oItem:cMessage       := "Acceso a las cajas"
   oItem:bAction        := {|| Cajas( "01040", oWnd ) }
   oItem:cId            := "01040"
   oItem:cBmp           := "gc_cash_register_16"
   oItem:cBmpBig        := "gc_cash_register_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos ventas'
   oItem:cMessage       := 'Acceso a los grupos de ventas de contabilidad'
   oItem:bAction        := {|| GrpVenta( "01018", oWnd ) }
   oItem:cId            := "01018"
   oItem:cBmp           := "gc_magazine_folder_16"
   oItem:cBmpBig        := "gc_magazine_folder_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Centro de costes"
   oItem:cMessage       := "Acceso al centro de coste"
   oItem:bAction        := {|| TCentroCoste():New( cPatDat(), oWnd, "01128" ):Activate() }
   oItem:cId            := "01128"
   oItem:cBmp           := "gc_folder_open_money_16"
   oItem:cBmpBig        := "gc_folder_open_money_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Codigos postales'
   oItem:cMessage       := 'Acceso al fichero de codigos postales'
   oItem:bAction        := {|| CodigosPostales():New( cPatDat(), cDriver(), oWnd, "01011" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "gc_postage_stamp_16"
   oItem:cBmpBig        := "gc_postage_stamp_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Provincias'
   oItem:cMessage       := 'Acceso al fichero de grupos de provincias'
   oItem:bAction        := {|| Provincias():New( cPatDat(), cDriver(), oWnd, "01011" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "gc_flag_spain_16"
   oItem:cBmpBig        := "gc_flag_spain_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Paises"
   oItem:cMessage       := "Acceso a los paises"
   oItem:bAction        := {|| TPais():New( cPatDat(), cDriver(), oWnd, "01041" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "gc_globe_16"
   oItem:cBmpBig        := "gc_globe_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Lenguajes"
   oItem:cMessage       := "Acceso a los lenguajes"
   oItem:bAction        := {|| TLenguaje():New( cPatDat(), cDriver(), oWnd, "01125" ):Activate() }
   oItem:cId            := "01125"
   oItem:cBmp           := "gc_user_message_16"
   oItem:cBmpBig        := "gc_user_message_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de ventas"
   oItem:cMessage       := "Acceso a los tipos de ventas"
   oItem:bAction        := {|| TiposVentasController():New():activateShell() }
   oItem:cId            := "01043"
   oItem:cBmp           := "gc_wallet_16"
   oItem:cBmpBig        := "gc_wallet_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Transportistas"
   oItem:cMessage       := "Acceso a los transportistas"
   oItem:bAction        := {|| TTrans():New( cPatCli(), oWnd, "01045" ):Activate() }
   oItem:cId            := "01045"
   oItem:cBmp           := "gc_small_truck_16"
   oItem:cBmpBig        := "gc_small_truck_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Situaciones"
   oItem:cMessage       := "Acceso a los tipos de situaciones"
   oItem:bAction        := {|| SituacionesController():New():activateShell() }
   oItem:cId            := "01096"
   oItem:cBmp           := "gc_document_attachment_16"
   oItem:cBmpBig        := "gc_document_attachment_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Etiquetas'
   oItem:cMessage       := 'Etiquetas'
   oItem:bAction        := {|| EtiquetasController():New():activateShell() }
   oItem:cId            := "01126"
   oItem:cBmp           := "gc_bookmarks_16"
   oItem:cBmpBig        := "gc_bookmarks_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de notas"
   oItem:cMessage       := "Acceso a los tipos de notas"
   oItem:bAction        := {|| TiposNotasController():New():activateShell() }
   oItem:cId            := "01101"
   oItem:cBmp           := "gc_folder2_16"
   oItem:cBmpBig        := "gc_folder2_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de impresoras"
   oItem:cMessage       := "Acceso a los tipos de impresoras"
   oItem:bAction        := {|| TiposImpresorasController():New():activateShell() }
   oItem:cId            := "01115"
   oItem:cBmp           := "gc_printer2_16"
   oItem:cBmpBig        := "gc_printer2_32"
   oItem:lShow          := .f.

   // Compras-------------------------------------------------------------------

   if IsStandard()

   oItemCompras         := oAcceso:Add()
   oItemCompras:cPrompt := 'COMPRAS'
   oItemCompras:cBmp    := "gc_folder_open_16"
   oItemCompras:cBmpBig := "gc_folder_open_32"
   oItemCompras:lShow   := .t.

   // Proveedores--------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Proveedores'
   oGrupo:cLittleBitmap := "gc_businessmen2_16"
   oGrupo:cBigBitmap    := "gc_businessmen2_32"

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos'
   oItem:cMessage       := 'Acceso a los grupos de proveedores'
   oItem:bAction        := {|| TGrpPrv():New( cPatPrv(), oWnd, "01110" ):Activate() }
   oItem:cId            := "01110"
   oItem:cBmp           := "gc_businessmen2_16"
   oItem:cBmpBig        := "gc_businessmen2_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Proveedores'
   oItem:cMessage       := 'Acceso a los proveedores'
   oItem:bAction        := {|| Provee( "01034", oWnd ) }
   oItem:cId            := "01034"
   oItem:cBmp           := "gc_businessman_16"
   oItem:cBmpBig        := "gc_businessman_32"
   oItem:lShow          := .t.

   // Compras------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Compras'
   oGrupo:cLittleBitmap := "gc_document_text_businessman_16"
   oGrupo:cBigBitmap    := "gc_document_text_businessman_32"

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pedidos'
   oItem:cMessage       := 'Acceso a los pedidos de proveedores'
   oItem:bAction        := {|| PedPrv( "01046", oWnd ) }
   oItem:cId            := "01046"
   oItem:cBmp           := "gc_clipboard_empty_businessman_16"
   oItem:cBmpBig        := "gc_clipboard_empty_businessman_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Albaranes'
   oItem:cMessage       := 'Acceso a los albaranes de proveedores'
   oItem:bAction        := {|| AlbPrv( "01047", oWnd ) }
   oItem:cId            := "01047"
   oItem:cBmp           := "gc_document_empty_businessman_16"
   oItem:cBmpBig        := "gc_document_empty_businessman_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas'
   oItem:cMessage       := 'Acceso a las facturas de proveedores'
   oItem:bAction        := {|| FacPrv( "01048", oWnd ) }
   oItem:cId            := "01048"
   oItem:cBmp           := "gc_document_text_businessman_16"
   oItem:cBmpBig        := "gc_document_text_businessman_32"
   oItem:lShow          := .t.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas rectificativas'
   oItem:cMessage       := 'Acceso a las facturas rectificativas de proveedores'
   oItem:bAction        := {|| RctPrv( "01099", oWnd ) }
   oItem:cId            := "01099"
   oItem:cBmp           := "gc_document_text_delete2_16"
   oItem:cBmpBig        := "gc_document_text_delete2_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pagos'
   oItem:cMessage       := 'Acceso a los pagos a proveedores'
   oItem:bAction        := {|| RecPrv( "01049", oWnd ) }
   oItem:cId            := "01049"
   oItem:cBmp           := "gc_briefcase2_businessman_16"
   oItem:cBmpBig        := "gc_briefcase2_businessman_32"
   oItem:lShow          := .t.

   // Almacenes--------------------------------------------------------------

   oItemAlmacen         := oAcceso:Add()
   oItemAlmacen:cPrompt := 'ALMACENES'
   oItemAlmacen:cBmp    := "gc_folder_open_16"
   oItemAlmacen:cBmpBig := "gc_folder_open_32"
   oItemAlmacen:lShow   := .t.

   // Almacenes----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Almacenes'
   oGrupo:cLittleBitmap := "gc_package_16"
   oGrupo:cBigBitmap    := "gc_package_16"

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Almacenes'
   oItem:cMessage       := 'Acceso a los almacenes'
   oItem:bAction        := {|| Almacen( "01035", oWnd ) }
   oItem:cId            := "01035"
   oItem:cBmp           := "gc_package_16"
   oItem:cBmpBig        := "gc_package_32"
   oItem:lShow          := .f.

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de movimientos"
   oItem:cMessage       := "Acceso a los tipos de movimientos de almacén"
   oItem:bAction        := {|| TMov( "01042", oWnd ) }
   oItem:cId            := "01042"
   oItem:cBmp           := "gc_package_refresh_16"
   oItem:cBmpBig        := "gc_package_refresh_32"
   oItem:lShow          := .f.

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ubicaciones'
   oItem:cMessage       := 'Acceso a las ubicaciones de almacenes'
   oItem:bAction        := {|| Ubicacion( "01088", oWnd ) }
   oItem:cId            := "01088"
   oItem:cBmp           := "gc_forklift_16"
   oItem:cBmpBig        := "gc_forklift_32"
   oItem:lShow          := .f.

   /*
   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Movimientos almacén'
   oGrupo:cLittleBitmap := "gc_pencil_package_16"
   oGrupo:cBigBitmap    := "gc_pencil_package_32"
   */

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Movimientos almacén'
   oItem:cMessage       := 'Acceso a los movimientos de almacén'
   oItem:bAction        := {|| RemMovAlm( "01050", oWnd ) }
   oItem:cId            := "01050"
   oItem:cBmp           := "gc_pencil_package_16"
   oItem:cBmpBig        := "gc_pencil_package_32"
   oItem:lShow          := .f.

   end if

   // Producción---------------------------------------------------------------

   if IsProfesional()

   oItemProduccion            := oAcceso:Add()
   oItemProduccion:cPrompt    := 'PRODUCCIÓN' 
   oItemProduccion:cBmp       := "gc_folder_open_16"
   oItemProduccion:cBmpBig    := "gc_folder_open_32"
   oItemProduccion:lShow      := .t. 

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := 'Estructura'
   oGrupo:cLittleBitmap := "gc_worker_group_16"
   oGrupo:cBigBitmap    := "gc_worker_group_32"

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Secciones'
   oItem:cMessage       := 'Acceso a las secciones de producción'
   oItem:bAction        := {|| TSeccion():New( cPatEmp(), cDriver(), oWnd, "04001" ):Activate() }
   oItem:cId            := "04001"
   oItem:cBmp           := "gc_worker_group_16"
   oItem:cBmpBig        := "gc_worker_group_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Operarios'
   oItem:cMessage       := 'Acceso a los operarios'
   oItem:bAction        := {|| TOperarios():New( cPatEmp(), cDriver(), oWnd, "04002" ):Activate() }
   oItem:cId            := "04002"
   oItem:cBmp           := "gc_worker2_16"
   oItem:cBmpBig        := "gc_worker2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo  
   oItem:cPrompt        := 'Tipos de horas'
   oItem:cMessage       := 'Acceso a tipos de horas de producción'
   oItem:bAction        := {|| THoras():New( cPatEmp(), cDriver(), oWnd, "04003" ):Activate() }
   oItem:cId            := "04003"
   oItem:cBmp           := "gc_worker2_clock_16"
   oItem:cBmpBig        := "gc_worker2_clock_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Operaciones'
   oItem:cMessage       := 'Acceso a las operaciones'
   oItem:bAction        := {|| TOperacion():New( cPatEmp(), cDriver(), oWnd, "04004" ):Activate() }
   oItem:cId            := "04004"
   oItem:cBmp           := "gc_worker2_hammer_16"
   oItem:cBmpBig        := "gc_worker2_hammer_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos de operaciones'
   oItem:cMessage       := 'Acceso a tipos de operaciones'
   oItem:bAction        := {|| TTipOpera():New( cPatEmp(), cDriver(), oWnd, "04005" ):Activate() }
   oItem:cId            := "04005"
   oItem:cBmp           := "gc_folder_open_worker_16"
   oItem:cBmpBig        := "gc_folder_open_worker_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Maquinaria'
   oItem:cMessage       := 'Acceso a la maquinaria'
   oItem:bAction        := {|| StartTMaquina() }
   oItem:cId            := "04006"
   oItem:cBmp           := "gc_industrial_robot_16"
   oItem:cBmpBig        := "gc_industrial_robot_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Costes maquinaria'
   oItem:cMessage       := 'Acceso a los costes de la maquinaria'
   oItem:bAction        := {|| TCosMaq():New( cPatEmp(), cDriver(), oWnd, "04007" ):Activate() }
   oItem:cId            := "04007"
   oItem:cBmp           := "gc_industrial_robot_money_16"
   oItem:cBmpBig        := "gc_industrial_robot_money_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Producción'
   oGrupo:cLittleBitmap := "gc_document_text_worker_16"
   oGrupo:cBigBitmap    := "gc_document_text_worker_32"

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Partes producción'
   oItem:cMessage       := 'Acceso a los partes de producción'
   oItem:bAction        := {|| StartTProduccion( cDriver()) }
   oItem:cId            := "04008"
   oItem:cBmp           := "gc_document_text_worker_16"
   oItem:cBmpBig        := "gc_document_text_worker_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Costos mano obra'
   oItem:cMessage       := 'Actualiza costos de mano de obra'
   oItem:bAction        := {|| ActualizaCosto():Activate( "04009", oWnd ) }
   oItem:cId            := "04009"
   oItem:cBmp           := "gc_worker2_money_16"
   oItem:cBmpBig        := "gc_worker2_money_32"
   oItem:lShow          := .f.

   end if

   // Producción---------------------------------------------------------------

   if IsProfesional()

   oItemExpediente            := oAcceso:Add()
   oItemExpediente:cPrompt    := 'EXPEDIENTES'
   oItemExpediente:cBmp       := "gc_folder_open_16"
   oItemExpediente:cBmpBig    := "gc_folder_open_32"
   oItemExpediente:lShow      := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Expedientes'
   oGrupo:cLittleBitmap := "gc_folder_document_16"
   oGrupo:cBigBitmap    := "gc_folder_document_32"

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipo expediente'
   oItem:cMessage       := 'Acceso a los tipos de expedientes'
   oItem:bAction        := {|| StartTTipoExpediente() }
   oItem:cId            := "04011"
   oItem:cBmp           := "gc_folders_16"
   oItem:cBmpBig        := "gc_folders_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Entidades'
   oItem:cMessage       := 'Acceso a las distintas entidades'
   oItem:bAction        := {|| TEntidades():New( cPatEmp(), cDriver(), oWnd, "04012" ):Activate() }
   oItem:cId            := "04012"
   oItem:cBmp           := "gc_office_building2_16"
   oItem:cBmpBig        := "gc_office_building2_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Colaboradores'
   oItem:cMessage       := 'Acceso a la tabla de colaboradores'
   oItem:bAction        := {|| TColaboradores():New( cPatEmp(), cDriver(), oWnd, "04013" ):Activate() }
   oItem:cId            := "04013"
   oItem:cBmp           := "gc_users_relation_16"
   oItem:cBmpBig        := "gc_users_relation_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Actuaciones'
   oItem:cMessage       := 'Acceso a la tabla de actuaciones'
   oItem:bAction        := {|| TActuaciones():New( cPatEmp(), cDriver(), oWnd, "04014" ):Activate() }
   oItem:cId            := "04014"
   oItem:cBmp           := "gc_power_drill2_16"
   oItem:cBmpBig        := "gc_power_drill2_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Expedientes'
   oItem:cMessage       := 'Acceso a los expedientes'
   oItem:bAction        := {|| StartTExpediente() }
   oItem:cId            := "04010"
   oItem:cBmp           := "gc_folder_document_16"
   oItem:cBmpBig        := "gc_folder_document_32"
   oItem:lShow          := .f.

   end if

   // Ventas-------------------------------------------------------------------

   oItemVentas          := oAcceso:Add()
   oItemVentas:cPrompt  := 'VENTAS'
   oItemVentas:cBmp     := "gc_folder_open_16"
   oItemVentas:cBmpBig  := "gc_folder_open_32"
   oItemVentas:lShow    := .t.

   // Clientes----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := If( IsProfesional(), 7, 4 )
   oGrupo:cPrompt       := 'Clientes'
   oGrupo:cLittleBitmap := "gc_user_16"
   oGrupo:cBigBitmap    := "gc_user_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos'
   oItem:cMessage       := 'Acceso a los grupos de clientes'
   oItem:bAction        := {|| TGrpCli():New( cPatCli(), cDriver(), oWnd, "01030" ):Activate() }
   oItem:cId            := "01030"
   oItem:cBmp           := "gc_users3_16"
   oItem:cBmpBig        := "gc_users3_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Rutas'
   oItem:cMessage       := 'Acceso a las rutas de clientes'
   oItem:bAction        := {|| Ruta( "01031", oWnd ) }
   oItem:cId            := "01031"
   oItem:cBmp           := "gc_signpost2_16"
   oItem:cBmpBig        := "gc_signpost2_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Clientes'
   oItem:cMessage       := 'Acceso a las rutas de clientes'
   oItem:bAction        := {|| Client( "01032", oWnd ) }
   oItem:cId            := "01032"
   oItem:cBmp           := "gc_user_16"
   oItem:cBmpBig        := "gc_user_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Agentes'
   oItem:cMessage       := 'Acceso a los agentes'
   oItem:bAction        := {|| Agentes( "01033", oWnd ) }
   oItem:cId            := "01033"
   oItem:cBmp           := "gc_businessman2_16"
   oItem:cBmpBig        := "gc_businessman2_32"
   oItem:lShow          := .f.

   if IsProfesional()

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Programa de fidelización'
   oItem:cMessage       := 'Acceso al programa de fidelización'
   oItem:bAction        := {|| StartTFideliza() }
   oItem:cId            := "04006"
   oItem:cBmp           := "gc_id_card_16"
   oItem:cBmpBig        := "gc_id_card_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupo de plantillas'
   oItem:cMessage       := 'Acceso a grupos de plantillas automáticas'
   oItem:bAction        := {|| TGrpFacturasAutomaticas():New( cPatCli(), oWnd, "04018" ):Activate() }
   oItem:cId            := "04018"
   oItem:cBmp           := "gc_folder_gear_16"
   oItem:cBmpBig        := "gc_folder_gear_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Plantillas automáticas'
   oItem:cMessage       := 'Acceso a plantillas de ventas automáticas'
   oItem:bAction        := {|| StartTFacAutomatica() }
   oItem:cId            := "04017"
   oItem:cBmp           := "gc_document_text_gear_16"
   oItem:cBmpBig        := "gc_document_text_gear_32" 
   oItem:lShow          := .f.

   end if

   // Ventas-------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 8
   oGrupo:cPrompt       := 'Ventas'
   oGrupo:cLittleBitmap := "gc_notebook_user_16"
   oGrupo:cBigBitmap    := "gc_notebook_user_32"

   if IsStandard()

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'S.A.T.'
   oItem:cMessage       := 'Acceso al S.A.T. de clientes'
   oItem:bAction        := {|| SatCli( "01098", oWnd ) }
   oItem:cId            := "01098"
   oItem:cBmp           := "gc_power_drill_sat_user_16"
   oItem:cBmpBig        := "gc_power_drill_sat_user_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Presupuesto'
   oItem:cMessage       := 'Acceso a los presupuestos de clientes'
   oItem:bAction        := {|| PreCli( "01055", oWnd ) }
   oItem:cId            := "01055"
   oItem:cBmp           := "gc_notebook_user_16"
   oItem:cBmpBig        := "gc_notebook_user_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pedidos'
   oItem:cMessage       := 'Acceso a los pedidos de clientes'
   oItem:bAction        := {|| PedCli( "01056", oWnd ) }
   oItem:cId            := "01056"
   oItem:cBmp           := "gc_clipboard_empty_user_16"
   oItem:cBmpBig        := "gc_clipboard_empty_user_32"
   oItem:lShow          := .f.

   end if

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Albaranes'
   oItem:cMessage       := 'Acceso a los albaranes de clientes'
   oItem:bAction        := {|| AlbCli( "01057", oWnd ) }
   oItem:cId            := "01057"
   oItem:cBmp           := "gc_document_empty_16"
   oItem:cBmpBig        := "gc_document_empty_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas'
   oItem:cMessage       := 'Acceso a las facturas de clientes'
   oItem:bAction        := {|| FactCli( "01058", oWnd ) }
   oItem:cId            := "01058"
   oItem:cBmp           := "gc_document_text_user_16"
   oItem:cBmpBig        := "gc_document_text_user_32"
   oItem:lShow          := .t.

   if IsStandard()

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas anticipos'
   oItem:cMessage       := 'Acceso a las facturas de anticipos de clientes'
   oItem:bAction        := {|| FacAntCli( "01181", oWnd ) }
   oItem:cId            := "01181"
   oItem:cBmp           := "gc_document_text_money2_16"
   oItem:cBmpBig        := "gc_document_text_money2_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas rectificativas'
   oItem:cMessage       := 'Acceso a las facturas rectificativas de clientes'
   oItem:bAction        := {|| FacRec( "01182", oWnd ) }
   oItem:cId            := "01182"
   oItem:cBmp           := "gc_document_text_delete_16"
   oItem:cBmpBig        := "gc_document_text_delete_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ordenes de carga'
   oItem:cMessage       := 'Acceso a las ordenes de carga'
   oItem:bAction        := {|| TOrdCarga():New( cPatEmp(), "01062", oWnd ):Activate() }
   oItem:cId            := "01062"
   oItem:cBmp           := "gc_small_truck_user_16"
   oItem:cBmpBig        := "gc_small_truck_user_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:cPrompt       := 'Cobros'
   oGrupo:cLittleBitmap := "gc_briefcase2_user_16"
   oGrupo:cBigBitmap    := "gc_briefcase2_user_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Recibos'
   oItem:cMessage       := 'Acceso a los recibos de clientes'
   oItem:bAction        := {|| RecCli( "01059", oWnd ) }
   oItem:cId            := "01059"
   oItem:cBmp           := "gc_briefcase2_user_16"
   oItem:cBmpBig        := "gc_briefcase2_user_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Remesas bancarias'
   oItem:cMessage       := 'Acceso a las remesas bancarias'
   oItem:bAction        := {|| TRemesas():New( cPatEmp(), "01060", oWnd ):Activate() }
   oItem:cId            := "01060"
   oItem:cBmp           := "gc_briefcase2_document_16"
   oItem:cBmpBig        := "gc_briefcase2_document_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Liquidación de agentes'
   oItem:cMessage       := 'Acceso a las liquidaciones de agentes'
   oItem:bAction        := {|| StartTCobAge() }
   oItem:cId            := "01061"
   oItem:cBmp           := "gc_briefcase2_agent_16"
   oItem:cBmpBig        := "gc_briefcase2_agent_32"
   oItem:lShow          := .t.

   end if

   if IsOsCommerce()

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Comercio electrónico'
   oGrupo:cLittleBitmap := "gc_earth_money_16"
   oGrupo:cBigBitmap    := "gc_earth_money_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Comercio electrónico'
   oItem:cMessage       := 'Comercio electrónico'
   oItem:bAction        := {|| TComercio():New():dialogActivate() }
   oItem:cId            := "01108"
   oItem:cBmp           := "gc_earth_money_16"
   oItem:cBmpBig        := "gc_earth_money_32"
   oItem:lShow          := .f.

   end if

   // TPV----------------------------------------------------------------------

   oItemTpv             := oAcceso:Add()
   oItemTpv:cPrompt     := 'T.P.V.'
   oItemTpv:cBmp        := "gc_folder_open_16"
   oItemTpv:cBmpBig     := "gc_folder_open_32"
   oItemTpv:lShow       := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := 'T.P.V.'
   oGrupo:cLittleBitmap := "gc_cash_register_user_16"
   oGrupo:cBigBitmap    := "gc_cash_register_user_32"

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'T.P.V.'
   oItem:cMessage       := 'Acceso a terminal punto de venta'
   oItem:bAction        := {|| FrontTpv( "01063", oWnd ) }
   oItem:cId            := "01063"
   oItem:cBmp           := "gc_cash_register_user_16"
   oItem:cBmpBig        := "gc_cash_register_user_32"
   oItem:lShow          := .t.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'T.P.V. táctil'
   oItem:cMessage       := 'Acceso a terminal punto de venta táctil'
   oItem:bAction        := {|| TpvTactil():New():Activate() } // TactilTpv( "01064", oWnd ) }  // {|| TpvTactil():New( oWnd, "01116" ):Activate() } //
   oItem:cId            := "01064"
   oItem:cBmp           := "gc_cash_register_touch_16"
   oItem:cBmpBig        := "gc_cash_register_touch_32"
   oItem:lShow          := .f.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Entradas y salidas'
   oItem:cMessage       := 'Acceso a las entradas y salidas de caja'
   oItem:bAction        := {|| EntSal( "01065", oWnd ) }
   oItem:cId            := "01065"
   oItem:cBmp           := "gc_cash_register_refresh_16"
   oItem:cBmpBig        := "gc_cash_register_refresh_32"
   oItem:lShow          := .f.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Sala de ventas'
   oItem:cMessage       := 'Sala de ventas'
   oItem:bAction        := {|| TTpvRestaurante():New( cPatEmp(), cDriver(), oWnd, "01105" ):Activate() }
   oItem:cId            := "01105"
   oItem:cBmp           := "gc_cup_16"
   oItem:cBmpBig        := "gc_cup_32"
   oItem:lShow          := .f.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Invitaciones'
   oItem:cMessage       := 'Acceso a los tipos de invitaciones'
   oItem:bAction        := {|| TInvitacion():New( cPatEmp(), oWnd, "01107" ):Activate() }
   oItem:cId            := "01107"
   oItem:cBmp           := "gc_masks_16"
   oItem:cBmpBig        := "gc_masks_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ordenes de comanda'
   oItem:cMessage       := 'Acceso a los comentarios de los artículos'
   oItem:bAction        := {|| TOrdenComanda():New( cPatArt(), oWnd, "01093" ):Activate() }
   oItem:cId            := "01093"
   oItem:cBmp           := "gc_sort_az_descending_16"
   oItem:cBmpBig        := "gc_sort_az_descending_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Menús'
   oItem:cMessage       := 'Acceso a los menús'
   oItem:bAction        := {|| TpvMenu():New( cPatEmp(), oWnd ):Activate() }
   oItem:cId            := "01200"
   oItem:cBmp           := "gc_clipboard_empty_16"
   oItem:cBmpBig        := "gc_clipboard_empty_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Útiles'
   oGrupo:cLittleBitmap := "gc_window_pencil_16"
   oGrupo:cBigBitmap    := "gc_window_pencil_32"

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Capturas T.P.V.'
   oItem:cMessage       := 'Capturas T.P.V.'
   oItem:bAction        := {|| TCaptura():New( cPatDat(), oWnd, "01083" ):Activate() }
   oItem:cId            := "01083"
   oItem:cBmp           := "gc_window_pencil_16"
   oItem:cBmpBig        := "gc_window_pencil_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Balanzas'
   oItem:cMessage       := 'Balanzas'
   oItem:bAction        := {|| ConfImpTiket( "01090", oWnd ) }
   oItem:cId            := "01090"
   oItem:cBmp           := "gc_balance_16"
   oItem:cBmpBig        := "gc_balance_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Configurar visor'
   oItem:cMessage       := 'Configurar visor'
   oItem:bAction        := {|| ConfVisor( "01092", oWnd ) }
   oItem:cId            := "01092"
   oItem:cBmp           := "gc_odometer_screw_16"
   oItem:cBmpBig        := "gc_odometer_screw_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cajón portamonedas'
   oItem:cMessage       := 'Cajón portamonedas'
   oItem:bAction        := {|| ConfCajPorta( "01091", oWnd ) }
   oItem:cId            := "01091"
   oItem:cBmp           := "gc_modem_screw_16"
   oItem:cBmpBig        := "gc_modem_screw_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Herramientas-------------------------------------------------------------

   oItemHerramientas          := oAcceso:Add()
   oItemHerramientas:cPrompt  := 'HERRAMIENTAS'
   oItemHerramientas:cBmp     := "gc_folder_open_16"
   oItemHerramientas:cBmpBig  := "gc_folder_open_32"
   oItemHerramientas:lShow    := .t.

   oGrupo               := TGrupoAcceso()

   do case
   case IsOscommerce()
      oGrupo:nBigItems  := 4
   case IsProfesional()
      oGrupo:nBigItems  := 4
   otherwise
      oGrupo:nBigItems  := 3
   end case

   oGrupo:cPrompt       := 'Herramientas'
   oGrupo:cLittleBitmap := "gc_document_text_screw_16"
   oGrupo:cBigBitmap    := "gc_document_text_screw_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Usuarios y grupos'
   oItem:cMessage       := 'Acceso a los usuarios del programa'
   oItem:bAction        := {|| Usuarios( "01074", oWnd ) }
   oItem:cId            := "01074"
   oItem:cBmp           := "gc_businesspeople_16"
   oItem:cBmpBig        := "gc_businesspeople_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Documentos y etiquetas'
   oItem:cMessage       := 'Configurar documentos y etiquetas'
   oItem:bAction        := {|| CfgDocs( "01068", oWnd ) }
   oItem:cId            := "01068"
   oItem:cBmp           := "gc_document_text_screw_16"
   oItem:cBmpBig        := "gc_document_text_screw_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Especificar impresora'
   oItem:cMessage       := 'Especificar impresora por defecto'
   oItem:bAction        := {|| PrinterSetup() }
   oItem:cId            := "01082"
   oItem:cBmp           := "gc_printer2_check_16"
   oItem:cBmpBig        := "gc_printer2_check_32"
   oItem:lShow          := .f.

   if IsProfesional()

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Centro de contabilización'
   oItem:cMessage       := 'Centro de contabilización'
   oItem:bAction        := {|| TTurno():Build( cPatEmp(), cDriver(), oWnd, "01086" ) }
   oItem:cId            := "01086"
   oItem:cBmp           := "gc_folders2_16"
   oItem:cBmpBig        := "gc_folders2_32"
   oItem:lShow          := .f.

   end if

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Útiles'
   oGrupo:cLittleBitmap := "gc_notebook2_16"
   oGrupo:cBigBitmap    := "gc_notebook2_32"

   oItem                := oItemHerramientas:Add()    
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Campos extra'
   oItem:cMessage       := 'Acceso a los campos extra'
   oItem:bAction        := {|| CamposExtra( "01127", oWnd ) } 
   oItem:cId            := "01127"
   oItem:cBmp           := "gc_form_plus2_16"
   oItem:cBmpBig        := "gc_form_plus2_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Agenda/ CRM'
   oItem:cMessage       := 'Acceso a la agenda del usuario'
   oItem:bAction        := {|| TNotas():New( cPatDat(), , oWnd, "01075" ):Activate() }
   oItem:cId            := "01075"
   oItem:cBmp           := "gc_notebook2_16"
   oItem:cBmpBig        := "gc_notebook2_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Listín telefónico'
   oItem:cMessage       := 'Acceso al listín telefónico'
   oItem:bAction        := {|| TAgenda():New( cPatDat(), , oWnd, "01076" ):Activate() }
   oItem:cId            := "01076"
   oItem:cBmp           := "gc_book_telephone_16"
   oItem:cBmpBig        := "gc_book_telephone_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Scripts'
   oItem:cMessage       := 'Ejecutar scripts'
   oItem:bAction        := {|| TScripts():New( cPatEmp(), , oWnd, "01117" ):Activate() }
   oItem:cId            := "01117"
   oItem:cBmp           := "gc_code_line_16"
   oItem:cBmpBig        := "gc_code_line_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Archivos'
   oGrupo:cLittleBitmap := "gc_shield_16"
   oGrupo:cBigBitmap    := "gc_shield_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Regenerar índices'
   oItem:cMessage       := 'Regenerar índices'
   oItem:bAction        := {|| Reindexa() }
   oItem:cId            := "01067"
   oItem:cBmp           := "gc_recycle_16"
   oItem:cBmpBig        := "gc_recycle_32"
   oItem:lShow          := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Copia seguridad'
   oItem:cMessage       := 'Copia seguridad'
   oItem:bAction        := {|| TBackup():New( "01077", oWnd ) }
   oItem:cId            := "01077"
   oItem:cBmp           := "gc_shield_16"
   oItem:cBmpBig        := "gc_shield_32"
   oItem:lShow          := .t.

   if isProfesional()

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Exportaciones e importaciones'
   oGrupo:cLittleBitmap := "gc_satellite_dish2_16"
   oGrupo:cBigBitmap    := "gc_satellite_dish2_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Envío y recepción'
   oItem:cMessage       := 'Envío y recepción de información a las delegaciones'
   oItem:bAction        := {|| TSndRecInf():New( "01078", oWnd ):Activate() }
   oItem:cId            := "01078"
   oItem:cBmp           := "gc_satellite_dish2_16"
   oItem:cBmpBig        := "gc_satellite_dish2_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Terminales'
   oItem:cMessage       := 'Exportar e importar datos a terminales'
   oItem:bAction        := {|| TEdm():Activate( "01079", oWnd ) }
   oItem:cId            := "01079"
   oItem:cBmp           := "gc_pda_16"
   oItem:cBmpBig        := "gc_pda_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Factuplus®'
   oItem:cMessage       := 'Imp. factuplus®'
   oItem:bAction        := {|| ImpFactu( "01080", oWnd ) }
   oItem:cId            := "01080"
   oItem:cBmp           := "gc_inbox_into_16"
   oItem:cBmpBig        := "gc_inbox_into_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Factucont®'
   oItem:cMessage       := 'Imp. factucont®'
   oItem:bAction        := {|| ImpFacCom( "01100", oWnd ) }
   oItem:cId            := "01100"
   oItem:cBmp           := "gc_inbox_into_16"
   oItem:cBmpBig        := "gc_inbox_into_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tarifas artículos'
   oItem:cMessage       := 'Importa tarifa de artículos desde Excel'
   oItem:bAction        := {|| TImpEstudio():New( "01102", oWnd ):Activate() }
   oItem:cId            := "01102"
   oItem:cBmp           := "gc_inbox_into_16"
   oItem:cBmpBig        := "gc_inbox_into_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   end if

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:nBigItems++
   oGrupo:cPrompt       := 'Extras'
   oGrupo:cLittleBitmap := "gc_magic_wand_16"
   oGrupo:cBigBitmap    := "gc_magic_wand_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Actualizar precios'
   oItem:cMessage       := 'Actualizar precios de tarifas'
   oItem:bAction        := {|| ChgTarifa( "01081", oWnd ) }
   oItem:cId            := "01081"
   oItem:cBmp           := "gc_table_selection_column_refresh_16"
   oItem:cBmpBig        := "gc_table_selection_column_refresh_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Configurar botones'
   oItem:cMessage       := 'Configurar barra de botones'
   oItem:bAction        := {|| oWndBar():EditButtonBar( oWnd, "01085" ) }
   oItem:cId            := "01085"
   oItem:cBmp           := "gc_magic_wand_16"
   oItem:cBmpBig        := "gc_magic_wand_32"
   oItem:lShow          := .f.
   oItem:lHide          := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Calculadora'
   oItem:cMessage       := 'Ejecuta la calculadora de windows'
   oItem:bAction        := {|| WinExec( "Calc" ) }
   oItem:cId            := "01083"
   oItem:cBmp           := "gc_calculator_16"
   oItem:cBmpBig        := "gc_calculator_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Fecha trabajo'
   oItem:cMessage       := 'Selecciona la fecha de trabajo'
   oItem:bAction        := {|| SelSysDate( "01084" ) }
   oItem:cId            := "01084"
   oItem:cBmp           := "gc_calendar_16"
   oItem:cBmpBig        := "gc_calendar_32"
   oItem:lShow          := .f.

   if GetPvProfString( "OPCIONES", "CambiarCodigos", ".F.", cIniAplication() ) == ".T."

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cambiar códigos'
   oItem:cMessage       := 'Cambia códigos'
   oItem:bAction        := {|| TChgCode():New( "01080", oWnd ):Resource() }
   oItem:cId            := "01080"
   oItem:cBmp           := "gc_calendar_16"
   oItem:cBmpBig        := "gc_calendar_32"
   oItem:lShow          := .f.

   end if

   // Reporting----------------------------------------------------------------

   oItemReporting          := oAcceso:Add()
   oItemReporting:cPrompt  := 'INFORMES'
   oItemReporting:cBmp     := "gc_folder_open_16"
   oItemReporting:cBmpBig  := "gc_folder_open_32"
   oItemReporting:lShow    := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Informes'
   oGrupo:cLittleBitmap := "gc_lifebelt_16"
   oGrupo:cBigBitmap    := "gc_lifebelt_32"

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Galería de informes'
   oItem:cMessage       := 'Galería de informes'
   oItem:bAction        := {|| RunReportGalery() }
   oItem:cId            := "01119"
   oItem:cBmp           := "gc_cabinet_open_16"
   oItem:cBmpBig        := "gc_cabinet_open_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Informes personalizables'
   oGrupo:cLittleBitmap := "gc_object_cube_print_16"
   oGrupo:cBigBitmap    := "gc_object_cube_print_32"

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Artículos'
   oItem:cMessage       := 'Informes realacionados con articulos'
   oItem:bAction        := {|| runFastGallery( "Articulos" ) }
   oItem:cId            := "01118"
   oItem:cBmp           := "gc_object_cube_print_16"
   oItem:cBmpBig        := "gc_object_cube_print_32"
   oItem:lShow          := .f.

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Clientes'
   oItem:cMessage       := 'Informes realacionados con clientes'
   oItem:bAction        := {|| runFastGallery( "Clientes" ) }
   oItem:cId            := "01120"
   oItem:cBmp           := "gc_user_print_16"
   oItem:cBmpBig        := "gc_user_print_32"
   oItem:lShow          := .f.

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Proveedores'
   oItem:cMessage       := 'Informes realacionados con proveedores'
   oItem:bAction        := {|| runFastGallery( "Proveedores" ) }
   oItem:cId            := "01121"
   oItem:cBmp           := "gc_businessman_print_16"
   oItem:cBmpBig        := "gc_businessman_print_32"
   oItem:lShow          := .f.

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Producción'
   oItem:cMessage       := 'Informes realacionados con la producción'
   oItem:bAction        := {|| runFastGallery( "Produccion" ) }
   oItem:cId            := "01123"
   oItem:cBmp           := "gc_worker2_print_16"
   oItem:cBmpBig        := "gc_worker2_print_32"
   oItem:lShow          := .f.

   /*if lAIS()

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Auditor'
   oGrupo:cLittleBitmap := "gc_lifebelt_16"
   oGrupo:cBigBitmap    := "gc_lifebelt_32"

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Auditoria'
   oItem:cMessage       := 'Auditoria'
   oItem:bAction        := {|| TDataCenter():Auditor() }
   oItem:cId            := "01122"
   oItem:cBmp           := "gc_document_empty_chart_16"
   oItem:cBmpBig        := "gc_document_empty_chart_32"
   oItem:lShow          := .f.

   end if */

   // Ayudas-------------------------------------------------------------------

   oItemAyudas          := oAcceso:Add()
   oItemAyudas:cPrompt  := 'AYUDAS'
   oItemAyudas:cBmp     := "gc_folder_open_16"
   oItemAyudas:cBmpBig  := "gc_folder_open_32"
   oItemAyudas:lShow    := .t.

   oGrupo               := TGrupoAcceso()

   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Ayudas'
   oGrupo:cLittleBitmap := "gc_lifebelt_16"
   oGrupo:cBigBitmap    := "gc_lifebelt_32"

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Visitar web'
   oItem:cMessage       := 'Visitar web'
   oItem:bAction        := {|| goWeb( __GSTWEB__ ) }
   oItem:cId            := "01094"
   oItem:cBmp           := "gc_earth_16"
   oItem:cBmpBig        := "gc_earth_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Acerca de...'
   oItem:cMessage       := 'Datos sobre el autor'
   oItem:bAction        := {|| About() }
   oItem:cId            := "01096"
   oItem:cBmp           := "gc_question_16"
   oItem:cBmpBig        := "gc_question_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "gc_user_headset_16"
   oItem:cBmpBig        := "gc_user_headset_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Test'
   oItem:cMessage       := 'Test'
   oItem:bAction        := {||TiposImpresorasController():New():ActivateNavigatorView() }
   oItem:cId            := "99999"
   oItem:cBmp           := "gc_user_headset_16"
   oItem:cBmpBig        := "gc_user_headset_32"
   oItem:lShow          := .f.

RETURN ( oAcceso )

//---------------------------------------------------------------------------//

FUNCTION IsReport()

RETURN ( .f. )

//---------------------------------------------------------------------------//

FUNCTION validRunReport( nLevel )

   if nAnd( nLevelUsr( nLevel ), 1 ) != 0
      msgStop( "Acceso no permitido." )
      RETURN .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION cBmpVersion() 

   if isNil( cBmpVersion )

      do case
         case file( FullCurDir() + "scmmrc" )

            cBmpVersion      := "gc_GestoolPrestashop"

         case file( FullCurDir() + "prfsnl" )

            cBmpVersion      := "GestoolPro"

         case file( FullCurDir() + "stndrd" )

            cBmpVersion      := "GestoolStandard"

         otherwise

            cBmpVersion      := "GestoolLite"

      end case

   end if

RETURN ( cBmpVersion ) 

//---------------------------------------------------------------------------//
/*
Guardamos el nombre de la versión
*/

FUNCTION cNameVersion()

   if IsNil( cNameVersion )

      do case
         case File( FullCurDir() + "scmmrc" )

            cNameVersion      := "PrestaShop 1.6"

         case File( FullCurDir() + "prfsnl" )

            cNameVersion      := "Profesional"

         case File( FullCurDir() + "stndrd" )

            cNameVersion      := "Standard"

         otherwise

            cNameVersion      := "Lite"

      end case

   end if

RETURN ( cNameVersion )

//---------------------------------------------------------------------------//

FUNCTION cTypeVersion( cType )

   if !empty( cType )
      cTypeVersion   := cType
   end if 

RETURN ( cTypeVersion )

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Oscommerce
*/

FUNCTION IsOsCommerce()

   if IsNil( lOsCommerce )

      if File( FullCurDir() + "scmmrc" )
         lOsCommerce       := .t.
      else
         lOsCommerce       := .f.
      end if

   end if

RETURN lOsCommerce

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Profesional
*/

FUNCTION IsProfesional()

   if IsNil( lProfesional )

      if File( FullCurDir() + "scmmrc" ) .or.;
         File( FullCurDir() + "prfsnl" )
         lProfesional     := .t.
      else
         lProfesional      := .f.
      end if

   end if

RETURN lProfesional

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Standard
*/

FUNCTION IsStandard()

   if IsNil( lStandard )

      if File( FullCurDir() + "scmmrc" ) .or.; 
         File( FullCurDir() + "prfsnl" ) .or.;
         File( FullCurDir() + "stndrd" )

         lStandard     := .t.

      else
         lStandard     := .f.
      end if

   end if

RETURN lStandard

//---------------------------------------------------------------------------//

FUNCTION appCheckDirectory()

   if( !lIsDir( cPatDat() ),           makedir( cNamePath( cPatDat() ) ), )
   if( !lIsDir( cPatADS() ),           makedir( cNamePath( cPatADS() ) ), )
   if( !lIsDir( cPatIn()  ),           makedir( cNamePath( cPatIn()  ) ), )
   if( !lIsDir( cPatTmp() ),           makedir( cNamePath( cPatTmp() ) ), )   
   if( !lIsDir( cPatInFrq() ),         makedir( cNamePath( cPatInFrq() ) ), )
   if( !lIsDir( cPatOut() ),           makedir( cNamePath( cPatOut() ) ), )
   if( !lIsDir( cPatSnd() ),           makedir( cNamePath( cPatSnd() ) ), )
   if( !lIsDir( cPatLog() ),           makedir( cNamePath( cPatLog() ) ), )
   if( !lIsDir( cPatBmp() ),           makedir( cNamePath( cPatBmp() ) ), )
   if( !lIsDir( cPatHtml() ),          makedir( cNamePath( cPatHtml() ) ), )
   if( !lIsDir( cPatXml() ),           makedir( cNamePath( cPatXml() ) ), )
   if( !lIsDir( cPatSafe() ),          makedir( cNamePath( cPatSafe() ) ), )
   if( !lIsDir( cPatPsion() ),         makedir( cNamePath( cPatPsion() ) ), )
   if( !lIsDir( cPatEmpTmp() ),        makedir( cNamePath( cPatEmpTmp() ) ), )
   if( !lIsDir( cPatScript() ),        makedir( cNamePath( cPatScript() ) ), )
   if( !lIsDir( cPatReporting() ),     makedir( cNamePath( cPatReporting() ) ), )
   if( !lIsDir( cPatUserReporting() ), makedir( cNamePath( cPatUserReporting() ) ), )
   if( !lIsDir( cPatConfig() ),        makedir( cNamePath( cPatConfig() ) ), )
   if( !lIsDir( cPatDat() ),           makedir( cNamePath( cPatDat() ) ), )

   // Elimina los temporales de la aplicación----------------------------------

   eraseFilesInDirectory( cPatTmp(), "*.*" )
   eraseFilesInDirectory( cPatLog(), "*.*" )

RETURN ( nil )

//---------------------------------------------------------------------------//

/*
Ejecuta un fichero .hrb creado a partir de un .prg
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

FUNCTION Ejecutascript()

   local aScripts
   local cScript  := ""
   Local pHrb
   Local u
   Local dFecha

   /*
   Comprobaciones iniciales antes de mandar el script--------------------------
   */

   dFecha         := cToD( GetPvProfString( "SCRIPT", "Fecha",    "", cIniAplication() ) )

   /*
   Ejecutamos el script-----------------------------------------------
   */

   if dFecha  < GetSysDate()

      aScripts    := Directory( cPatScript() + "*.hrb" )
      if len( aScripts ) > 0
         for each cScript in aScripts
            TScripts():RunScript( cPatScript() + cScript[1] )
         next
      end if

   end if

   /*
   Anotamos la fecha del último Envío de  script--------------------------------
   */

   WritePProString( "SCRIPT", "Fecha", Dtoc( GetSysDate() ), cIniAplication() )

RETURN u

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg directamente
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

FUNCTION DirectEjecutaScript()

   Local u
   Local pHrb
   local aScripts
   local cScript  := ""

   /*
   Cerramos todas las ventanas antes de entrar---------------------------------
   */

   if !empty( oWnd() )
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   /*
   Comprobaciones iniciales antes de mandar el script--------------------------
   */

   aScripts       := Directory( cPatScript() + "*.hrb" )

   if Len( aScripts ) > 0

      for each cScript in aScripts

         TScripts():RunScript( cPatScript() + cScript[1] )

      next

   end if

RETURN u

//---------------------------------------------------------------------------//

FUNCTION InitClasses()

   TShell()
   TAgenda()
   TDbf()
   TIndex()
   TInfGen()
   TMant()
   TMasDet()
   TDet()
   TCatalogo()
   TGrpCli()
   TInfoArticulo()
   TSndRecInf()
   TNotas()
   TOrdCarga()
   TPais()
   TLenguaje()
   TReindex()
   TRemesas()
   TRemMovAlm()
   TCamposExtra()
   TInfRemMov()
   TStock()
   TDeleleteObsoletos()
   TInternet()
   TSeaNumSer()
   TTrazarLote()
   TAlbaranesClientesSenderReciver()
   TAlbaranesProveedorSenderReciver()
   TArticuloSenderReciver()
   TFacturasClientesSenderReciver()
   TFacturasProveedorSenderReciver()
   TTiketsClientesSenderReciver()
   TClienteSenderReciver()
   TTurno()
   TInvitacion()
   TXBrowse():Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )
   TBandera():New()
   TCentroCoste()

RETURN .t.

//--------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
// Comprobaciones iniciales

FUNCTION lInitCheck( oMessage, oProgress )

   local oError
   local lCheck      := .t.

   CursorWait()

   if !empty( oProgress )
      oProgress:SetTotal( 6  )
   end if

   if !empty( oMessage )
      oMessage:SetText( 'Comprobando directorios' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   // Comprobamos que exista los directorios necesarios------------------------

   appCheckDirectory()

   // Cargamos los datos de la empresa-----------------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Control de tablas de empresa' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   if ( nUsrInUse() == 1 )
      TstEmpresa()
   end if 

   // Cargamos los datos de la divisa------------------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Control de tablas de divisas' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   if ( nUsrInUse() == 1 )
      TstDivisas()
   end if 

   // Cargamos los datos de la cajas-------------------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Control de tablas de cajas' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   if ( nUsrInUse() == 1 )
      TstCajas()
   end if 

   // Inicializamos classes----------------------------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Inicializamos las clases de la aplicación' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   InitClasses()

   // Apertura de ficheros-----------------------------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Selección de la empresa actual' ) 
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   setEmpresa()

   // Eventos del inicio---------------------------------

   runEventScript( "IniciarAplicacion" )

   if !empty( oMessage )
      oMessage:SetText( 'Comprobaciones finalizadas' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   CursorWe()

RETURN ( lCheck )

//---------------------------------------------------------------------------//

FUNCTION InitServices()

   // Colocamos los avisos pa las notas----------------------------------------

   if oUser():lAlerta()
      SetNotas()
   end if

   TScripts():New( cPatEmp() ):StartTimer()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION StopServices()
 
   // Informe rapido de articulos----------------------------------------------

   CloseInfoArticulo()

   // Quitamos los avisos pa las notas-----------------------------------------

   if oUser():lAlerta()
      CloseNotas()
   end if

   TScripts():EndTimer()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION lDemoMode( lDemo )

   if lDemo != nil
      lDemoMode   := lDemo
   end if

RETURN ( lDemoMode )

//---------------------------------------------------------------------------//

FUNCTION nAjuste( nNumber, cAdjust )

   local n
   local nAjusteDecimales
   local nAjusteIncrementa
   local nAjusteDecrementa
   local cNumber
   local nResult
   local cResult
   local aAdjust
   local aNumber        := {}

   if empty( nNumber )
      RETURN ( 0 )
   end if 

   /*
   Posible ajuste doble--------------------------------------------------------
   */

   nResult              := 0
   aAdjust              := hb_aTokens( cAdjust, "|" )

   for each cAdjust in aAdjust

      nAjusteDecimales  := nAjusteDecimales( cAdjust )
      nAjusteIncrementa := nAjusteIncrementa( cAdjust )
      nAjusteDecrementa := nAjusteDecrementa( cAdjust )

      if !empty(nAjusteDecimales)

        nResult         := Round( nNumber, nAjusteDecimales )

        if nResult - nNumber > 0
           nResult      += nAjusteDecrementa
        else 
           nResult      += nAjusteIncrementa 
        end if 

        aAdd( aNumber, nResult )

      end if 

   next 

   for each n in aNumber
      if ( ( n - nNumber ) >= -0.000001 )
         nResult        := n
         exit 
      end if 
   next

RETURN ( nResult )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteDecimales( cAjuste )

  local hAjuste
  local nAjusteDecimales

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteDecimales  := hGet( hAjuste, "Round" )
    end if
  end if

RETURN ( nAjusteDecimales )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteIncrementa( cAjuste )

  local hAjuste
  local nAjusteIncrementa

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteIncrementa := hGet( hAjuste, "Incrementa" )
    end if
  end if

RETURN ( nAjusteIncrementa )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteDecrementa( cAjuste )

  local hAjuste
  local nAjusteDecrementa

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteDecrementa := hGet( hAjuste, "Decrementa" )
    end if
  end if

RETURN ( nAjusteDecrementa )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteCeros( cAjuste )

  local hAjuste
  local nAjusteCeros

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteCeros      := hGet( hAjuste, "Ceros" )
    end if
  end if

RETURN ( nAjusteCeros )

//---------------------------------------------------------------------------//

FUNCTION lAds( lSetAds )

   if IsLogic( lSetAds )
      lAds     := lSetAds
   end if

RETURN ( lAds )

//----------------------------------------------------------------------------//

FUNCTION lAIS( lSetAIS )

   if IsLogic( lSetAIS )
      lAIS     := lSetAIS
   end if

RETURN ( lAIS )

//----------------------------------------------------------------------------//

FUNCTION lAdsRdd()

RETURN ( lAds() .or. lAIS() )

//----------------------------------------------------------------------------//

FUNCTION cFieldTimeStamp()

RETURN ( if( lAdsRdd(), "Timestamp", "T" ) )

//----------------------------------------------------------------------------//

FUNCTION cAdsIp( cSetIp )

   if IsChar( cSetIp )
      cAdsIp      := cSetIp
   end if

RETURN ( cAdsIp )

//----------------------------------------------------------------------------//

FUNCTION cAdsPort( cPort )

   if isChar( cPort )
      cAdsPort  := cPort
   end if 

RETURN ( cAdsPort )

//----------------------------------------------------------------------------//

FUNCTION cAdsData( cSetData )

   if IsChar( cSetData )
      cAdsData  := cSetData
   end if

RETURN ( if( !empty( cAdsData ), cPath( cAdsData ), "" ) )

//----------------------------------------------------------------------------//

FUNCTION nAdsServer( nServer )

   if IsNum( nServer )
      nAdsServer  := nServer
   end if

RETURN ( nAdsServer )

//----------------------------------------------------------------------------//

FUNCTION cAdsUNC()

RETURN ( cAdsIp() + cPath( cAdsData() ) )

//----------------------------------------------------------------------------//

FUNCTION cAdsFile( cFile )

   if ( isChar( cFile ) .and. !empty( cFile ) )
      cAdsFile    := cFile
   end if 

RETURN ( cAdsFile )

//----------------------------------------------------------------------------//

FUNCTION lCdx( lSetCdx )

   if IsLogic( lSetCdx )
      lCdx     := lSetCdx
   end if

RETURN ( lCdx )

//---------------------------------------------------------------------------//

FUNCTION cCodigoAgente( cAgente )

   if IsChar( cAgente )
      cCodigoAgente    := cAgente
   end if

RETURN ( cCodigoAgente )

//----------------------------------------------------------------------------//

FUNCTION lPda()

RETURN ( "PDA" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION SetIndexToADSCDX()

   lCdx( .f. )
   lAIS( .t. )

   RddSetDefault( "ADSCDX" )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION SetIndexToCDX()

   lCdx( .t. )
   lAIS( .f. )
   
   RddSetDefault( "DBFCDX" )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION SetIndexToADS()

   lCdx( .f. )
   lAIS( .t. )

   RddSetDefault( "ADS" )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION cDriver()

   if lAIS() .or. lAds()
      RETURN ( 'ADS' )
   end if

RETURN ( 'DBFCDX' )

//---------------------------------------------------------------------------//

FUNCTION cADSDriver()

RETURN ( 'ADS' )

//---------------------------------------------------------------------------//

FUNCTION isADSDriver( cDriver )

  DEFAULT cDriver   := cDriver()

RETURN ( cDriver == 'ADS' )

//---------------------------------------------------------------------------//

FUNCTION cLocalDriver()

RETURN ( 'DBFCDX' )

//---------------------------------------------------------------------------//

FUNCTION cNombrePc( xValue )

   if !empty( xValue )
      cNombrePc   := xValue
   end if

RETURN ( cNombrePc )

//--------------------------------------------------------------------------//

FUNCTION CacheRecords( cAlias )

   if lAdsRdd()
      ( cAlias )->( AdsCacheRecords( 50 ) )
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cPathDatos()

RETURN ( "Datos" )

//---------------------------------------------------------------------------//

FUNCTION cFullPathEmpresa()

  local cCodigoEmpresa  := ""

  cCodigoEmpresa        += fullCurDir()
  cCodigoEmpresa        += cPatEmp
  cCodigoEmpresa        += "\"
  
RETURN ( cCodigoEmpresa )

//---------------------------------------------------------------------------//

FUNCTION cPatDat( lFull )

   DEFAULT lFull  := .f.

   if lAIS() 
      RETURN ( if( lFull, cAdsUNC() + cPathDatos() + "\", cPathDatos() ) )
   end if

RETURN ( fullCurDir() + cPathDatos() + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatADS( lFull )

   DEFAULT lFull  := .f.

   if lAIS()
      RETURN ( if( lFull, cAdsUNC() + getSinglePathADS(), getSinglePathADS() ) )
   end if

RETURN ( fullCurDir() + getSinglePathADS() )

//----------------------------------------------------------------------------//

FUNCTION getSinglePathADS()

RETURN ( "ADS\" )

//----------------------------------------------------------------------------//

FUNCTION cPatEmpTmp( lShort )

   DEFAULT lShort  := .f.

   if lAds()
      RETURN ( cAdsUNC() + "EmpTmp\" )
   end if

RETURN ( if( !lShort, fullCurDir(), "" ) + "EmpTmp\" )

//----------------------------------------------------------------------------//

FUNCTION cPatEmpOld( cCodEmp )

   if lAds()
      RETURN ( cAdsUNC() + "Emp" + cCodEmp + "\" )
   end if

RETURN ( fullCurDir() + "Emp" + cCodEmp + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatGrpOld( cCodGrp )

   if lAds()
      RETURN ( cAdsUNC() + "Emp" + cCodGrp + "\" )
   end if

RETURN ( fullCurDir() + "Emp" + cCodGrp + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatTmp()

   if empty( cPatTmp )

      cPatTmp     := GetEnv( 'TEMP' )

      if empty( cPatTmp )
         cPatTmp  := GetEnv( 'TMP' )
      endif

      if empty( cPatTmp ) .or. ! lIsDir( cPatTmp )
         cPatTmp  := GetWinDir()
      endif

      cPatTmp     += If( Right( cPatTmp, 1 ) == '\', '', '\' ) + 'Apolo'

      if !lIsDir( cPatTmp )
         MakeDir( cPatTmp )
      endif

      if Right( cPatTmp, 1 ) != '\'
         cPatTmp  += '\'
      end if

   end if

RETURN ( cPatTmp )

//----------------------------------------------------------------------------//

FUNCTION cPatIn( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "In\" )

//---------------------------------------------------------------------------//

FUNCTION cPatInFrq( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "InFrq\" )

//---------------------------------------------------------------------------//

FUNCTION cPatScript( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Script\" )

//---------------------------------------------------------------------------//

FUNCTION cPatScriptEmp( cPath, lShort )

   DEFAULT cPath    := ""
   DEFAULT lShort   := .f.

   if !empty( cPath )
      cPatScriptEmp := "Script" + cPath
   end if

RETURN ( if( !lShort, fullCurDir(), "" ) + cPatScriptEmp + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatOut( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Out\" )

//----------------------------------------------------------------------------//

FUNCTION cPatSafe( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Safe\" )

//----------------------------------------------------------------------------//

FUNCTION cPatBmp( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Bmp\" )

//----------------------------------------------------------------------------//

FUNCTION cPatPsion( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Psion\" )

//----------------------------------------------------------------------------//

FUNCTION cPatHtml( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Html\" )

//----------------------------------------------------------------------------//

FUNCTION cPatXml( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Xml\" )

//----------------------------------------------------------------------------//

FUNCTION PicIn()

   if empty( cDefPicIn )
      cDefPicIn   := cPirDiv( cDivEmp() )
   end if

RETURN ( cDefPicIn )

//---------------------------------------------------------------------------//

FUNCTION cPatReport( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Reports\" )

//----------------------------------------------------------------------------//

FUNCTION by( uVal )

   local uRet     := uVal

RETURN ( uRet )

//---------------------------------------------------------------------------//

FUNCTION nHndCaj( nHnd )

   if nHnd != nil
      nHndCaj  := nHnd
   end if

RETURN nHndCaj

//---------------------------------------------------------------------------//

FUNCTION SelSysDate( oMenuItem )

   DEFAULT oMenuItem := "01084"

   if dSysDate == nil
      dSysDate       := Date()
   end if

   /*
   Obtenemos el nivel de acceso
   */

   if nAnd( nLevelUsr( oMenuItem ), 1 ) != 0
      msgStop( "Acceso no permitido." )
   else
      dSysDate       := Calendario( dSysDate, "Fecha de trabajo" )
   end if

RETURN ( dSysDate )

//----------------------------------------------------------------------------//

FUNCTION ExcMnuNext( cName )

   local nPos

   if cName == nil
      nPos  := len( aMnuNext )
   else
      nPos  := aScan( aMnuNext, {|c| c[1] == cName } )
   end if

   if nPos != 0

      Eval( aMnuNext[ nPos, 2 ] )

      // Pasamos la accion a menu atras

      addMnuPrev( aMnuNext[ nPos, 1 ], aMnuNext[ nPos, 2 ] )

      // Eliminamos la accion

      aDel( aMnuNext, nPos )
      aSize( aMnuNext, len( aMnuNext ) - 1 )

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION MnuNext( oBtn, oWnd )

   local n
   local cText
   local oMenu
   local bAction

   DEFAULT oWnd   := oWnd()

   oMenu := MenuBegin( .T. )

   for n := 1 to len( aMnuNext )

      cText    := by( aMnuNext[ n, 1 ] )
      bAction  := bMnuNext( cText )

      MenuAddItem( cText,, .F.,, bAction,,,,,,, .F.,,, .F. )

   next

   MenuEnd()

   oMenu:Activate( 0, oBtn:nRight, oBtn )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION addMnuPrev( cName, uAction )

   if aScan( aMnuPrev, {|c| c[1] == cName } ) == 0
      if valtype( uAction ) == "C"
         aAdd( aMnuPrev, { cName, &( "{||" + uAction + "() }" ) } )
      else
         aAdd( aMnuPrev, { cName, uAction } )
      end if
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION ExcMnuPrev( cName )

   local nPos

   if cName == nil
      nPos  := len( aMnuPrev )
   else
      nPos  := aScan( aMnuPrev, {|c| c[1] == cName } )
   end if

   if nPos != 0

      Eval( aMnuPrev[ nPos, 2 ] )

      // Pasamos la accion a menu atras

      addMnuNext( aMnuPrev[ nPos, 1 ], aMnuPrev[ nPos, 2 ] )

      // Eliminamos la accion

      aDel( aMnuPrev, nPos )
      aSize( aMnuPrev, len( aMnuPrev ) - 1 )

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION MnuPrev( oBtn, oWnd )

   local n
   local cText
   local oMenu
   local bAction

   DEFAULT oWnd   := oWnd()

   oMenu := MenuBegin( .T. )

   for n := 1 to len( aMnuPrev )

      cText    := by( aMnuPrev[ n, 1 ] )
      bAction  := bMnuPrev( cText )

      MenuAddItem( cText,, .F.,, bAction,,,,,,, .F.,,, .F. )

   next

   MenuEnd()

   oMenu:Activate( oBtn:nBottom - 1, 0, oBtn )

RETURN nil

//---------------------------------------------------------------------------//

static FUNCTION bMnuPrev( uValue )
RETURN {|| ExcMnuPrev( uValue ) }

//---------------------------------------------------------------------------//

static FUNCTION bMnuNext( uValue )
RETURN {|| ExcMnuNext( uValue ) }

//---------------------------------------------------------------------------//

FUNCTION Visor( aMsg )

   local oDlg
   local oBrwCon
   //local hBmp     := LoadBitmap( GetResources(), "BSTOP" )

   if len( aMsg ) == 0
      RETURN .f.
   end if


   DEFINE DIALOG oDlg RESOURCE "VISOR"

   oBrwCon                        := IXBrowse():New( oDlg )

   oBrwCon:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCon:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCon:SetArray( aMsg, , , .f. )

   oBrwCon:nMarqueeStyle          := 5
   oBrwCon:lRecordSelector        := .f.
   oBrwCon:lHScroll               := .f.
   oBrwCon:lHeader                := .f.

   oBrwCon:CreateFromResource( 100 )

   with object ( oBrwCon:AddCol() )
      :cHeader          := Space(1)
      :bStrData         := {|| Space(1) }
      :bEditValue       := {|| aMsg[ oBrwCon:nArrayAt, 1 ] }
      :nWidth           := 20
      :SetCheck( { "Cnt16", "Nil16" } )
   end with

   with object ( oBrwCon:AddCol() )
      :cHeader          := Space(1)
      :bStrData         := {|| aMsg[ oBrwCon:nArrayAt, 2 ] }
      :nWidth           := 300
   end with

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION aItmVentas()

   local aItmVta := {}

   aAdd( aItmVta, { { "CSERALB",    "CSERIE",      "CSERIE",      "CSERTIK" }, { "C", "C", "C", "C" },   1, 0, "Serie del documento" } )
   aAdd( aItmVta, { { "NNUMALB",    "NNUMFAC",     "NNUMFAC",     "CNUMTIK" }, { "N", "N", "N", "C" },   9, 0, "Número del documento" } )
   aAdd( aItmVta, { { "CSUFALB",    "CSUFFAC",     "CSUFFAC",     "CSUFTIK" }, { "C", "C", "C", "C" },   2, 0, "Sufijo del documento" } )
   aAdd( aItmVta, { { "CTURALB",    "CTURFAC",     "CTURFAC",     "CTURTIK" }, { "C", "C", "C", "C" },   6, 0, "Sesión del documento" } )
   aAdd( aItmVta, { { "DFECALB",    "DFECFAC",     "DFECFAC",     "DFECTIK" }, { "D", "D", "D", "D" },   8, 0, "Fecha del documento" } )
   aAdd( aItmVta, { { "CCODCLI",    "CCODCLI",     "CCODCLI",     "CCLITIK" }, { "C", "C", "C", "C" },  12, 0, "Código del cliente" } )
   aAdd( aItmVta, { { "CNOMCLI",    "CNOMCLI",     "CNOMCLI",     "CNOMTIK" }, { "C", "C", "C", "C" },  80, 0, "Nombre del cliente" } )
   aAdd( aItmVta, { { "CDIRCLI",    "CDIRCLI",     "CDIRCLI",     "CDIRCLI" }, { "C", "C", "C", "C" }, 100, 0, "Domicilio del cliente" } )
   aAdd( aItmVta, { { "CPOBCLI",    "CPOBCLI",     "CPOBCLI",     "CPOBCLI" }, { "C", "C", "C", "C" },  35, 0, "Población del cliente" } )
   aAdd( aItmVta, { { "CPRVCLI",    "CPRVCLI",     "CPRVCLI",     "CPRVCLI" }, { "C", "C", "C", "C" },  20, 0, "Provincia del cliente" } )
   aAdd( aItmVta, { { "CPOSCLI",    "CPOSCLI",     "CPOSCLI",     "CPOSCLI" }, { "C", "C", "C", "C" },  15, 0, "Código postal del cliente" } )
   aAdd( aItmVta, { { "CDNICLI",    "CDNICLI",     "CDNICLI",     "CDNICLI" }, { "C", "C", "C", "C" },  15, 0, "DNI/CIF del cliente" } )
   aAdd( aItmVta, { { "CCODALM",    "CCODALM",     "CCODALM",     "CALMTIK" }, { "C", "C", "C", "C" },   3, 0, "Código del almacén" } )
   aAdd( aItmVta, { { "CCODCAJ",    "CCODCAJ",     "CCODCAJ",     "CNCJTIK" }, { "C", "C", "C", "C" },   3, 0, "Código de la caja" } )
   aAdd( aItmVta, { { "CCODPAGO",   "CCODPAGO",    "CCODPAGO",    "CFPGTIK" }, { "C", "C", "C", "C" },   2, 0, "Forma de pago del documento" } )
   aAdd( aItmVta, { { "CCODOBR",    "CCODOBR",     "CCODOBR",     "CCODOBR" }, { "C", "C", "C", "C" },  10, 0, "Obra del documento" } )
   aAdd( aItmVta, { { "CCODTAR",    "CCODTAR",     "CCODTAR",     "CCODTAR" }, { "C", "C", "C", "C" },   5, 0, "Código de la tarifa" } )
   aAdd( aItmVta, { { "CCODRUT",    "CCODRUT",     "CCODRUT",     "CCODRUT" }, { "C", "C", "C", "C" },   4, 0, "Código de la ruta" } )
   aAdd( aItmVta, { { "CCODAGE",    "CCODAGE",     "CCODAGE",     "CCODAGE" }, { "C", "C", "C", "C" },   3, 0, "Código del agente" } )
   aAdd( aItmVta, { { "NPCTCOMAGE", "NPCTCOMAGE",  "NPCTCOMAGE",  "NCOMAGE" }, { "N", "N", "N", "" },    6, 2, "Comisión agente" } )
   aAdd( aItmVta, { { "NTARIFA",    "NTARIFA",     "NTARIFA",     "NTARIFA" }, { "N", "N", "N", "N" },   1, 0, "Tarifa del documento" } )
   aAdd( aItmVta, { { "NDTOESP",    "NDTOESP",     "NDTOESP",     "" },        { "N", "N", "N", "" },    6, 2, "Descuento general" } )
   aAdd( aItmVta, { { "NDPP",       "NDPP",        "NDPP",        "" },        { "N", "N", "N", "" },    6, 2, "Descuento por pronto pago" } )
   aAdd( aItmVta, { { "NDTOUNO",    "NDTOUNO",     "NDTOUNO",     "" },        { "N", "N", "N", "" },    6, 2, "Descuento definido 1" } )
   aAdd( aItmVta, { { "NDTODOS",    "NDTODOS",     "NDTODOS",     "" },        { "N", "N", "N", "" },    4, 1, "Descuento definido 2" } )
   aAdd( aItmVta, { { "LRECARGO",   "LRECARGO",    "LRECARGO",    "" },        { "L", "L", "L", "" },    1, 0, "Lógico de recargo" } )
   aAdd( aItmVta, { { "CDIVALB",    "CDIVFAC",     "CDIVFAC",     "CDIVTIK" }, { "C", "C", "C", "C" },   3, 0, "Código divisa" } )
   aAdd( aItmVta, { { "NVDVALB",    "NVDVFAC",     "NVDVFAC",     "NVDVTIK" }, { "N", "N", "N", "N" },  10, 4, "Valor divisa" } )
   aAdd( aItmVta, { { "CRETPOR",    "CRETPOR",     "CRETPOR",     "CRETPOR" }, { "C", "C", "C", "C" }, 100, 0, "Retirado por" } )
   aAdd( aItmVta, { { "CRETMAT",    "CRETMAT",     "CRETMAT",     "CRETMAT" }, { "C", "C", "C", "C" },  20, 0, "Matricula" } )
   aAdd( aItmVta, { { "LIVAINC",    "LIVAINC",     "LIVAINC",     "" },        { "L", "L", "L", "" },    1, 0, "Lógico impuestos incluido" } )
   aAdd( aItmVta, { { "NREGIVA",    "NREGIVA",     "NREGIVA",     "" },        { "N", "N", "N", "" },   20, 0, "Régimen de " + cImp() } )
   aAdd( aItmVta, { { "CCODTRN",    "CCODTRN",     "CCODTRN",     "" },        { "C", "C", "C", "" },    9, 0, "Código del transportista" } )
   aAdd( aItmVta, { { "CCODUSR",    "CCODUSR",     "CCODUSR",     "CCCJTIK" }, { "C", "C", "C", "C" },   3, 0, "Código de usuario" } )
   aAdd( aItmVta, { { "DFECCRE",    "DFECCRE",     "DFECCRE",     "DFECCRE" }, { "D", "D", "D", "D" },   8, 0, "Fecha de creación/modificación" } )
   aAdd( aItmVta, { { "CTIMCRE",    "CTIMCRE",     "CTIMCRE",     "CTIMCRE" }, { "C", "C", "C", "C" },  20, 0, "Hora de creación/modificación" } )
   aAdd( aItmVta, { { "CCODGRP",    "CCODGRP",     "CCODGRP",     ""        }, { "C", "C", "C", "" },    4, 0, "Grupo de cliente" } )
   aAdd( aItmVta, { { "lImprimido", "lImprimido",  "lImprimido",  ""        }, { "L", "L", "L", "" },    1, 0, "Lógico de imprimido" } )
   aAdd( aItmVta, { { "dFecImp",    "dFecImp",     "dFecImp",     ""        }, { "D", "D", "D", "" },    8, 0, "Fecha última impresión" } )
   aAdd( aItmVta, { { "cHorImp",    "cHorImp",     "cHorImp",     ""        }, { "C", "C", "C", "" },    5, 0, "Hora última impresión" } )
   aAdd( aItmVta, { { "cCodDlg",    "cCodDlg",     "cCodDlg",     "cCodDlg" }, { "C", "C", "C", "C" },   2, 0, "Código delegación" } )

RETURN ( aItmVta )

//----------------------------------------------------------------------------//

FUNCTION aItmCompras()

   local aItmCom := {}

   aAdd( aItmCom, { { "CSERALB",    "CSERFAC"   }, { "C", "C" },  1, 0, "Serie del documento" } )
   aAdd( aItmCom, { { "NNUMALB",    "NNUMFAC"   }, { "N", "N" },  9, 0, "Número del documento" } )
   aAdd( aItmCom, { { "CSUFALB",    "CSUFFAC"   }, { "C", "C" },  2, 0, "Sufijo del documento" } )
   aAdd( aItmCom, { { "CTURALB",    "CTURFAC"   }, { "C", "C" },  6, 0, "Sesión del documento" } )
   aAdd( aItmCom, { { "DFECALB",    "DFECFAC"   }, { "D", "D" },  8, 0, "Fecha del documento" } )
   aAdd( aItmCom, { { "CCODALM",    "CCODALM"   }, { "C", "C" },  3, 0, "Código del almacén" } )
   aAdd( aItmCom, { { "CCODCAJ",    "CCODCAJ"   }, { "C", "C" },  3, 0, "Código de la caja" } )
   aAdd( aItmCom, { { "CCODPRV",    "CCODPRV"   }, { "C", "C" }, 12, 0, "Código del proveedor" } )
   aAdd( aItmCom, { { "CNOMPRV",    "CNOMPRV"   }, { "C", "C" }, 35, 0, "Nombre del proveedor" } )
   aAdd( aItmCom, { { "CDIRPRV",    "CDIRPRV"   }, { "C", "C" }, 35, 0, "Domicilio del proveedor" } )
   aAdd( aItmCom, { { "CPOBPRV",    "CPOBPRV"   }, { "C", "C" }, 25, 0, "Población del proveedor" } )
   aAdd( aItmCom, { { "CPROPRV",    "CPROVPROV" }, { "C", "C" }, 20, 0, "Provincia del proveedor" } )
   aAdd( aItmCom, { { "CPOSPRV",    "CPOSPRV"   }, { "C", "C" },  5, 0, "Código postal del provedor" } )
   aAdd( aItmCom, { { "CDNIPRV",    "CDNIPRV"   }, { "C", "C" }, 30, 0, "DNI/CIF del proveedor" } )
   aAdd( aItmCom, { { "DFECENT",    "DFECENT"   }, { "D", "D" },  8, 0, "Fecha de entrada" } )
   aAdd( aItmCom, { { "CCODPGO",    "CCODPAGO"  }, { "C", "C" },  2, 0, "Forma de pago" } )
   aAdd( aItmCom, { { "NBULTOS",    "NBULTOS"   }, { "N", "N" },  3, 0, "Número de bultos" } )
   aAdd( aItmCom, { { "NPORTES",    "NPORTES"   }, { "N", "N" },  6, 0, "Valor de los portes" } )
   aAdd( aItmCom, { { "NDTOESP",    "NDTOESP"   }, { "N", "N" },  6, 2, "Descuento general" } )
   aAdd( aItmCom, { { "NDPP",       "NDPP"      }, { "N", "N" },  6, 2, "Descuento por pronto pago" } )
   aAdd( aItmCom, { { "LRECARGO",   "LRECARGO"  }, { "L", "L" },  1, 0, "Lógico de recargo" } )
   aAdd( aItmCom, { { "CCONDENT",   "CCONDENT"  }, { "C", "C" }, 20, 0, "Condición de entrada" } )
   aAdd( aItmCom, { { "CEXPED",     "CEXPED"    }, { "C", "C" }, 20, 0, "Expedición" } )
   aAdd( aItmCom, { { "COBSERV",    "COBSERV"   }, { "M", "M" }, 10, 0, "Observaciones" } )
   aAdd( aItmCom, { { "CDIVALB",    "CDIVFAC"   }, { "C", "C" },  3, 0, "Código de la divisa" } )
   aAdd( aItmCom, { { "NVDVALB",    "NVDVFAC"   }, { "N", "N" }, 10, 4, "Valor de la divisa" } )
   aAdd( aItmCom, { { "NDTOUNO",    "NDTOUNO"   }, { "N", "N" },  5, 2, "Descuento definido 1" } )
   aAdd( aItmCom, { { "NDTODOS",    "NDTODOS"   }, { "N", "N" },  5, 2, "Descuento definido 2" } )
   aAdd( aItmCom, { { "CCODUSR",    "CCODUSR"   }, { "C", "C" },  3, 0, "Código de usuario" } )
   aAdd( aItmCom, { { "LIMPRIMIDO", "LIMPRIMIDO"}, { "L", "L" },  1, 0, "Lógico de imprimido" } )
   aAdd( aItmCom, { { "DFECIMP",    "DFECIMP"   }, { "D", "D" },  8, 0, "Fecha de última impresión" } )
   aAdd( aItmCom, { { "CHORIMP",    "CHORIMP"   }, { "C", "C" },  5, 0, "Hora última impresión" } )
   aAdd( aItmCom, { { "DFECCHG",    "DFECCHG"   }, { "D", "D" },  8, 0, "Fecha creación/modificación" } )
   aAdd( aItmCom, { { "CTIMCHG",    "CTIMCHG"   }, { "C", "C" },  5, 0, "Hora creación/modificación" } )
   aAdd( aItmCom, { { "CCODDLG",    "CCODDLG"   }, { "C", "C" },  2, 0, "Código de la delegación" } )

RETURN ( aItmCom )

//----------------------------------------------------------------------------//

FUNCTION aEmpresa( cCodigoEmpresa )

   setArrayEmpresa( EmpresasModel():scatter( cCodigoEmpresa ) )

   /*
   Configuraciones desde el usuario-----------------------------------------
   */

   if !( isReport() )

      if empty( oUser():cCaja() )
         oUser():cCaja( cCajUsr( uFieldEmpresa( "cDefCaj" ) ) )
      end if

      if empty( oUser():cAlmacen() )
         oUser():cAlmacen( cAlmUsr( uFieldEmpresa( "cCodAlm" ) ) )
      end if

      /*
      Cargamos el programa contable--------------------------------------
      */

      setAplicacionContable( uFieldEmpresa( "nExpContbl" ) )

   end if

   /*
   Verificamos la existencia de la delegacion-------------------------------
   */

   setArrayDelegacionEmpresa( DelegacionesModel():arrayDelegaciones( cCodigoEmpresa ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION SetEmp( uVal, nPos )

   if nPos >= 0 .and. nPos <= len( aEmpresa )
      aEmpresa[ nPos ]  := uVal
   end if

 RETURN ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION aRetDlgEmp() ; RETURN ( aDlgEmp )

//---------------------------------------------------------------------------//

FUNCTION setArrayDelegacionEmpresa( aDelegaciones )

   aDlgEmp  := aDelegaciones

RETURN ( aDlgEmp )

//---------------------------------------------------------------------------//

FUNCTION cCodigoEmpresaEnUso( cCodEmp )

   if cCodEmp != nil
      cCodigoEmpresaEnUso     := cCodEmp
   end if

RETURN ( cCodigoEmpresaEnUso )

//---------------------------------------------------------------------------//

FUNCTION cCodigoDelegacionEnUso( cCodDlg )

   if cCodDlg != nil
      cCodigoDelegacionEnUso  := cCodDlg
   end if

RETURN ( cCodigoDelegacionEnUso )

//---------------------------------------------------------------------------//

FUNCTION setPathEmpresa( cCodEmp )

   cPatEmp( cCodEmp )
   cPatCli( cCodEmp, nil, .t. )
   cPatArt( cCodEmp, nil, .t. )
   cPatPrv( cCodEmp, nil, .t. )
   cPatAlm( cCodEmp, nil, .t. )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION GetCodEmp( dbfEmp )

   local oBlock
   local oError
   local nRec
   local cCodEmp
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF dbfEmp == NIL
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lClose      := .t.
	END IF

   nRec           := ( dbfEmp )->( RecNo() )
   cCodEmp        := ""

   ( dbfEmp )->( dbGoTop() )
   while !( dbfEmp )->( eof() )
      if ( dbfEmp )->lActiva
         cCodEmp  := ( dbfEmp )->CodEmp
      end if
      ( dbfEmp )->( dbSkip() )
   end while

   /*
   Quitamos la empresa actual--------------------------------------------------
   */

   if empty( cCodEmp )
      ( dbfEmp )->( dbGoTop() )
      cCodEmp     := ( dbfEmp )->CodEmp
   end if

   ( dbfEmp )->( dbGoTo( nRec ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfEmp )
   end if

RETURN ( cCodEmp )

//---------------------------------------------------------------------------//
/*
Funciones para crear las bases de datos de los favoritos de la galeria de
informenes; lo metemos aqui para que pueda actualizar ficheros
*/

FUNCTION mkReport( cPath, lAppend, cPathOld, oMeter )

   DEFAULT lAppend      := .f.

   IF oMeter != NIL
		oMeter:cText		:= "Generando Bases"
      sysRefresh()
	END IF

   CreateDbfReport( cPath )
   
   rxReport( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "CfgCar" )
   end if

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "CfgFav" )
   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION rxReport( cPath, oMeter )

   local dbfFolder
   local dbfFavorito

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CfgCar.Dbf" ) .or.;
      !lExistTable( cPath + "CfgFav.Dbf" )

      CreateDbfReport( cPath )

   end if

   fEraseIndex( cPath + "CFGCAR.CDX" )

   dbUseArea( .t., cDriver(), cPath + "CFGCAR.DBF", cCheckArea( "CFGCAR", @dbfFolder ), .f. )
   if !( dbfFolder )->( neterr() )
      ( dbfFolder )->( __dbPack() )

      ( dbfFolder )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFolder )->( ordCreate( cPath + "CFGCAR.CDX", "CUSRNOM", "CCODUSR + CNOMBRE", {|| Field->CCODUSR + Field->CNOMBRE } ) )

      ( dbfFolder )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de configuraciones" )

   end if

   fEraseIndex( cPath + "CFGFAV.CDX" )

   dbUseArea( .t., cDriver(), cPath + "CFGFAV.DBF", cCheckArea( "CFGFAV", @dbfFavorito ), .f. )
   if !( dbfFavorito )->( neterr() )
      ( dbfFavorito )->( __dbPack() )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRFAV", "CCODUSR + CNOMFAV", {|| Field->CCODUSR + Field->CNOMFAV } ) )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRCAR", "CCODUSR + CCARPETA", {|| Field->CCODUSR + Field->CCARPETA } ) )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRRPT", "CCODUSR + CCARPETA + CNOMRPT", {|| Field->CCODUSR + Field->CCARPETA + Field->CNOMRPT } ) )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRCARFAV", "CCODUSR + CCARPETA + CNOMFAV", {|| Field->CCODUSR + Field->CCARPETA + Field->CNOMFAV } ) )

      ( dbfFavorito )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de configuraciones" )

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION CreateDbfReport( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CFGCAR.DBF" )
      dbCreate( cPath + "CFGCAR.DBF", aSqlStruct( aItmDbfReport() ), cDriver() )
   end if

   if !lExistTable( cPath + "CFGFAV.DBF" )
      dbCreate( cPath + "CFGFAV.DBF", aSqlStruct( aItmDbfFavoritos() ), cDriver() )
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION aItmDbfReport()

   local aBase := {}

   aAdd( aBase, { "cCodUsr",  "C",   3, 0, "Código de usuario" } )
   aAdd( aBase, { "cNombre",  "C", 100, 0, "Nombre de la carpeta" } )

RETURN ( aBase )

//---------------------------------------------------------------------------//

FUNCTION aItmDbfFavoritos()

   local aBase := {}

   aAdd( aBase, { "cCodUsr",  "C",   3, 0, "Código de usuario" } )
   aAdd( aBase, { "cCarpeta", "C", 100, 0, "Nombre de la carpeta" } )
   aAdd( aBase, { "cNomFav",  "C", 100, 0, "Descripción para favoritos" } )
   aAdd( aBase, { "cNomRpt",  "C", 100, 0, "Descripción original" } )

RETURN ( aBase )

//---------------------------------------------------------------------------//

FUNCTION lTactilMode()

RETURN ( "TACTIL" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION lTpvMode()

RETURN ( "TPV" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION GoogleMaps( cStreetTo, cCityTo, cCountryTo )

   local oDlg
   local oWebMap
   local oActiveX

   local oStreetFrom
   local cStreetFrom
   local oCityFrom
   local cCityFrom
   local oCountryFrom
   local cCountryFrom

   cStreetTo         := Padr( cStreetTo, 200 )
   cCityTo           := Padr( cCityTo, 200 )

   if empty( cCountryTo )
      cCountryTo     := Padr( "Spain", 100 )
   end if

   cStreetFrom       := Space( 200 )
   cCityFrom         := Space( 200 )
   cCountryFrom      := Space( 100 )

   oWebMap           := WebMap():new()

   DEFINE DIALOG oDlg RESOURCE "GoogleMap"

   REDEFINE ACTIVEX oActiveX  ID 100   OF oDlg  PROGID "Shell.Explorer"

   REDEFINE GET oStreetFrom   VAR cStreetFrom   ON HELP  load( oStreetFrom, oCityFrom, oCountryFrom ) BITMAP "gc_factory_16" ID 200 OF oDlg

   REDEFINE GET oCityFrom     VAR cCityFrom     ID 210   OF oDlg

   REDEFINE GET oCountryFrom  VAR cCountryFrom  ID 220   OF oDlg

   REDEFINE GET cStreetTo     ID 300   OF oDlg

   REDEFINE GET cCityTo       ID 310   OF oDlg

   REDEFINE GET cCountryTo    ID 320   OF oDlg

   REDEFINE BUTTON            ID 1     OF oDlg  ACTION ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   REDEFINE BUTTON            ID 3     OF oDlg  ACTION ShowInExplorer( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   ACTIVATE DIALOG oDlg CENTERED       ON INIT  ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

RETURN nil

//---------------------------------------------------------------------------//

static FUNCTION Load( oStreetFrom, oCityFrom, oCountryFrom )

   oStreetFrom:cText(   Padr( cDomEmp(), 200 ) )
   oCityFrom:cText(     Padr( Rtrim( cPobEmp() ) + Space( 1 ) + Rtrim( cPrvEmp() ), 200 ) )
   oCountryFrom:cText(  Padr( "Spain", 100 ) )

RETURN nil

//---------------------------------------------------------------------------//

static FUNCTION ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   oWebMap:aAddress  := {}

   if !empty( cStreetFrom )
      oWebMap:AddStopSep( cStreetFrom, cCityFrom, , , cCountryFrom )
   end if

   oWebMap:AddStopSep( cStreetTo, cCityTo, , , cCountryTo )

   oWebMap:GenLink()

   if !empty( oWebMap:cLink )
      oActiveX:Do( "Navigate", oWebMap:cLink )
      sysrefresh()
   end if

RETURN nil

//---------------------------------------------------------------------------//

static FUNCTION ShowInExplorer( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   oWebMap:aAddress  := {}

   if !empty( cStreetFrom )
      oWebMap:AddStopSep( cStreetFrom, cCityFrom, , , cCountryFrom )
   end if

   oWebMap:AddStopSep( cStreetTo, cCityTo, , , cCountryTo )

   oWebMap:ShowMap()

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cUnidadMedicion( cDbf, lParentesis )

   local cUnidad        := ""

   DEFAULT lParentesis  := .f.

   if !empty( ( cDbf )->nMedUno )
      cUnidad           += AllTrim( Trans( ( cDbf )->nMedUno, MasUnd() ) )
   end if

   if !empty( ( cDbf )->nMedDos )
      cUnidad           += " x "
      cUnidad           += AllTrim( Trans( ( cDbf )->nMedDos, MasUnd() ) )
   end if

   if !empty( ( cDbf )->nMedTre )
      cUnidad           += " x "
      cUnidad           += AllTrim( Trans( ( cDbf )->nMedTre, MasUnd() ) )
   end if

   if lParentesis .and. !empty( cUnidad )
      cUnidad           := "(" + cUnidad + ")"
   end if

RETURN ( cUnidad )

//---------------------------------------------------------------------------//

FUNCTION sErrorBlock( bBlock )

   nError++

   titulo( str( nError ) )
   logwrite( "suma control del errores 1:" + procname(1) + "2:" + procname(2) + str( nError ) )

RETURN ( ErrorBlock( {| oError | ApoloBreak( oError ) } ) )

FUNCTION rErrorBlock( oBlock )

   nError--

   titulo( str( nError ) )
   logwrite( "resta control del errores 1:" + procname(1) + "2:" + procname(2) + str( nError ) )

RETURN ( ErrorBlock( oBlock ) )

//---------------------------------------------------------------------------//

FUNCTION appSettings()

   SET DATE             FORMAT "dd/mm/yyyy"
   SET TIME             FORMAT TO "hh:mm:ss"
   SET DELETED          ON
   SET EXCLUSIVE        OFF
   SET EPOCH TO         2000
   SET OPTIMIZE         ON
   SET EXACT            ON
   SET AUTOPEN          ON
   SET AUTORDER         TO 1
   SET DECIMALS         TO 6

   setHandleCount( 240 )

   setResDebug( .t. )

   fwNumFormat( 'E', .t. )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION appLoadAds()

   if !file( cIniAplication() ) .and. file( fullCurDir() + "Gestion.Ini" )
      fRename( fullCurDir() + "Gestion.Ini", cIniAplication() )
   end if

   cAdsIp(     GetPvProfString(  "ADS",      "Ip",       hb_curdrive() + ":\", cIniAplication() ) )
   cAdsData(   GetPvProfString(  "ADS",      "Data",     curdir() + if( !empty( curdir() ), "\", "" ), cIniAplication() ) )
   cAdsPort(   GetPvProfString(  "ADS",      "Port",     "",   cIniAplication() ) )
   nAdsServer( GetPvProfInt(     "ADS",      "Server",   7,    cIniAplication() ) )
   cAdsFile(   GetPvProfString(  "ADS",      "File",     "Gestool.add",   cIniAplication() ) )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION AppSql( cEmpDbf, cEmpSql, cFile )

   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfDbf      := fullCurDir() + cEmpDbf + "\" + cFile + ".Dbf"
   local cdxDbf      := fullCurDir() + cEmpDbf + "\" + cFile + ".Cdx"
   local dbfSql      := cEmpSql + "\" + cFile + ".Dbf"
   local cdxSql      := cEmpSql + "\" + cFile + ".Cdx"

   if !File( dbfDbf )
      RETURN nil
   end if

   if !lExistTable( dbfSql )
      RETURN nil
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // DBFCDX ------------------------------------------------------------------

      USE ( dbfDbf ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) )
      if File( cdxDbf )
         SET ADSINDEX TO ( cdxDbf ) ADDITIVE
      end if

      // SQLRDD ------------------------------------------------------------------

      USE ( dbfSql ) NEW VIA "SQLRDD" ALIAS ( cCheckArea( "TMP", @dbfTmp ) )
      if lExistIndex( cdxSql )
         SET ADSINDEX TO ( cdxSql ) ADDITIVE
      end if

      // Pasamos los datos---------------------------------------------------------

      // APPEND FROM ( dbfDbf ) VIA ( cLocalDriver() )

      while !( dbfOld )->( eof() )
         dbPass( dbfOld, dbfTmp, .t. )
         ( dbfOld )->( dbSkip() )
         sysRefresh()
      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

RETURN NIL

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

FUNCTION cSqlTableName( cTableName )

   if cTableName[2] == ":"
      cTableName  := SubStr( cTableName, 3 )
   endif

   cTableName     := StrTran( AllTrim( Lower( cTableName ) ), ".dbf", "_dbf" )
   cTableName     := StrTran( cTableName, ".ntx", "" )
   cTableName     := StrTran( cTableName, ".cdx", "" )
   cTableName     := StrTran( cTableName, "\", "_" )

   if cTableName[1] == "/"
      cTableName  := SubStr( cTableName, 2 )
   endif

   cTableName     := StrTran( cTableName, "/", "_" )
   cTableName     := StrTran( cTableName, ".", "_" )
   cTableName     := AllTrim( cTableName )

   if len( cTableName ) > 30
      cTableName  := SubStr( cTableName, len( cTableName ) - 30 + 1 )
   endif

RETURN ( cTableName )

//--------------------------------------------------------------------------//

FUNCTION PrinterPreferences( oGet )

   // MsgInfo( hb_valtoexp( aGetPrinters() ) )

   PrinterSetup()

   if !empty( oGet )
      oGet:cText( PrnGetName() )
   end if

RETURN ( Nil )

//---------------------------------------------------------------------------//

FUNCTION DateTimeRich( oRTF )

   local aLbx := REGetDateTime()
   local nLbx := 1
   local oDlg, oLbx

   DEFINE DIALOG oDlg RESOURCE "DateRich"

   REDEFINE LISTBOX oLbx VAR nLbx ITEMS aLbx ID 101 OF oDlg

   REDEFINE BUTTON ID 201 ACTION ( oDlg:End( IDOK ) )

   REDEFINE BUTTON ID 202 ACTION ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oRTF:InsertRTF( aLbx[ nLbx ] )
   endif

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION FindRich( oRTF )

   local oDlg
   local oFind
   local cFind    := Space( 100 )
   local nDir     := 1
   local lCase    := .f.
   local lWord    := .t.

   DEFINE DIALOG oDlg RESOURCE "FindRich"

   REDEFINE GET oFind VAR cFind ID 101 OF oDlg UPDATE

   REDEFINE RADIO nDir ID 102, 103 OF oDlg

   REDEFINE CHECKBOX lCase ID 104 OF oDlg

   REDEFINE CHECKBOX lWord ID 105 OF oDlg

   REDEFINE BUTTON ID 201 ACTION ( oRTF:SetFocus(), oRTF:Find( AllTrim( cFind ), ( nDir == 1 ), lCase, lWord ) )

   REDEFINE BUTTON ID 202 ACTION ( oDlg:End() )

   oDlg:bStart := { || oDlg:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER NOWAIT

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION ReportBackLine( oInf, nLines )

   DEFAULT nLines := 1

   if !empty( oInf )
      oInf:BackLine( nLines )
   end if

RETURN ( "" )

//---------------------------------------------------------------------------//

FUNCTION SetBrwOpt( cName, cOption )

RETURN ( writePProString( "browse", cName, cValToChar( cOption ), cPatEmp() + "Empresa.Ini" ) )

//---------------------------------------------------------------------------//

FUNCTION GetBrwOpt( cName )

RETURN ( GetPvProfInt( "browse", cName, 2, cPatEmp() + "Empresa.Ini" ) )

//---------------------------------------------------------------------------//

FUNCTION setGridOrder( cName, cOption )

RETURN ( writePProString( "grid", cName, cValToChar( cOption ), cPatEmp() + "Empresa.Ini" ) )

//---------------------------------------------------------------------------//

FUNCTION getGridOrder( cName )

RETURN ( getPvProfString( "grid", cName, "", cPatEmp() + "Empresa.Ini" ) )

//---------------------------------------------------------------------------//

FUNCTION cPatPc( cPath )

   if !empty( cPath )
      cPathPC     := cPath
   end if

RETURN ( cPathPc )

//---------------------------------------------------------------------------//

FUNCTION cEmpUsr( cEmp )

   if cEmp != nil
      cEmpUsr  := cEmp
   end if

RETURN cEmpUsr

//---------------------------------------------------------------------------//

FUNCTION lGrupoEmpresa( cCodEmp, dbfEmpresa )

   local oBlock
   local oError
   local lClose   := .f.
   local lGrupo   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( dbfEmpresa )
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmpresa ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmpresa )
      lGrupo      := ( dbfEmpresa )->lGrupo
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfEmpresa )
   end if

RETURN ( lGrupo )

//---------------------------------------------------------------------------//

FUNCTION cCodigoGrupo( cCodEmp, dbfEmpresa )

   local nRec
   local oBlock
   local oError
   local lClose   := .f.
   local cGrupo   := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( dbfEmpresa )
      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Empresa.Dbf" ), ( cCheckArea( "Empresa", @dbfEmpresa ) ), .t. )
      if !lAIS() ; ( dbfEmpresa )->( ordListAdd( ( cPatDat() + "Empresa.Cdx" ) ) ) ; else ; ordSetFocus( 1 ) ; end

      lClose      := .t.
   else
      nRec        := ( dbfEmpresa )->( Recno() )
   end if

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmpresa )
      cGrupo      := ( dbfEmpresa )->cCodGrp
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfEmpresa )
   else
      ( dbfEmpresa )->( dbGoTo( nRec ) )
   end if

RETURN ( cGrupo )

//---------------------------------------------------------------------------//

FUNCTION cItemsToReport( aItems )

   local aItem
   local cString  := ""

   for each aItem in aItems
      if !empty( aItem[ 5 ] )
         cString  += aItem[ 1 ] + "=" + aItem[ 5 ] + ";"
      end if
   next

RETURN ( cString )

//---------------------------------------------------------------------------//

FUNCTION cObjectsToReport( oDbf )

   local oItem
   local cString  := ""

   for each oItem in oDbf:aTField

      if !empty( oItem:cComment ) .and. !( oItem:lCalculate )
         cString  += oItem:cName + "=" + oItem:cComment + ";"
      end if

   next

RETURN ( cString )

//---------------------------------------------------------------------------//

FUNCTION aEmpGrp( cCodGrp, dbfEmp, lEmpresa )

   local nRec
   local nOrd
   local lClose            := .f.

   DEFAULT lEmpresa        := .f.

   if !empty( cCodGrp )

      if empty( dbfEmp )

         USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
         SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

         ( dbfEmp )->( OrdSetFocus( "cCodGrp" ) )

         lClose            := .t.

      else

         nOrd              := ( dbfEmp )->( OrdSetFocus( "cCodGrp" ) )
         nRec              := ( dbfEmp )->( Recno() )

      end if

      aEmpresasGrupo       := {}

      if lEmpresa

         aAdd( aEmpresasGrupo, cCodGrp )

      else

         if ( dbfEmp )->( dbSeek( cCodGrp ) )

            while ( dbfEmp )->cCodGrp == cCodGrp .and. !( dbfEmp )->( Eof() )

               aAdd( aEmpresasGrupo, ( dbfEmp )->CodEmp )

               ( dbfEmp )->( dbSkip() )

            end while

         end if

      end if

      if lClose

         CLOSE( dbfEmp )

      else

         ( dbfEmp )->( OrdSetFocus( nOrd ) )
         ( dbfEmp )->( dbGoTo( nRec ) )

      end if

   end if

RETURN ( aEmpresasGrupo )

//----------------------------------------------------------------------------//

FUNCTION cPatStk( cPath, lPath, lShort, lGrp )

   DEFAULT lPath  := .t.
   DEFAULT lShort := .f.
   DEFAULT lGrp   := .f.

   if lAds()
      RETURN ( cAdsUNC() + if( lGrp, "Emp", "Emp" ) + cPath + if( lPath, "\", "" ) )
   end if

RETURN ( if( !lShort, fullCurDir(), "" ) + if( lGrp, "Emp", "Emp" ) + cPath + if( lPath, "\", "" ) )

//---------------------------------------------------------------------------//
/*
Devuelve la descripción de una line de factura
*/

FUNCTION Descrip( cFacCliL, cFacCliS )

   local cKey
   local cRETURN     := ""

   if !empty( ( cFacCliL )->cDetalle )
      cRETURN        := Rtrim( ( cFacCliL )->cDetalle )
   else
      cRETURN        := Rtrim( ( cFacCliL )->mLngDes )
   end if

   if !empty( cFacCliS )

      ckey           := ( cFacCliL )->( fieldget( 1 ) ) + Str( ( cFacCliL )->( fieldget( 2 ) ) ) + ( cFacCliL )->( fieldget( 3 ) ) + Str( ( cFacCliL )->nNumLin, 4 ) 

      cRETURN        += SerialDescrip( cKey, cFacCliS )

   end if

RETURN ( cRETURN )

//---------------------------------------------------------------------------//

FUNCTION DescripLeng( cFacCliL, cFacCliS, cArtLeng )

    local nOrd
    local cKey
    local cRETURN     := ""
    local nOrdAnt     := ( cArtLeng )->( OrdSetFocus( "CARTLEN" ) )

    if !( cArtLeng )->( dbSeek( ( cFacCliL )->cRef + getLenguajeSegundario() ) )

      if !empty( ( cFacCliL )->cDetalle )
        cRETURN       := Rtrim( ( cFacCliL )->cDetalle ) 
      else
        cRETURN       := Rtrim( ( cFacCliL )->mLngDes )
      end if

    else

      if !empty( ( cArtLeng )->cDesArt ) 
        cRETURN       := AllTrim( ( cArtLeng )->cDesArt )
      else
        cRETURN       := AllTrim( ( cArtLeng )->cDesTik )
      end if

    end if

    if !empty( cFacCliS )

        nOrd           := ( cFacCliL )->( OrdSetFocus( 1 ) )
        cKey           := ( cFacCliL )->( OrdKeyVal() ) + Str( ( cFacCliL )->nNumLin, 4 )

        cRETURN        += SerialDescrip( cKey, cFacCliS )

        ( cFacCliL )->( OrdSetFocus( nOrd ) )

    end if

  ( cArtLeng )->( OrdSetFocus( "nOrdAnt" ) )   

RETURN ( cRETURN )

//---------------------------------------------------------------------------//

FUNCTION SerialDescrip( cKey, cFacCliS )

   local nOrd
   local nInc
   local nLast
   local cLast
   local nPrior
   local cPrior
   local cRETURN           := ""

   nInc                    := 0
   nOrd                    := ( cFacCliS )->( OrdSetFocus( 1 ) )

   if ( cFacCliS )->( dbSeek( cKey ) )

      while ( ( cFacCliS )->( ordKeyVal() ) == cKey .and. !( cFacCliS )->( eof() ) )

         if empty( nPrior )
            nInc           := 0
            cPrior         := ( cFacCliS )->cNumSer
            nPrior         := SpecialVal( ( cFacCliS )->cNumSer )
         else
            nInc++
         end if

         if !empty( nPrior ) .and. ( nInc != 0 )

            if ( SpecialVal( ( cFacCliS )->cNumSer ) == nPrior + nInc )

               cLast       := ( cFacCliS )->cNumSer
               nLast       := SpecialVal( ( cFacCliS )->cNumSer )

            else

               cRETURN     += Alltrim( cPrior )    // cRETURN     += Alltrim( Str( nPrior ) )

               if !empty( nLast )
                  cRETURN  += "-"
                  cRETURN  += Alltrim( cLast )     // Alltrim( Str( nLast ) )
               end if

               cRETURN     += ","

               nInc        := 0
               nLast       := nil
               cPrior      := ( cFacCliS )->cNumSer
               nPrior      := SpecialVal( ( cFacCliS )->cNumSer )

            end if

         end if

         ( cFacCliS )->( dbSkip() )

      end while

      if !empty( nPrior )
         cRETURN           += Alltrim( cPrior )    // Alltrim( Str( nPrior ) )
      end if

      if !empty( nLast )
         cRETURN           += "-"
         cRETURN           += Alltrim( cLast )     // Alltrim( Str( nLast ) )
      end if

      cRETURN              := Space( 1 ) + "[" + cRETURN + "]"

   end if

   ( cFacCliS )->( OrdSetFocus( nOrd ) )

RETURN ( cRETURN )

//---------------------------------------------------------------------------//

FUNCTION AppDbf( cEmpOld, cEmpTmp, cFile, aStruct )

   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfNamOld   := cEmpOld + cFile + ".Dbf"
   local dbfNamTmp   := cEmpTmp + cFile + ".Dbf"
   local cdxNamOld   := cEmpOld + cFile + ".Cdx"
   local cdxNamTmp   := cEmpTmp + cFile + ".Cdx"

   IF !File( dbfNamOld )
      MsgStop( "No existe : " + dbfNamOld )
      RETURN NIL
	END IF

   IF !File( dbfNamTmp )
      MsgStop( "No existe : " + dbfNamTmp )
      RETURN NIL
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( dbfNamOld ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) ) EXCLUSIVE
   if File( cdxNamOld )
      SET ADSINDEX TO ( cdxNamOld ) ADDITIVE
   end if

   USE ( dbfNamTmp ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TMP", @dbfTmp ) ) EXCLUSIVE
   if File( cdxNamTmp )
      SET ADSINDEX TO ( cdxNamTmp ) ADDITIVE
   end if

   if !empty( aStruct )

      while !( dbfOld )->( eof() )
         dbAppendDefault( dbfOld, dbfTmp, aStruct )
         ( dbfOld )->( dbSkip() )
      end while

   else

      while !( dbfOld )->( eof() )
         dbPass( dbfOld, dbfTmp, .t. )
         ( dbfOld )->( dbSkip() )
      end while

   end if

   RECOVER USING oError

      msgStop( "Error en el trasbase de registros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION cPatGrp( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !empty( cPath )
      cPatGrp        := "Emp" + cPath
   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatGrp + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatGrp + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatGrp )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatGrp + "\" )
   end if

RETURN ( if( lFull, fullCurDir(), "" ) + cPatGrp + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatCli( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !empty( cPath )
      if lEmpresa
         cPatCli     := "Emp" + cPath
      else
         cPatCli     := "Emp" + cPath
      end if
   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatCli + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatCli + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatCli )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatCli + "\" )
   end if

RETURN ( if( lFull, fullCurDir(), "" ) + cPatCli + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatArt( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !empty( cPath )

      if lEmpresa
         cPatArt     := "Emp" + cPath
      else
         cPatArt     := "Emp" + cPath
      end if

   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatArt + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatArt + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatArt )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatArt + "\" )
   end if

RETURN ( if( lFull, fullCurDir(), "" ) + cPatArt + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatPrv( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !empty( cPath )

      if lEmpresa
         cPatPrv     := "Emp" + cPath
      else
         cPatPrv     := "Emp" + cPath
      end if

   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatPrv + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatPrv + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatPrv )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatPrv + "\" )
   end if

   RETURN ( if( !lFull, fullCurDir(), "" ) + cPatPrv + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatAlm( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !empty( cPath )

      if lEmpresa
         cPatAlm     := "Emp" + cPath
      else
         cPatAlm     := "Emp" + cPath
      end if

   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatAlm + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatAlm + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatAlm )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatAlm + "\" )
   end if

RETURN ( if( lFull, fullCurDir(), "" ) + cPatAlm + "\" )

//---------------------------------------------------------------------------//

FUNCTION GetSysDate()

RETURN ( if( dSysDate != nil, dSysDate, Date() ) )

//---------------------------------------------------------------------------//

FUNCTION aEmp() ; RETURN ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION getArrayEmpresa() ; RETURN ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION setArrayEmpresa( aEmp )

   aEmpresa    := aEmp

RETURN ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION cPathEmpresa()

RETURN ( cPatEmp )

//---------------------------------------------------------------------------//

FUNCTION cPatEmp( cPath, lFull )

   DEFAULT cPath  := ""
   DEFAULT lFull  := .f.

   if !empty( cPath )
      cPatEmp     := "Emp" + cPath
   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatEmp + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatEmp + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatEmp )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatEmp + "\" )
   end if

RETURN ( if( lFull, fullCurDir(), "" ) + cPatEmp + "\" )

//---------------------------------------------------------------------------//

FUNCTION appParamsMain( paramsMain )

   if !empty( paramsMain )
      appParamsMain   := upper( paramsMain )
   end if 

RETURN ( appParamsMain )

//---------------------------------------------------------------------------//

FUNCTION appParamsSecond( paramsSecond )

   if !empty( paramsSecond )
      appParamsSecond   := upper( paramsSecond )
   end if 

RETURN ( appParamsSecond )

//---------------------------------------------------------------------------//

FUNCTION appParamsThird( paramsThird )

   if !empty( paramsThird )
      appParamsThird   := upper( paramsThird )
   end if 

RETURN ( appParamsThird )

//---------------------------------------------------------------------------//

FUNCTION appConnectADS()

   local TDataCenter     

   lAIS( .t. )

   rddRegister( 'ADS', 1 )
   rddSetDefault( 'ADSCDX' )

   adsSetServerType( nAdsServer() )    // TODOS
   adsSetFileType( 2 )                 // ADS_CDX
   adsRightsCheck( .f. )

   adsLocking( .t. )                   // NON-compatible locking mode
   adsTestRecLocks( .t. )

   adsSetDeleted( .t. )
   // adsCacheOpenTables( 250 )

   // Conexion con el motor de base de datos-----------------------------------

   TDataCenter          := TDataCenter()

   TDataCenter:ConnectDataDictionary()

RETURN ( TDataCenter:lAdsConnection )

//---------------------------------------------------------------------------//

FUNCTION appConnectCDX()

    lCdx( .t. )
    rddSetDefault( 'DBFCDX' )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION runReportGalery( cFastReport )

   local nLevel         := nLevelUsr( "01119" )

   DEFAULT cFastReport  := ""

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      RETURN nil
   end if

   if DirChange( fullCurDir() ) != 0
      MsgStop( "No puedo cambiar al directorio " + fullCurDir() )
      RETURN nil
   end if

   if file( fullCurDir() + "RptApolo.Exe" )

      nHndReport        := winExec( fullCurDir() + "RptApolo.Exe " + cCodEmp() + " " + cCurUsr() + " " + cFastReport, 1 )


      if !( nHndReport > 21 .or. nHndReport < 0 )
         msgStop( "Error en la ejecución de la galeria de informes" )
      end if

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION runFastGallery( cFastReport )

   local nLevel         := nLevelUsr( "01119" )

   DEFAULT cFastReport  := ""

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      RETURN nil
   end if

   if dirchange( fullCurDir() ) != 0
      MsgStop( "No puedo cambiar al directorio " + fullCurDir() )
      RETURN nil
   end if

   if file( fullCurDir() + "GesTool.Exe" )
      nHndReport        := winExec( fullCurDir() + "GesTool.Exe " + cCurUsr() + " " + cCodEmp() + " " + cFastReport, 1 )

      if !( nHndReport > 21 .or. nHndReport < 0 )
         msgStop( "Error en la ejecución de la galeria de informes" )
      end if
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cIniEmpresa()

RETURN ( cPatEmp() + "Empresa.Ini" )

//---------------------------------------------------------------------------//

FUNCTION cIniAplication()

RETURN ( fullCurDir() + "GstApolo.Ini" )

//---------------------------------------------------------------------------//

FUNCTION IsMuebles()

RETURN ( "MUEBLES" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION ChmHelp( cTema )

RETURN WinExec( ( "HH " + cPatHelp() + "HELP.CHM::/" + AllTrim( cTema ) + ".HTM" ) )

//----------------------------------------------------------------------------//

FUNCTION cPatHelp()

RETURN ( fullCurDir() + "Help\" )

//----------------------------------------------------------------------------//

FUNCTION cPatReporting()

RETURN ( fullCurDir() + "Reporting\" )

//----------------------------------------------------------------------------//

FUNCTION cPatUserReporting()

RETURN ( fullCurDir() + "UserReporting\" )

//----------------------------------------------------------------------------//

FUNCTION cPatConfig()

RETURN ( fullCurDir() + "Config\" )

//----------------------------------------------------------------------------//

FUNCTION HtmlHelp()

RETURN ( "" )

//---------------------------------------------------------------------------//

FUNCTION lUsrMaster()

RETURN ( cCurUsr() == "000" )

//---------------------------------------------------------------------------//

FUNCTION IsPda()

RETURN ( "PDA" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION cPatSnd( lShort )

   DEFAULT lShort := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Snd\" )

//----------------------------------------------------------------------------//

FUNCTION cEmpTmp( lPath, lShort )

   DEFAULT lPath  := .t.
   DEFAULT lShort := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "EmpTmp" + if( lPath, "\", "" ) )

//----------------------------------------------------------------------------//

FUNCTION cPatUsr()

RETURN ( fullCurDir() + "Usr\" )

//----------------------------------------------------------------------------//

FUNCTION cImp()

   local cImp  := uFieldEmpresa( "cNomImp" )

   if !IsChar( cImp )
      cImp     := ""
   end if

RETURN ( cImp )

//----------------------------------------------------------------------------//

FUNCTION addMnuNext( cName, uAction )

   if aScan( aMnuNext, {|c| c[1] == cName } ) == 0
      if valtype( uAction ) == "C"
         aAdd( aMnuNext, { cName, &( "{||" + uAction + "() }" ) } )
      else
         aAdd( aMnuNext, { cName, uAction } )
      end if
   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION cValToChar( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C" .or. cType == "M"
           RETURN uVal

      case cType == "D"
           RETURN DToC( uVal )

      case cType == "L"
           RETURN If( uVal, ".T.", ".F." )

      case cType == "N"
           RETURN AllTrim( Str( uVal ) )

      case cType == "B"
           RETURN "{|| ... }"

      case cType == "A"
           RETURN "{ ... }"

      case cType == "O"
           RETURN "Object"

      otherwise
           RETURN ""
   endcase

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cCharToVal( xVal, cType )

   local cTemp      := ""

   DEFAULT cType    := ValType( xVal )

   do case
      case cType == "C" .or. cType == "M"

         if !empty( xVal )
            cTemp   := Padr( Rtrim( xVal ), 100 )
         end if
         
         /*
         if ( '"' $ xVal ) .or. ( "'" $ xVal )
            cTemp := Rtrim( cValToChar( xVal ) )
         else
            cTemp := '"' + Rtrim( cValToChar( xVal ) ) + '"'
         end if
        */

      case cType == "N"
         cTemp    := Val( cValToChar( xVal ) )

      case cType == "D"

         cTemp    := Ctod( Rtrim( cValToChar( xVal ) ) )

      case cType == "L"
         if "S" $ Rtrim( Upper( xVal ) )
            cTemp := .t.
         else
            cTemp := .f.
         end if

   end case

RETURN ( cTemp )

//---------------------------------------------------------------------------//

FUNCTION cValToText( uVal, lBarraFecha )

   local cType             := ValType( uVal )

   DEFAULT lBarraFecha     := .f.

   do case
      case cType == "C" .or. cType == "M"
           RETURN uVal

      case cType == "D"
           if lBarraFecha
               RETURN DToC( uVal )
           else
               RETURN StrTran( DToC( uVal ), "/", "" )
           end if

      case cType == "L"
           RETURN If( uVal, "S", "N" )

      case cType == "N"
           RETURN AllTrim( Str( uVal ) )

      case cType == "B"
           RETURN "{|| ... }"

      case cType == "A"
           RETURN "{ ... }"

      case cType == "O"
           RETURN "Object"

      otherwise
           RETURN ""
   endcase

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION dToIso( dDate )

   local cDate := ""

   if Valtype( dDate ) != "D"
      dDate    := Date()
   endif

   cDate       := Alltrim( Str( Year( dDate ) ) + "-" + StrZero( Month( dDate ), 2 ) + "-" + StrZero( Day( dDate ), 2 ) )

RETURN ( cDate )

//---------------------------------------------------------------------------//

FUNCTION LogWrite( cText, cFileName )

   local nHand

   DEFAULT cFileName := "Trace.Log"

   if !empty( cText )

      if !File( cFileName )
         nHand       := fCreate( cFileName )
      else
        nHand        := fOpen( cFileName, 1 )
      endif

      fSeek( nHand, 0 , 2 )

      fWrite( nHand, Time() + '-' + Trans( Seconds(), "999999.9999" ) + Space( 1 ) )
      fWrite( nHand, cValToChar( cText ) + CRLF )
      
      fClose( nHand )

   end if

RETURN NIL

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ApoloBtnBmp FROM TBtnBmp

   METHOD aGrad INLINE Eval( If( ::bClrGrad == nil, ::oWnd:bClrGrad, ::bClrGrad ), ( ::lMOver .or. ::lBtnDown ) )

ENDCLASS

//----------------------------------------------------------------------------//

FUNCTION PicOut()

   if empty( cDefPicOut )
      cDefPicOut  := cPorDiv( cDivEmp() )
   end if

RETURN ( cDefPicOut )

//---------------------------------------------------------------------------//

FUNCTION cUsrTik( cCodUsr )

   if !empty( cCodUsr )
      cUsrTik     := cCodUsr
   end if

RETURN cUsrTik

//---------------------------------------------------------------------------//

FUNCTION cDelUsrTik( cCodUsr )

   cUsrTik     := Space(3)

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION cPatLog( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Log\" )

//----------------------------------------------------------------------------//

FUNCTION cCodigoEmpresa( xValue )

   if !empty( xValue )
      cCodEmp     := xValue
   end if

RETURN ( cCodEmp )

//--------------------------------------------------------------------------//
Static FUNCTION lControlAcceso()

   if lCheckPerpetuoMode()

      lDemoMode( .f. )

      RETURN .t.

   end if 

RETURN .f.

//---------------------------------------------------------------------------//

FUNCTION lCheckPerpetuoMode( nSerialUSR )

   local n 
   local cFileIni       
   local oSerialHD
   local nSerialHD      := Abs( nSerialHD() )
   local aSerialCRC     := {}
   local nSerialCRC     := 0

   if empty( nSerialHD )
      RETURN .f.
   end if

   cFileIni             := FullCurDir() + "2Ktorce.Num"  

   // Leemos las claves--------------------------------------------------------

   for n := 1 to 50

      nSerialCRC        := Val( GetPvProfString( "Main", "Access code " + Str( n, 2 ), "0", cFileIni ) )
   
      if !empty( nSerialCRC )
   
         aAdd( aSerialCRC, nSerialCRC )
            
         if nSerialCRC == nXor( nSerialHD, SERIALNUMBER )
               
            RETURN .t.
   
         end if
   
      end if
   
   next

   // Parametro para registrar la aplicacion-----------------------------------

   if !empty( nSerialUSR )

      if nSerialUSR == nXor( nSerialHD, SERIALNUMBER )

         aAdd( aSerialCRC, nSerialUSR )

         for n := 1 to len( aSerialCRC )
            WritePProString( "Main", "Access code " + Str( n, 2 ), cValToChar( aSerialCRC[ n ] ), cFileIni )
         next

         RETURN .t.

      end if

   end if

RETURN .f.

//---------------------------------------------------------------------------//

PROCEDURE xmlIterator( cFileName, cNode, cAttrib, cValue, cData )

   LOCAL hFile, cXml
   LOCAL oDoc, oNode, oIter, lFind
   LOCAL cText    := ""

   SET EXACT OFF

   CLS

   cText          += "X H A R B O U R - XML ITERATOR test "

   IF cFileName == NIL
      cFileName := "xmltest.xml"
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cNode ) == "C" .and. Len( cNode ) == 0
      cNode := NIL
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cAttrib ) == "C" .and. Len( cAttrib ) == 0
      cAttrib := NIL
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cValue ) == "C" .and. Len( cValue ) == 0
      cValue := NIL
   ENDIF

   cText          +=  "Processing file " + cFileName + "..." + CRLF

   oDoc := TXmlDocument():New( cFileName )

   IF oDoc:nStatus != HBXML_STATUS_OK
      cText       +=  "Error While Processing File: "+cFileName
      cText       +=  "On Line: " + AllTrim( Str( oDoc:nLine ) )
      cText       +=  "Error: " + oDoc:ErrorMsg
      cText       +=  "Program Terminating, press any key"
      RETURN
   ENDIF

   lFind := ( cNode != NIL .or. cAttrib != NIL .or. cValue != NIL .or. cData != NIL )

   cText          += "Navigating all nodes with a base iterator" + CRLF

   oNode := oDoc:CurNode

if ! lFind 

   DO WHILE oNode != NIL
      cXml := oNode:Path()
      IF cXml == NIL
         cXml :=  "(Node without path)"
      ENDIF

      cText       += Alltrim( Str( oNode:nType ) ) + ", " + cValToChar( oNode:cName ) + ", " + ValToPrg( oNode:aAttributes ) + ", " + cValToChar( oNode:cData ) + ": " + cValToChar( cXml ) + CRLF

      oNode       := oDoc:Next()
   ENDDO

else
      cText       += "Iterator - Navigating all nodes" +  cValToChar( cNode ) +  "," + cValToChar( cAttrib ) + "=" + cValToChar( cValue ) + " with data having " + cValToChar( cData ) + CRLF

      oIter := TXmlIterator():New( oDoc:oRoot )
      oIter:lRegex := .t.

      IF cNode != NIL
         cNode := HB_RegexComp( cNode )
      ENDIF

      IF cAttrib != NIL
         cAttrib := HB_RegexComp( cAttrib )
      ENDIF

      IF cValue != NIL
         cValue := HB_RegexComp( cValue )
      ENDIF

      IF cData != NIL
         cData := HB_RegexComp( cData )
      ENDIF

      oNode := oIter:Find( cNode, cAttrib, cValue, cData )

      WHILE oNode != NIL
         cText    += "Found node " + oNode:Path() + ValToPrg( oNode:ToArray() ) + CRLF
         oNode    := oIter:FindNext()
      ENDDO

endif

   cText          += "Terminated. Press any key to continue"

RETURN

//---------------------------------------------------------------------------//

FUNCTION lBancas()

RETURN ( "BANCAS" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION GetOleObject( cApp )

   local oObj

   TRY
      oObj  := GetActiveObject( cApp )
   CATCH
      TRY
         oObj  := CreateObject( cApp )
      CATCH
      END
   END

RETURN oObj

//----------------------------------------------------------------------------//

FUNCTION WinWordObj()

   local lInstalled
   local oWord

   if !( lInstalled == .f. )
      lInstalled  := ( ( oWord := GetOleObject( "Word.Application" ) ) != nil )
   endif

RETURN oWord

//----------------------------------------------------------------------------//

FUNCTION ExcelObj()

   local lInstalled
   local oExcel

   if !( lInstalled == .f. )
      lInstalled  := ( ( oExcel := GetOleObject( "Excel.Application" ) ) != nil )
   endif

RETURN oExcel

//----------------------------------------------------------------------------//

FUNCTION SunCalcObj()

   local lInstalled
   local oCalc

   if !( lInstalled == .f. )
      lInstalled  := ( ( oCalc := GetOleObject( "com.sun.star.ServiceManager" ) ) != nil )
   endif

RETURN oCalc

//----------------------------------------------------------------------------//

FUNCTION GetExcelRange( cBook, cSheet, acRange )

   local oExcel, oBook, oSheet, oRange

   if ( oExcel := ExcelObj() ) != nil
      if ( oBook := GetExcelBook( cBook ) ) != nil
         TRY
            oSheet   := oBook:WorkSheets( cSheet )
            if ValType( acRange ) == 'A'
               oRange   := oSheet:Range( oSheet:Cells( acRange[ 1 ], acRange[ 2 ] ), ;
                                         oSheet:Cells( acRange[ 3 ], acRange[ 4 ] ) )
            else
               oRange   := oSheet:Range( acRange )
            endif
         CATCH
         END
      endif
   endif

RETURN oRange

//----------------------------------------------------------------------------//

FUNCTION GetExcelBook( cBook )

   local oExcel, oBook
   local c, n, nBooks

   cBook := Upper( cFilePath( cBook ) + cFileNoExt( cBook ) )
   if ( oExcel := ExcelObj() ) != nil
      nBooks   := oExcel:WorkBooks:Count()
      for n := 1 to nBooks
         c  := oExcel:WorkBooks( n ):FullName
         if cBook == Upper( cFilePath( c ) + cFileNoExt( c ) )
            RETURN oExcel:WorkBooks( n )
         endif
      next n
      TRY
         oBook := oExcel:WorkBooks:Open( cBook )
      CATCH
      END
   endif

RETURN oBook

//----------------------------------------------------------------------------//

FUNCTION SpecialVal( cNumber )

   local cChar
   local cResult  := ""

   cNumber        := Alltrim( cNumber )

   for each cChar in cNumber
      if Str( Val( cChar ) ) == cChar
         cResult  += cChar
      end if
   next

RETURN ( Val( cResult ) )

//----------------------------------------------------------------------------//

FUNCTION ApoloMsgNoYes( cText, cTitle, lTactil ) 

   local oDlg
   local oBtnOk
   local oBtnCancel

   DEFAULT cText              := "¿Desea eliminar el registro en curso?"
   DEFAULT cTitle             := "Confirme"
   DEFAULT lTactil            := .f.

   if lTactil
      DEFINE DIALOG oDlg RESOURCE "DeleteRecnoTct" TITLE ( cTitle )
   else
      DEFINE DIALOG oDlg RESOURCE "DeleteRecno" TITLE ( cTitle )
   end if

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   REDEFINE BUTTON oBtnCancel ID IDCANCEL    OF oDlg ACTION ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

FUNCTION ApoloMsgStop( cText, cTitle ) 

   local oDlg
   local oBtnOk

   DEFAULT cText              := "¿Desea eliminar el registro en curso?"
   DEFAULT cTitle             := "¡Atención!"

   DEFINE DIALOG oDlg RESOURCE "MsgStopTCT" TITLE ( cTitle )

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

FUNCTION ApoloWaitSeconds( nSecs )

   local n

   for n := 1 to nSecs
      WaitSeconds( 1 )
      SysRefresh()
   next

RETURN nil

//----------------------------------------------------------------------------//

FUNCTION ApoloDescend( uParam )

RETURN ( Descend( uParam ) )

//----------------------------------------------------------------------------//

FUNCTION CreateFastReport()

   if empty( oFastReport )

      oFastReport    := frReportManager():new()

      oFastReport:LoadLangRes( "Spanish.Xml" )
      oFastReport:SetIcon( 1 )

   end if

RETURN ( oFastReport )

//----------------------------------------------------------------------------//

FUNCTION DestroyFastReport()

   if empty( oFastReport )
      oFastReport:DestroyFR()
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION cDirectorioImagenes()

  local cDirectorio := AllTrim( uFieldEmpresa( "CDIRIMG" ) )

  if Right( cDirectorio, 1 ) != "\"
    cDirectorio     := cDirectorio + "\"
  end if

RETURN ( cDirectorio )

//----------------------------------------------------------------------------//
/*
Pasa del formato RGB al format RGB Hexadecimal  #000000-------------------------
*/

FUNCTION RgbToRgbHex( nColorRgb )

   local cRgbHex  := ""

   cRgbHex        += "#"
   cRgbHex        += NumToHex( nRgbRed( nColorRgb ), 2 )
   cRgbHex        += NumToHex( nRgbGreen( nColorRgb ), 2 )
   cRgbHex        += NumToHex( nRgbBlue( nColorRgb ), 2 )

RETURN cRgbHex

//----------------------------------------------------------------------------//

FUNCTION InfoStack()

   local i
   local cStack

   i              := 2
   cStack         := ""

   while !empty( ProcName( i ) )
      cStack      += "Llamado desde " + Trim( ProcName( i ) ) + "(" + LTrim( Str( ProcLine( i ) ) ) + ")" + CRLF
      i++
   enddo

   MsgInfo( cStack )

RETURN nil

//----------------------------------------------------------------------------//

FUNCTION lValidMail( cMail )

RETURN ( HB_RegExMatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", cMail, .f. ) )

//----------------------------------------------------------------------------//

FUNCTION hashRecord( dbf )

  local n
  local hHash   := {=>}

  for n := 1 to ( dbf )->( fcount() )
    hSet( hHash, ( dbf )->( fieldname( n ) ), ( dbf )->( fieldget( n ) ) )
  next 

RETURN ( hHash )

//----------------------------------------------------------------------------//

FUNCTION appendHashRecord( hHash, dbf, aExclude )

  ( dbf )->( dbappend() )
  if !( dbf )->( neterr() )  
    writeHashRecord( hHash, dbf, aExclude )
  end if

RETURN ( hHash )

//----------------------------------------------------------------------------//

FUNCTION writeHashRecord( hHash, dbf, aExclude )

  local n

  DEFAULT aExclude  := {}

  for n := 1 to ( dbf )->( fcount() )
    if hHasKey( hHash, ( dbf )->( fieldname( n ) ) ) .and. aScan( aExclude, ( dbf )->( fieldname( n ) ) ) == 0
      ( dbf )->( fieldput( n, hGet( hHash, ( dbf )->( fieldname( n ) ) ) ) )
    end if
  next 

RETURN ( hHash )

//----------------------------------------------------------------------------//

FUNCTION readHashDictionary( hashTable, dbf )

  local hash      := {=>}

  hEval( hashTable, {|key,value| hSet( hash, key, ( dbf )->( fieldget( ( dbf )->( fieldPos( value ) ) ) ) ) } )

RETURN ( hash )

//----------------------------------------------------------------------------//

FUNCTION writeHashDictionary( hashValue, hashTable, dbf )

   local h
   local value

   for each h in hashValue
      value     := getValueHashDictionary( h:__enumKey(), hashTable )
      if value != nil
         ( dbf )->( fieldput( ( dbf )->( fieldname( value ) ), h:__enumValue() ) )
      end if
   next

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION getValueHashDictionary( key, hashTable )

   local n
   local value

   n  := hScan( hashTable, {|k,v,i| k == key } ) 
   if n != 0
      value   := haaGetValueAt( hashTable, n )
   end if 

RETURN ( value )

//----------------------------------------------------------------------------//

FUNCTION hashDictionary( aItems )

   local aItem
   local hash        := {=>}

   for each aItem in aItems
      if !empty( aItem[6] )
         hSet( hash, aItem[6], aItem[1] )      
      end if
   next

RETURN ( hash )

//---------------------------------------------------------------------------//

FUNCTION hashDefaultValue( aItems )

  local aItem
  local hash        := {=>}

  for each aItem in aItems
    if !empty( aItem[6] ) .and. isBlock( aItem[9] )
      hSet( hash, aItem[6], aItem[9] )
    end if
  next

RETURN ( hash )

//---------------------------------------------------------------------------//

FUNCTION hashIndex( aItems )

   local aItem
   local hash        := {=>}

   for each aItem in aItems
      if !empty( aItem[1] )
         hSet( hash, aItem[1], aItem[2] )      
      end if
   next

RETURN ( hash )

//---------------------------------------------------------------------------//


FUNCTION getFieldNameFromDictionary( cName, hashDictionary )

  local cFieldName  := ""

  if empty( hashDictionary )
    RETURN ( cFieldName )
  end if 

  if hhaskey( hashDictionary, cName )
    cFieldName      := hGet( hashDictionary, cName )
  end if 

RETURN ( cFieldName )

//---------------------------------------------------------------------------//

FUNCTION cAlmUsr( cAlm )

   if cAlm != nil .and. oMsgAlmacen != nil
      oMsgAlmacen:SetText( "Almacén : " + RTrim( cAlm ) )
   end if

RETURN ( cAlm )

//---------------------------------------------------------------------------//

FUNCTION HtmlConvertChars( cString, cQuote_style, aTranslations )

   DEFAULT cQuote_style := "ENT_COMPAT"

   do case
      case cQuote_style == "ENT_COMPAT"
         aAdd( aTranslations, { '"', '&quot;'  } )
      case cQuote_style == "ENT_QUOTES"
         aAdd( aTranslations, { '"', '&quot;'  } )
         aAdd( aTranslations, { "'", '&#039;'  } )
      case cQuote_style == "ENT_NOQUOTES"
   end case

RETURN TranslateStrings( cString, aTranslations )

FUNCTION TranslateStrings( cString, aTranslate )

   local aTran

   for each aTran in aTranslate
      if aTran[ 2 ] $ cString
         cString  := StrTran( cString, aTran[ 2 ], aTran[ 1 ] )
      endif
   next

RETURN cString

FUNCTION HtmlEntities( cString, cQuote_style )

   local i
   local aTranslations := {}

   for i := 160 TO 255
      aAdd( aTranslations, { Chr( i ), "&#" + Str( i, 3 ) + ";" } )
   next

RETURN HtmlConvertChars( cString, cQuote_style, aTranslations )

//---------------------------------------------------------------------------//

FUNCTION dateTimeToString( dDate, cTime )

RETURN ( dtoc( dDate ) + space( 1 ) + trans( cTime, "@R 99:99:99" ) )

//---------------------------------------------------------------------------//

FUNCTION validTime( uTime )

   local cTime
   local nHour    
   local nMinutes 
   local nSeconds 

   if isObject( uTime )
      cTime       := uTime:varGet()
   else 
      cTime       := uTime
   end if 

   nHour          := val( substr( cTime, 1, 2 ) )
   nMinutes       := val( substr( cTime, 3, 2 ) )
   nSeconds       := val( substr( cTime, 5, 2 ) )

   if !validHour( nHour )
      RETURN .f.
   end if 

   if !validMinutesSeconds( nMinutes )
      RETURN .f.
   end if 

   if !validMinutesSeconds( nSeconds )
      RETURN .f.
   end if 

RETURN ( .t. )

FUNCTION validHour( nHour )

RETURN ( nHour >= 0 .and. nHour <= 23 )

FUNCTION validMinutesSeconds( nMinutes )

RETURN ( nMinutes >= 0 .and. nMinutes <= 59 )

//---------------------------------------------------------------------------//

FUNCTION validHourMinutes( uTime )

   local cTime
   local nHour
   local nMinutes

   if isObject( uTime )
      cTime       := uTime:varGet()
   else 
      cTime       := uTime
   end if 

   nHour          := val( substr( cTime, 1, 2 ) )
   nMinutes       := val( substr( cTime, 3, 2 ) )

   if !validHour( nHour )
      RETURN .f.
   end if 

   if !validMinutesSeconds( nMinutes )
      RETURN .f.
   end if 

RETURN ( .t. )

//--------------------------------------------------------------------------//

FUNCTION getSysTime()

RETURN ( strtran( time(), ":", "" ) )

//--------------------------------------------------------------------------//

FUNCTION getHoraInicioEmpresa()

RETURN ( uFieldEmpresa( "cIniJor" ) + "00")

//--------------------------------------------------------------------------//

FUNCTION DownLoadFileToUrl( cUrl, cName )

RETURN DOWNLOADFILE( cUrl, cName )

//---------------------------------------------------------------------------//

FUNCTION trimNif( cNif )

   cNif   := strtran( cNif, " ", "" )
   cNif   := strtran( cNif, ".", "" )
   cNif   := strtran( cNif, "-", "" )
   cNif   := strtran( cNif, "_", "" )

RETURN( cNif )

//--------------------------------------------------------------------------//
/*
FUNCTION ADSRunSQL( cAlias, cSql, aParameters, hConnection, lShow )

   LOCAL cOldAlias  := Alias()
   LOCAL lCreate    := FALSE
   LOCAL nItem      := 0
   LOCAL xParameter

   DEFAULT hConnection := hConn
   DEFAULT lShow       := FALSE

   IF !empty( cAlias ) .and. !empty( cSql )

      cSql := StrTran( cSql, ";", "" )

      DBSelectArea( 0 )

      IF !AdsCreateSqlStatement( cAlias, ADS_CDX, hConnection )
         msgStop( "Error AdsCreateSqlStatement()" + FINL + "Error: " + cValtoChar( AdsGetLastError() ) )
      ELSE
         IF !HB_IsNil( aParameters ) .and. HB_IsArray( aParameters )
            FOR EACH xParameter IN aParameters
               nItem := HB_EnumIndex()
               cSql  := StrTran( cSql, "%" + AllTrim( Str( nItem ) ) , Var2Str( xParameter ) )
            NEXT
         ENDIF
         IF lShow
            MsgInfo( cSql, "SQLDebug")
         ENDIF
         IF !AdsExecuteSqlDirect( cSql )
            ( cAlias )->( DBCloseArea() )
            msgStop( "Error AdsExecuteSqlDirect( cSql )" + FINL + "Error:" + cValtoChar( AdsGetLastError() ) + FINL + cSql )
         ELSE
            lCreate := TRUE
         ENDIF
      ENDIF

      IF !empty( cOldAlias )
         DBSelectArea( cOldAlias )
      ENDIF

   ENDIF

RETURN lCreate
*/

//---------------------------------------------------------------------------//

FUNCTION aNombreTarifas() 

   local n                
   local aNombreTarifas   := {}
   
   for n := 1 to NUMERO_TARIFAS

      if uFieldEmpresa( "lShwTar" + alltrim( str( n ) ) ) .or. ( n == 1 )
         aadd( aNombreTarifas, uFieldEmpresa( "cTxtTar" + alltrim( str( n ) ), "Precio " + alltrim( str( n ) ) ) )
      endif

   next

RETURN ( aNombreTarifas )

//---------------------------------------------------------------------------//

FUNCTION nNumeroTarifa( cNombreTarifa ) 

   local n
   
   for n := 1 to NUMERO_TARIFAS

      if ( uFieldEmpresa( "lShwTar" + alltrim( str( n ) ) ) .or. ( n == 1 ) ) .and. ;
         alltrim( uFieldEmpresa( "cTxtTar" + alltrim( str( n ) ) ) ) == cNombreTarifa
         RETURN ( n )
      endif

   next

RETURN ( 1 )

//---------------------------------------------------------------------------//

/*
SHOWTASKBAR() // Habilita
HIDETASKBAR() // Desabilita
TIRA_X()      // Desabilita o X da Janela
PISCA_EXE()   // Vai Piscar o Seu EXE na Barra do Windows
*/

#pragma BEGINDUMP

#include "windows.h"
#include "shlobj.h"
#include "hbapi.h" 
#include "math.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "hbapigt.h"
#include "hbstack.h"
#include "urlmon.h"

HB_MAXUINT hb_dateMilliSeconds( void );

HB_FUNC ( SHOWTASKBAR ) //Habilita o botao INICIAR
{
HWND hWnd = FindWindow("Shell_TrayWnd", "");

ShowWindow( hWnd, 1 );
}

HB_FUNC ( HIDETASKBAR ) //Desabilita o botao Iniciar
{
HWND hWnd = FindWindow("Shell_TrayWnd", "");

ShowWindow( hWnd, 0 );
}

HB_FUNC ( FLASHWINDOW ) // VAI PISCAR O SEU EXE NA BARRA
{
HWND Handle = GetForegroundWindow();

FlashWindow(Handle,TRUE); // VAI PISCAR O SEU EXE NA BARRA

Sleep(300); // TEMPO DE ESPERA
}

HB_FUNC ( DISABLECLOSEWINDOWS ) // DESABILITA O X da janela
{
HMENU MenuH = GetSystemMenu(GetForegroundWindow(),FALSE);

EnableMenuItem(MenuH,SC_CLOSE,MF_GRAYED);
}

HB_FUNC ( ENABLECLOSEWINDOWS ) // HABILITA O X da janela

{
HMENU MenuH = GetSystemMenu(GetForegroundWindow(),TRUE);

EnableMenuItem(MenuH,SC_CLOSE,MF_GRAYED);
}

HB_FUNC( DOWNLOADFILE )
{
   HRESULT hr;

   hr = URLDownloadToFileA( NULL, hb_parc( 1 ), hb_parc( 2 ), 0, NULL );
  
   hb_retnl( hr ) ;
}

HB_FUNC( HB_MILLISECONDS )
{
   hb_retnl( hb_dateMilliSeconds() );
}

#pragma ENDDUMP

//---------------------------------------------------------------------------//

FUNCTION inicializateHashVariables()

   hVariables := {=>}

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION setVariablesInHash( cClave, uValor )

   hset( hVariables, cClave, uValor )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION getVariablesToHash( cClave )

   local uVariable   := ""

   if hhaskey( hVariables, cClave )
      uVariable      := hGet( hVariables, cClave )
   end if

RETURN ( uVariable )

//---------------------------------------------------------------------------//

Function cTextRichText( cText )

   local nLen     := 0
   local nPos     := 1
   local cFormat  := ""
   local cTexto   := ""

   nLen           := At( "\rtf", SubStr( cText, nPos ) )
   nPos           += nLen
   cFormat        := Upper( SubStr( cText, nPos, 3 ) )

   if cFormat == "RTF"
      cTexto      := RTFToGTF( cText )
   end if

Return cTexto

//---------------------------------------------------------------------------//