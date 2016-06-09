#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch" 
#include "Font.ch"
#include "Inkey.ch"
#include "Ads.ch"
#include "Xbrowse.ch"
#include "dbInfo.ch" 
#include "directry.ch"
#include "hbcurl.ch"

#require "hbcurl"

#define GR_GDIOBJECTS         0      /* Count of GDI objects */
#define GR_USEROBJECTS        1      /* Count of USER objects */

#define CS_DBLCLKS            8

#define HKEY_LOCAL_MACHINE    2147483650

#define FONT_NAME             "Segoe UI" // "Arial" //  

ANNOUNCE RDDSYS

REQUEST ADS
REQUEST DBFCDX
REQUEST DBFFPT

REQUEST AdsKeyNo
REQUEST AdsKeyCount
REQUEST AdsGetRelKeyPos 
REQUEST AdsSetRelKeyPos

static oWndBar
static oMenu

static oMsgUser
static oMsgDelegacion
static oMsgCaja
static oMsgAlmacen
static oMsgSesion
static oMsgProgress

static oDlgProgress

static cParamsMain

static nHndReport

static hDLLRich

static oWnd
static oBmp
static lDemoMode        := .t. 

static lStandard
static lProfesional
static lOsCommerce

static cNameVersion
static cBmpVersion
static cTypeVersion     := ""

STATIC dbfClient
STATIC dbfObras 

//---------------------------------------------------------------------------//
/*
-------------------------------------------------------------------------------
//Comenzamos la parte de código que se compila para el ejecutable normal-------
-------------------------------------------------------------------------------
*/

function Main( ParamsMain, ParamsSecond )

   local nError
   local cError
   local oIndex
   local oIconApp
   local cAdsType
   local cAdsIp
   local cAdsPort
   local cAdsData
   local cAdsLocal
   local cAdsFile
   local nAdsServer
   
   local dbfUser
   local hAdsConnection

   local oDataUser
   local oDataTable

   local cSqlQuery
   local lSqlQuery

   DEFAULT ParamsMain   := ""

   cParamsMain          := Upper( ParamsMain )

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

   SetHandleCount( 240 )
   SetResDebug( .t. )

   FwNumFormat( 'E', .t. )

   DialogExtend() 

   // Chequeamos la existencia del fichero de configuracion--------------------

   if !File( cIniAplication() ) .and. File( FullCurDir() + "Gestion.Ini" )
      fRename( FullCurDir() + "Gestion.Ini", cIniAplication() )
   end if

   cAdsType          := GetPvProfString(  "ADS",      "Type",     "",   cIniAplication() )
   cAdsIp            := GetPvProfString(  "ADS",      "Ip",       "",   cIniAplication() )
   cAdsPort          := GetPvProfString(  "ADS",      "Port",     "",   cIniAplication() )
   cAdsData          := GetPvProfString(  "ADS",      "Data",     "",   cIniAplication() )
   nAdsServer        := GetPvProfInt(     "ADS",      "Server",   7,    cIniAplication() )
   cAdsLocal         := GetPvProfString(  "ADS",      "Local",    "",   cIniAplication() )
   cAdsFile          := GetPvProfString(  "ADS",      "File",     "",   cIniAplication() )

   cAdsIp(     cAdsIp )
   cAdsPort(   cAdsPort )
   cAdsData(   cAdsData )
   nAdsServer( nAdsServer )
   cAdsFile(   cAdsFile )
   cAdsLocal(  cAdsLocal )

   // Motor de bases de datos--------------------------------------------------

   if ( "ADMINISTRADOR" $ cParamsMain )
      TDataCenter():lAdministratorTask()
      Return nil
   end if 

   // Motor de bases de datos--------------------------------------------------

   if ( "ADSINTERNET" $ cAdsType )

      lAIS( .t. )
      rddRegister( 'ADS', 1 )
      rddSetDefault( 'ADSCDX' )

      adsSetServerType( nAdsServer() )    // TODOS
      adsSetFileType( 2 )                 // ADS_CDX
      adsRightsCheck( .f. )
      adsSetDeleted( .t. )
      adsCacheOpenTables( 250 )

      // Conexion con el motor de base de datos--------------------------------

      with object ( TDataCenter() )

         //:CreateDataDictionary()

         :ConnectDataDictionary()

         if !:lAdsConnection
            msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
            Return nil
         end if
      
      end with

   else 

      lCdx( .t. )
      rddSetDefault( 'DBFCDX' )

   end if

   TDataCenter():BuildData()

   // Opciones especiales de arranque hace la operacion y salir-------------------

   do case
      case ( "ENVIO" $ cParamsMain )

         if ( ":" $ cParamsMain )
            cEmpUsr( Right( cParamsMain, 2 ) )
         end if

         if lInitCheck()
            TSndRecInf():Init():AutoExecute()
         end if

         return nil

      case ( "REINDEXA" $ cParamsMain )

         if ( ":" $ cParamsMain )
            cEmpUsr( Right( cParamsMain, 2 ) )
         end if

         if lInitCheck()
            oIndex               := TReindex():New()
            oIndex:lMessageEnd   := .f.
            oIndex:Resource( .t. )
         end if

         return nil

      case ( "EMPRESA" $ cParamsMain )

         if ( ":" $ cParamsMain )
            cEmpUsr( Right( cParamsMain, 2 ) )
         end if

   end case

   // Iconos-------------------------------------------------------------------

   DEFINE ICON oIconApp RESOURCE "Gestool"

   // Chequeamos el directorio de datos

   if( !lIsDir( cPatDat() ),  MakeDir( cNamePath( cPatDat() ) ), )

   // Obtenemos la versión del programa----------------------------------------

   IsStandard()
   IsProfesional()
   IsOsCommerce()

   cNameVersion()

   // Chequeamos los datos de los usuarios-------------------------------------

   if !TReindex():lFreeHandle()
      msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicación" + CRLF + ;
               "en estos momentos, reintentelo pasados unos segundos." )
      return .f.
   end if

   XbrNumFormat( "E", .t. )

   do case
      case ( "TACTIL" $ cParamsMain )
         
         if AccessCode():TactilResource()
            InitMainTactilWindow( oIconApp )
         end if

      case ( "PDA" $ cParamsMain )
         
         if AccessCode():Resource()
            CreateMainPdaWindow( oIconApp )
         end if

      case ( "TABLET" $ cParamsMain )
         
         if AccessCode():loadTableConfiguration()
            CreateMainTabletWindow( oIconApp )
         end if

      otherwise
         
         if AccessCode():Resource()
            CreateMainWindow( oIconApp )
         end if

   end case

   dbCloseAll()

   if oBmp != nil
      oBmp:end()
   end if

   if oIconApp != nil
      oIconApp:end()
   end if

Return Nil

//----------------------------------------------------------------------------//

Function cParamsMain()

Return ( cParamsMain )

//---------------------------------------------------------------------------//

Function HelpTopic()

   msgStop( "Help wanted!" )

Return Nil

//----------------------------------------------------------------------------//

Function HelpIndex()

   goWeb( __GSTHELP__ )

Return Nil

//----------------------------------------------------------------------------//

Static Function CreateMainWindow( oIconApp )

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

   oWnd:Cargo                 := cParamsMain
   oWnd:bKeyDown              := { | nKey | StdKey( nKey ) }  

   // Mensajes-----------------------------------------------------------------

   oWnd:oMsgBar               := TMsgBar():New( oWnd, __GSTCOPYRIGHT__ + Space(2) + cNameVersion(), .f., .f., .f., .f., Rgb( 0,0,0 ), Rgb( 255,255,255 ), , .f. )
   oWnd:oMsgBar:setFont( oFontLittelTitle() )

   oDlgProgress               := TMsgItem():New( oWnd:oMsgBar, "", 100,,,, .t. )

   oWnd:oMsgBar:oDate         := TMsgItem():New( oWnd:oMsgBar, Dtoc( GetSysDate() ), oWnd:oMsgBar:GetWidth( DToC( GetSysDate() ) ) + 12,,,, .t., { || SelSysDate() } )
   oWnd:oMsgBar:oDate:lTimer  := .t.
   oWnd:oMsgBar:oDate:bMsg    := {|| GetSysDate() }
   oWnd:oMsgBar:CheckTimer()

   oMsgUser                   := TMsgItem():New( oWnd:oMsgBar, "Usuario : " + Rtrim( oUser():cNombre() ), 200,,,, .t. )

   oMsgDelegacion             := TMsgItem():New( oWnd:oMsgBar, "Delegación : " + Rtrim( oUser():cDelegacion() ), 200,,,, .t., {|| if( oUser():lCambiarEmpresa, SelectDelegacion( oMsgDelegacion ), ) } )

   oMsgCaja                   := TMsgItem():New( oWnd:oMsgBar, "Caja : "  + oUser():cCaja(), 100,,,, .t., {|| SelectCajas() } )

   oMsgAlmacen                := TMsgItem():New( oWnd:oMsgBar, "Almacén : " + Rtrim( oUser():cAlmacen() ), 100,,,, .t., {|| SelectAlmacen() } )

   oMsgSesion                 := TMsgItem():New( oWnd:oMsgBar, "Sesión : ", 100,,,, .t., {|| dbDialog() } ) 

   // Abrimos la ventana-------------------------------------------------------

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT    ( WndPaint( hDC, oWnd, oBmp ) ); 
      ON RESIZE   ( WndResize( oWnd ) );
      ON INIT     ( lStartCheck() );
      VALID       ( EndApp() ) // , FinishAplication(), .f. )

   SysRefresh()

Return nil

//---------------------------------------------------------------------------//

Static Function CreateMainTabletWindow()

   lDemoMode( .f. )

   if lInitCheck()
      MainTablet()
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function StdKey( nKey )

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

Return Nil

//---------------------------------------------------------------------------//
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
      Return .t.
   end if 

   nSerialHD      := Abs( nSerialHD() )
   nSerialUSR     := 0
   nlicencia      := 1
   oSayPerpetua   := Array( 2 )
   oSayAlquiler   := Array( 8 )
   cSayAlquiler   := Array( 8 )

   DEFINE DIALOG oDlg RESOURCE "GETSERIALNO" TITLE "Sistema de protección"

   REDEFINE BITMAP oBmpPerpetua ;
      RESOURCE    "certificate_32_alpha" ;
      ID          500;
      OF          oDlg

   REDEFINE BITMAP oBmpSaas ;
      RESOURCE    "piggy_bank_32_alpha" ;
      ID          510;
      OF          oDlg
      
   REDEFINE BITMAP oBmpDemo ;
      RESOURCE    "lock_32_alpha" ;
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

Return .t.

//---------------------------------------------------------------------------//

Function ExitDialog( oDlg, nLicencia, nSerialHD, nSerialUSR, oSerialUsr, oSayAlquiler, cSayAlquiler )

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

         if Empty( cSayAlquiler[1] )
            MsgStop( "El campo N.I.F./ C.I.F. no puede estar vacío" )
            oSayAlquiler[1]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[2] )
            MsgStop( "El campo nombre no puede estar vacío" )
            oSayAlquiler[2]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[3] )
            MsgStop( "El campo domicilio no puede estar vacío" )
            oSayAlquiler[3]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[4] )
            MsgStop( "El campo población no puede estar vacío" )
            oSayAlquiler[4]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[5] )
            MsgStop( "El campo código postal no puede estar vacío" )
            oSayAlquiler[5]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[6] )
            MsgStop( "El campo email no puede estar vacío" )
            oSayAlquiler[6]:SetFocus()
            Return .f.
         end if

         if !lValidMail( cSayAlquiler[6] )
            MsgStop( "El campo email no es valido" )
            oSayAlquiler[6]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[7] )
            MsgStop( "El campo teléfono no puede estar vacío" )
            oSayAlquiler[7]:SetFocus()
            Return .f.
         end if

         if Empty( cSayAlquiler[8] )
            MsgStop( "El campo provincia no puede estar vacío" )
            oSayAlquiler[8]:SetFocus()
            Return .f.
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

Return ( .t. )

//---------------------------------------------------------------------------//

Function lEnviarCorreoWatchdog( cSay, oDlg )

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

Return ( .t. )

//---------------------------------------------------------------------------//
         
Function lEnviarCorreoCliente( cSay, oDlg )

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
      :cGetMensaje           += "de 09:00 a 14:00 y de 17:00 a 21:00"

      /*
      Mandamos el Mail---------------------------------------------------------
      */

      :lExternalSend()

   end with

   CursorWe()

   oDlg:Enable()

Return ( .t. )

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

      if !Empty( oWnd )
         oWnd:CloseAll()
      end if

      SysRefresh()

      DEFINE BRUSH oBrush COLOR Rgb( 255, 255, 255 ) // FILE ( cBmpVersion() )

      DEFINE DIALOG oDlg RESOURCE "EndApp" BRUSH oBrush

         REDEFINE BITMAP oBmpVersion ;
            FILE     cBmpVersion() ;
            ID       600 ;
            OF       oDlg

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

      if !Empty( oBrush )
         oBrush:End()
      end if

      if !Empty( oBmpVersion )
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

Function WndResize( oWnd )

   local oBlock
   local oError

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( oWnd )

      aEval( oWnd:oWndClient:aWnd, {|o| oWnd:oWndClient:ChildMaximize( o ) } )

      if !Empty( oWndBar )
         oWndBar:CreateLogo()
      end if

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//-----------------------------------------------------------------------------//
// Comprobaciones iniciales

FUNCTION lInitCheck( oMessage, oProgress )

   local oError
   local lCheck      := .t.

   CursorWait()

   if !Empty( oProgress )
      oProgress:SetTotal( 6  )
   end if

   if !Empty( oMessage )
      oMessage:SetText( 'Comprobando directorios' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   // Comprobamos que exista los directorios necesarios------------------------

   CheckDirectory()

   // Cargamos los datos de la empresa-----------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Control de tablas de empresa' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   if ( nUsrInUse() == 1 )
      TstEmpresa()
   end if 

   // Cargamos los datos de la divisa------------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Control de tablas de divisas' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   if ( nUsrInUse() == 1 )
      TstDivisas()
   end if 

   // Cargamos los datos de la cajas-------------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Control de tablas de cajas' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   if ( nUsrInUse() == 1 )
      TstCajas()
   end if 

   // Inicializamos classes----------------------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Inicializamos las clases de la aplicación' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   InitClasses()

   // Apertura de ficheros-----------------------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Selección de la empresa actual' ) 
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   SetEmpresa( , , , , , oWnd )

   // Eventos del inicio---------------------------------

   // runEventScript( "IniciarAplicacion" )

   if !Empty( oMessage )
      oMessage:SetText( 'Comprobaciones finalizadas' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   CursorWe()

RETURN ( lCheck )

//---------------------------------------------------------------------------//

Function lStartCheck()

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
 
   if !empty( oMsgSesion() )
      oMsgSesion():setText( "Sesión : " + Transform( cCurSesion(), "######" ) )
   end if 

   // Colocamos los avisos pa las notas----------------------------------------

   oMsgText( 'Servicios de timers' )
   
   initServices()

   // Test---------------------------------------------------------------------

   Test()

   // Navegación---------------------------------------------------------------

   oMsgText( 'Abriendo panel de navegación' )

   if !Empty( oWnd ) .and. !( Os_IsWTSClient() )
      OpenWebBrowser( oWnd )
   end if

   // Texto limpio y a trabajar------------------------------------------------

   oMsgText()

   CursorWe()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function CheckDirectory()

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

   // Elimina los temporales de la aplicación----------------------------------

   eraseFilesInDirectory( cPatTmp(), "*.*" )
   eraseFilesInDirectory( cPatLog(), "*.*" )

Return ( nil )

//---------------------------------------------------------------------------//

/*
Ejecuta un fichero .hrb creado a partir de un .prg
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

Function Ejecutascript()

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

Return u

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg directamente
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

Function DirectEjecutaScript()

   Local u
   Local pHrb
   local aScripts
   local cScript  := ""

   /*
   Cerramos todas las ventanas antes de entrar---------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
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

Return u

//---------------------------------------------------------------------------//

Function InitClasses()

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

Return .t.

//--------------------------------------------------------------------------//

Function Titulo( cTxt )

Return ( if( oWnd != nil, oWnd:cTitle( cTxt ), "" ) )

//--------------------------------------------------------------------------//

Function oWndBar() ; Return oWndBar

//--------------------------------------------------------------------------//

Function oMsgSesion() ; Return ( oMsgSesion )

//--------------------------------------------------------------------------//

Function oMsgProgress()

   if Empty( oMsgProgress )
      oMsgProgress   := TProgress():New( 3, oDlgProgress:nLeft() - 2 , oWnd:oMsgBar, 0, , , .t., .f., oDlgProgress:nWidth - 2, 16 )
   end if

Return ( oMsgProgress )

//--------------------------------------------------------------------------//

Function EndProgress()

   oMsgProgress:End()

   oMsgProgress      := nil

Return ( nil )

//--------------------------------------------------------------------------//

Function oMsgText( cText )

   DEFAULT cText     := __GSTCOPYRIGHT__ + Space(2) + cNameVersion()

   if !Empty( oWnd )
      if _isData( oWnd, "oMsgBar" ) .and. ( oWnd:oMsgBar != nil ) 
         oWnd:oMsgBar:SetMsg( cText )
      end if
   end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function addMenu( oMenu, oTree )

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

return .t.

//----------------------------------------------------------------------------//

static function nLeft( oMsgBar )

   local n
   local nLen  := Len( oMsgBar:aItems )
   local nPos  := oMsgBar:nRight - 3

   if nLen > 0
      for n := 1 to nLen
         nPos -= ( oMsgBar:aItems[ n ]:nWidth + 4 )
      next
   end if

return nPos

//------------------------------------------------------------------------------------------------------------------------------

STATIC PROCEDURE GoToWeb()

   WinExec( "Start " + __GSTWEB__, 0 )

RETURN

//---------------------------------------------------------------------------//

static function WndPaint( hDC, oWnd, oBmp )

   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( oWnd ) .and. !Empty( oWnd:oWndClient )

         if len( oWnd:oWndClient:aWnd ) > 0
            aTail( oWnd:oWndClient:aWnd ):SetFocus()
         end if

      end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

return nil

//---------------------------------------------------------------------------//

function Garri()

   msginfo( UNENCRIP( "Xa^VKKQ2LPJ" ) )

return nil

//---------------------------------------------------------------------------//

FUNCTION UNENCRIP(_Def)

   local i
   local cStr  := ""

   for i := 1 to len( _Def )
      cStr     := cStr + CHR(ASC(SUBSTR(_Def, I, 1)) - LEN(_Def) + I - 1)
   next

RETURN cStr

//---------------------------------------------------------------------------//

init procedure InitAplication()

   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   HB_LangSelect( "ES" )      // Para mensajes, fechas, etc..
   HB_SetCodePage( "ESWIN" )  // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

   hDLLRich    := LoadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit

return

//---------------------------------------------------------------------------//
// Remember to use 'exit' procedures to asure that resources are
// freed on a possible application error

Static Function FinishAplication() //  Static Function

   CursorWait()

   if !Empty( cCodEmp() )
      WritePProString( "main", "Ultima Empresa", cCodEmp(), cIniAplication() )
   end if 

   lFreeUser()

   // Cerramos las auditorias--------------------------------------------------

   StopServices()

   // Cerramos el Activex------------------------------------------------------

   CloseWebBrowser( oWnd )

   // Limpiamos los recursos estaticos-----------------------------------------

   TAcceso():End()

   TBandera():Destroy()

   FreeResources()

   // Cerramos la dll----------------------------------------------------------

   if !Empty( hDLLRich )
      FreeLibrary( hDLLRich )
   end if 

   // Cerramos el report-------------------------------------------------------

   if !Empty( nHndReport )
      PostMessage( nHndReport, WM_CLOSE )
   end if

   CursorWE()

   ferase( "chekres.txt" )

   checkRes()

   // winExec( "notepad checkres.txt" )

Return nil

//---------------------------------------------------------------------------//

Function cNbrUsr( cNbr )

   if cNbr != nil .and. oMsgUser != nil
      oMsgUser:SetText( "Usuario : " + RTrim( cNbr ) )
   end if

Return cNbr

//---------------------------------------------------------------------------//

Function cCajUsr( cCaj )

   if !Empty( cCaj ) .and. oMsgCaja != nil
      oMsgCaja:SetText( "Caja : " + RTrim( cCaj ) )
   end if

Return ( cCaj )

//---------------------------------------------------------------------------//

Function cAlmUsr( cAlm )

   if cAlm != nil .and. oMsgAlmacen != nil
      oMsgAlmacen:SetText( "Almacén : " + RTrim( cAlm ) )
   end if

Return ( cAlm )

//---------------------------------------------------------------------------//

Function cDlgUsr( cDlg )

   if cDlg != nil .and. oMsgDelegacion != nil
      oMsgDelegacion:SetText( "Delegación : " + RTrim( cDlg ) )
   end if

Return ( cDlg )

//---------------------------------------------------------------------------//

Function RunReportGalery()

   local nLevel   := nLevelUsr( "01119" )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return nil
   end if

   if DirChange( FullCurDir() ) != 0
      MsgStop( "No puedo cambiar al directorio " + FullCurDir() )
      Return nil
   end if

   if File( FullCurDir() + "RptApolo.Exe" )

      nHndReport  := WinExec( FullCurDir() + "RptApolo.Exe " + cCodEmp() + " " + cCurUsr(), 1 )

      if !( nHndReport > 21 .or. nHndReport < 0 )
         MsgStop( "Error en la ejecución de la galeria de informes" )
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Function RunAsistenciaRemota()

   local nHnd

   if File( FullCurDir() + "Client\Client.Exe" )

      nHnd     := WinExec( FullCurDir() + "Client\Client.Exe" , 1 )

      if !( nHnd > 21 .or. nHnd < 0 )
         MsgStop( "Error en la ejecución de la asistencia remota" )
      end if

   else

      goWeb( __GSTWEB__ + "/exe/Client.exe" )

   end if

Return nil

//---------------------------------------------------------------------------//

Function CreateAcceso( oWnd )

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
   oItemArchivo:cBmp    := "Folder16"
   oItemArchivo:cBmpBig := "Folder_32"
   oItemArchivo:lShow   := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Inicio'
   oGrupo:cLittleBitmap := "Home_16"
   oGrupo:cBigBitmap    := "Home_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Gestión de cartera'
   oItem:cMessage       := 'Gestión de cartera'
   oItem:bAction        := {|| PageIni( "01004", oWnd() ) }
   oItem:cId            := "01004"
   oItem:cBmp           := "briefcase2_column-chart_16"
   oItem:cBmpBig        := "briefcase2_column-chart_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Iniciar sesión'
   oItem:cMessage       := 'Inicia una nueva sesión de trabajo'
   oItem:bAction        := {|| ChkTurno( "01000", oWnd() ) }
   oItem:cId            := "01000"
   oItem:cBmp           := "clock_run_16"
   oItem:cBmpBig        := "clock_run"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Arqueo parcial (X)'
   oItem:cMessage       := 'Inicia una nueva sesión de trabajo'
   oItem:bAction        := {|| CloseTurno( "01001", oWnd(), .t. ) }
   oItem:cId            := "01001"
   oItem:cBmp           := "Stopwatch_Refresh_16"
   oItem:cBmpBig        := "Stopwatch_Refresh_32"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cerrar sesión (Z)'
   oItem:cMessage       := 'Cierra la sesión de trabajo actual'
   oItem:bAction        := {|| CloseTurno( "01006", oWnd() ) }
   oItem:cId            := "01006"
   oItem:cBmp           := "clock_stop_16"
   oItem:cBmpBig        := "clock_stop"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Sesiones'
   oItem:cMessage       := 'Sesiones de trabajo'
   oItem:bAction        := {|| Turnos( "01002", oWnd() ) }
   oItem:cId            := "01002"
   oItem:cBmp           := "bClock"
   oItem:cBmpBig        := "clock"

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Empresa'
   oGrupo:cLittleBitmap := "Office_Building_16"
   oGrupo:cBigBitmap    := "Office_Building_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Empresa'
   oItem:cMessage       := 'Acceso al fichero de empresas'
   oItem:bAction        := {|| Empresa() }
   oItem:cId            := "01003"
   oItem:cBmp           := "Office_Building_16"
   oItem:cBmpBig        := "Office_Building_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Configurar empresa'
   oItem:cMessage       := 'Configurar empresa en curso'
   oItem:bAction        := {|| ConfEmpresa( oWnd() ) }
   oItem:cId            := "01005"
   oItem:cBmp           := "CnfCli16"
   oItem:cBmpBig        := "CnfCli32"
   oItem:lShow          := .t.

   // Articulos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:nLittleItems  := 3
   oGrupo:cPrompt       := 'Artículos'
   oGrupo:cLittleBitmap := "Cube_Yellow_16"
   oGrupo:cBigBitmap    := "Cube_Yellow_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos de familias'
   oItem:cMessage       := 'Acceso al fichero de grupos de familias'
   oItem:bAction        := {|| TGrpFam():New( cPatArt(), oWnd(), "01011" ):Play() }
   oItem:cId            := "01011"
   oItem:cBmp           := "Folder_Cubes_Color_16"
   oItem:cBmpBig        := "Folder_Cubes_Color_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Familias'
   oItem:cMessage       := 'Acceso al fichero de familias'
   oItem:bAction        := {|| Familia( "01012", oWnd() ) }
   oItem:cId            := "01012"
   oItem:cBmp           := "Cubes_16"
   oItem:cBmpBig        := "Cubes_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Artículos'
   oItem:cMessage       := 'Acceso al fichero de artículo'
   oItem:bAction        := {|| Articulo( "01014", oWnd ) }
   oItem:cId            := "01014"
   oItem:cBmp           := "Cube_Yellow_16"
   oItem:cBmpBig        := "Cube_Yellow_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Fabricantes'
   oItem:cMessage       := 'Clasificación de artículos por fabricantes'
   oItem:bAction        := {|| TFabricantes():New( cPatArt(), oWnd, "01070" ):Activate() }
   oItem:cId            := "01070"
   oItem:cBmp           := "Nut_and_bolt_16"
   oItem:cBmpBig        := "Nut_and_bolt_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Comentarios'
   oItem:cMessage       := 'Acceso a los comentarios de los artículos'
   oItem:bAction        := {|| TComentarios():New( cPatArt(), oWnd, "04002" ):Activate() }
   oItem:cId            := "04002"
   oItem:cBmp           := "message_16"
   oItem:cBmpBig        := "message_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   /*
   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Códigos barras'
   oItem:cMessage       := 'Acceso a los códigos de barras de los artículos'
   oItem:bAction        := {|| ArtCodebar( "01024", oWnd ) }
   oItem:cId            := "01024"
   oItem:cBmp           := "Remotecontrol_16"
   oItem:cBmpBig        := "Remotecontrol_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.
   */

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Propiedades'
   oItem:cMessage       := 'Acceso a las propiedades los artículos'
   oItem:bAction        := {|| Prop( "01015", oWnd ) }
   oItem:cId            := "01015"
   oItem:cBmp           := "Die_Gold_16"
   oItem:cBmpBig        := "Die_Gold_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Factores conversión'
   oItem:cMessage       := 'Acceso a los factores de conversion de los artículos'
   oItem:bAction        := {|| TblCnv( "01016", oWnd ) }
   oItem:cId            := "01016"
   oItem:cBmp           := "Tape_Measure2_16"
   oItem:cBmpBig        := "Tape_Measure2_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Unidades medición'
   oItem:cMessage       := 'Unidades de medición'
   oItem:bAction        := {|| UniMedicion():New( cPatGrp(), oWnd, "01103" ):Activate() }
   oItem:cId            := "01103"
   oItem:cBmp           := "Tape_Measure1_16"
   oItem:cBmpBig        := "Tape_Measure1_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos'
   oItem:cMessage       := 'Clasificación de artículos por tipos'
   oItem:bAction        := {|| TTipArt():New( cPatArt(), cDriver(), oWnd, "01013" ):Activate() }
   oItem:cId            := "01013"
   oItem:cBmp           := "Cubes_Blue_16"
   oItem:cBmpBig        := "Cubes_Blue_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := getTraslation( 'Categorías' )
   oItem:cMessage       := 'Acceso al fichero de ' + getTraslation( 'categorías' )
   oItem:bAction        := {|| Categoria( "01101", oWnd() ) }
   oItem:cId            := "01101"
   oItem:cBmp           := "Colors_16"
   oItem:cBmpBig        := "Colors_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := getTraslation( 'Temporadas' )
   oItem:cMessage       := 'Acceso al fichero de ' + getTraslation( 'temporadas' )
   oItem:bAction        := {|| Temporada( "01114", oWnd() ) }
   oItem:cId            := "01114"
   oItem:cBmp           := "Sun_and_cloud_16"
   oItem:cBmpBig        := "Colors_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Envasado"
   oItem:cMessage       := 'Acceso al fichero de envasado'
   oItem:bAction        := {|| TFrasesPublicitarias():New( , oWnd(), "01129" ):Activate() }
   oItem:cId            := "01129"
   oItem:cBmp           := "box_white_16"
   oItem:cBmpBig        := "box_white_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Tarifas------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Tarifas'
   oGrupo:cLittleBitmap := "Percent_16"
   oGrupo:cBigBitmap    := "Percent_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tarifas de precios'
   oItem:cMessage       := 'Acceso a las tarifas de precios'
   oItem:bAction        := {|| Tarifa( "01019", oWnd ) }
   oItem:cId            := "01019"
   oItem:cBmp           := "Percent_16"
   oItem:cBmpBig        := "Percent_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ofertas'
   oItem:cMessage       := 'Acceso a las ofertas de artículos'
   oItem:bAction        := {|| Oferta( "01020", oWnd ) }
   oItem:cId            := "01020"
   oItem:cBmp           := "Star_Red_16"
   oItem:cBmpBig        := "Star_Red_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Promociones'
   oItem:cMessage       := 'Acceso a las promociones comerciales'
   oItem:bAction        := {|| Promocion( "01021", oWnd ) }
   oItem:cId            := "01021"
   oItem:cBmp           := "Star_Blue_16"
   oItem:cBmpBig        := "Star_Blue_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Busquedas----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := if( lAIS(), 3, 2 )
   oGrupo:cPrompt       := 'Búsquedas'
   oGrupo:cLittleBitmap := "Package_Find_16"
   oGrupo:cBigBitmap    := "Package_Find_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Búsqueda por series'
   oItem:cMessage       := 'Búsqueda por series'
   oItem:bAction        := {|| TSeaNumSer():Activate( "01022", oWnd ) }
   oItem:cId            := "01022"
   oItem:cBmp           := "Package_Find_16"
   oItem:cBmpBig        := "Package_Find_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Búsqueda por lotes'
   oItem:cMessage       := 'Búsqueda por lotes'
   oItem:bAction        := {|| TTrazarLote():Activate( "01023", oWnd ) }
   oItem:cId            := "01023"
   oItem:cBmp           := "Package_View_16"
   oItem:cBmpBig        := "Package_View_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .f.

   if lAIS()

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Búsqueda especial'
   oItem:cMessage       := 'Búsqueda especial'
   oItem:bAction        := {|| tSpecialSearchArticulo():New( "01127", oWnd ) }
   oItem:cId            := "01127"
   oItem:cBmp           := "zoom_in_16"
   oItem:cBmpBig        := "zoom_in_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .f.

   end if


   // Impuestos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Impuestos'
   oGrupo:cLittleBitmap := "Moneybag_16"
   oGrupo:cBigBitmap    := "Moneybag_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de " + cImp()
   oItem:cMessage       := "Acceso a los tipos de " + cImp()
   oItem:bAction        := {|| Tiva( "01036", oWnd ) }
   oItem:cId            := "01036"
   oItem:cBmp           := "Moneybag_16"
   oItem:cBmpBig        := "Moneybag_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Impuestos especiales"
   oItem:cMessage       := "Impuestos especiales"
   oItem:bAction        := {|| NewImp( "01037", oWnd ) }
   oItem:cId            := "01037"
   oItem:cBmp           := "Moneybag_Dollar_16"
   oItem:cBmpBig        := "Moneybag_Dollar_32"
   oItem:lShow          := .f.

   // Impuestos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Pagos'
   oGrupo:cLittleBitmap := "Currency_Euro_16"
   oGrupo:cBigBitmap    := "Currency_Euro_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Divisas monetarias"
   oItem:cMessage       := "Acceso a divisas monetarias"
   oItem:bAction        := {|| Divisas( "01038", oWnd ) }
   oItem:cId            := "01038"
   oItem:cBmp           := "Currency_Euro_16"
   oItem:cBmpBig        := "Currency_Euro_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Bancos'
   oItem:cMessage       := 'Acceso a las entidades bancarias'
   oItem:bAction        := {|| TBancos():New( cPatGrp(), oWnd, "01106" ):Activate() }
   oItem:cId            := "01106"
   oItem:cBmp           := "Banc_16"
   oItem:cBmpBig        := "Banc_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cuentas bancarias'
   oItem:cMessage       := 'Acceso a las cuentas bancarias'
   oItem:bAction        := {|| TCuentasBancarias():New( cPatGrp(), oWnd, "01106" ):Activate() }
   oItem:cId            := "01106"
   oItem:cBmp           := "office-building_address_book_16"
   oItem:cBmpBig        := "office-building_address_book_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Formas"
   oItem:cMessage       := "Acceso a formas de pago"
   oItem:bAction        := {|| Fpago( "01039", oWnd ) }
   oItem:cId            := "01039"
   oItem:cBmp           := "Creditcards_16"
   oItem:cBmpBig        := "Creditcards_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cuentas de remesas"
   oItem:cMessage       := "Acceso a las cuentas de remesas"
   oItem:bAction        := {|| TCtaRem():New( cPatCli(), cDriver(), oWnd, "01044" ):Activate() }
   oItem:cId            := "01044"
   oItem:cBmp           := "Address_book2_16"
   oItem:cBmpBig        := "Address_book2_32"
   oItem:lShow          := .f.

   // Otros--------------------------------------------------------------------

   oGrupo               := TGrupoAcceso() 
   oGrupo:nBigItems     := 13
   oGrupo:cPrompt       := 'Global'
   oGrupo:cLittleBitmap := "Folder2_Red_16"
   oGrupo:cBigBitmap    := "Folder2_Red_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cajas"
   oItem:cMessage       := "Acceso a las cajas"
   oItem:bAction        := {|| Cajas( "01040", oWnd ) }
   oItem:cId            := "01040"
   oItem:cBmp           := "Cashier_16"
   oItem:cBmpBig        := "Cashier_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos ventas'
   oItem:cMessage       := 'Acceso a los grupos de ventas de contabilidad'
   oItem:bAction        := {|| GrpVenta( "01018", oWnd ) }
   oItem:cId            := "01018"
   oItem:cBmp           := "Index_16"
   oItem:cBmpBig        := "Index_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := GetTraslation( 'Proyectos' )
   oItem:cMessage       := GetTraslation( 'Proyectos' )
   oItem:bAction        := {|| TProyecto():New( cPatArt(), oWnd ):Activate() }
   oItem:cId            := "01104"
   oItem:cBmp           := "Led_Red_16"
   oItem:cBmpBig        := "Led_Red_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Centro de costes"
   oItem:cMessage       := "Acceso al centro de coste"
   oItem:bAction        := {|| TCentroCoste():New( cPatDat(), oWnd, "01128" ):Activate() }
   oItem:cId            := "01128"
   oItem:cBmp           := "centro_coste_16"
   oItem:cBmpBig        := "centro_coste_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Codigos postales'
   oItem:cMessage       := 'Acceso al fichero de codigos postales'
   oItem:bAction        := {|| CodigosPostales():New( cPatDat(), cDriver(), oWnd, "01011" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "Flag_spain_16"
   oItem:cBmpBig        := "Flag_spain_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Provincias'
   oItem:cMessage       := 'Acceso al fichero de grupos de provincias'
   oItem:bAction        := {|| Provincias():New( cPatDat(), cDriver(), oWnd, "01011" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "Flag_spain_16"
   oItem:cBmpBig        := "Flag_spain_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Paises"
   oItem:cMessage       := "Acceso a los paises"
   oItem:bAction        := {|| TPais():New( cPatDat(), cDriver(), oWnd, "01041" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "Flag_spain_16"
   oItem:cBmpBig        := "Flag_spain_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Lenguajes"
   oItem:cMessage       := "Acceso a los lenguajes"
   oItem:bAction        := {|| TLenguaje():New( cPatDat(), oWnd, "01041" ):Activate() }
   oItem:cId            := "01125"
   oItem:cBmp           := "user1_message_16"
   oItem:cBmpBig        := "user1_message_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de ventas"
   oItem:cMessage       := "Acceso a los tipos de ventas"
   oItem:bAction        := {|| TVta( "01043", oWnd ) }
   oItem:cId            := "01043"
   oItem:cBmp           := "Wallet_closed_16"
   oItem:cBmpBig        := "Wallet_closed_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Transportistas"
   oItem:cMessage       := "Acceso a los transportistas"
   oItem:bAction        := {|| TTrans():New( cPatCli(), oWnd, "01045" ):Activate() }
   oItem:cId            := "01045"
   oItem:cBmp           := "Truck_Blue_16"
   oItem:cBmpBig        := "Truck_Blue_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de incidencias"
   oItem:cMessage       := "Acceso a los tipos de incidencias"
   oItem:bAction        := {|| TipInci( "01089", oWnd ) }
   oItem:cId            := "01089"
   oItem:cBmp           := "Camera_16"
   oItem:cBmpBig        := "Camera_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Situaciones"
   oItem:cMessage       := "Acceso a los tipos de situaciones"
   oItem:bAction        := {|| TSituaciones():New( cPatDat(), oWnd ):Play() }
   oItem:cId            := "01096"
   oItem:cBmp           := "Document_Attachment_16"
   oItem:cBmpBig        := "Document_Attachment_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Estados artículos'
   oItem:cMessage       := 'Acceso al fichero de ' + getTraslation( 'categorías' )
   oItem:bAction        := {|| EstadoSat( "01126", oWnd() ) }
   oItem:cId            := "01126"
   oItem:cBmp           := "bookmarks_preferences_16"
   oItem:cBmpBig        := "bookmarks_preferences_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de notas"
   oItem:cMessage       := "Acceso a los tipos de notas"
   oItem:bAction        := {|| TipoNotas( "01097", oWnd ) }
   oItem:cId            := "01097"
   oItem:cBmp           := "Folder2_Red_16"
   oItem:cBmpBig        := "Folder2_Red_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de impresoras"
   oItem:cMessage       := "Acceso a los tipos de impresoras"
   oItem:bAction        := {|| TipoImpresoras( "01115", oWnd ) }
   oItem:cId            := "01115"
   oItem:cBmp           := "printer_view_16"
   oItem:cBmpBig        := "printer_view_32"
   oItem:lShow          := .f.

   // Compras-------------------------------------------------------------------

   if IsStandard()

   oItemCompras         := oAcceso:Add()
   oItemCompras:cPrompt := 'COMPRAS'
   oItemCompras:cBmp    := "Folder16"
   oItemCompras:cBmpBig := "Folder_32"
   oItemCompras:lShow   := .t.

   // Proveedores--------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Proveedores'
   oGrupo:cLittleBitmap := "Businessman_16"
   oGrupo:cBigBitmap    := "Businessman_32"

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos'
   oItem:cMessage       := 'Acceso a los grupos de proveedores'
   oItem:bAction        := {|| TGrpPrv():New( cPatPrv(), oWnd, "01110" ):Activate() }
   oItem:cId            := "01110"
   oItem:cBmp           := "GrpPrv_16"
   oItem:cBmpBig        := "GrpPrv_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Proveedores'
   oItem:cMessage       := 'Acceso a los proveedores'
   oItem:bAction        := {|| Provee( "01034", oWnd ) }
   oItem:cId            := "01034"
   oItem:cBmp           := "Businessman_16"
   oItem:cBmpBig        := "Businessman_32"
   oItem:lShow          := .t.

   // Compras------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Compras'
   oGrupo:cLittleBitmap := "Document_businessman_16"
   oGrupo:cBigBitmap    := "Document_businessman_32"

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pedidos'
   oItem:cMessage       := 'Acceso a los pedidos de proveedores'
   oItem:bAction        := {|| PedPrv( "01046", oWnd ) }
   oItem:cId            := "01046"
   oItem:cBmp           := "Clipboard_empty_businessman_16"
   oItem:cBmpBig        := "Clipboard_empty_businessman_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Albaranes'
   oItem:cMessage       := 'Acceso a los albaranes de proveedores'
   oItem:bAction        := {|| AlbPrv( "01047", oWnd ) }
   oItem:cId            := "01047"
   oItem:cBmp           := "Document_plain_businessman_16"
   oItem:cBmpBig        := "Document_plain_businessman_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas'
   oItem:cMessage       := 'Acceso a las facturas de proveedores'
   oItem:bAction        := {|| FacPrv( "01048", oWnd ) }
   oItem:cId            := "01048"
   oItem:cBmp           := "Document_businessman_16"
   oItem:cBmpBig        := "Document_businessman_32"
   oItem:lShow          := .t.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas rectificativas'
   oItem:cMessage       := 'Acceso a las facturas rectificativas de proveedores'
   oItem:bAction        := {|| RctPrv( "01099", oWnd ) }
   oItem:cId            := "01099"
   oItem:cBmp           := "Document_navigate_cross_16"
   oItem:cBmpBig        := "Document_navigate_cross_32"
   oItem:lShow          := .f.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pagos'
   oItem:cMessage       := 'Acceso a los pagos a proveedores'
   oItem:bAction        := {|| RecPrv( "01049", oWnd ) }
   oItem:cId            := "01049"
   oItem:cBmp           := "Money2_businessman_16"
   oItem:cBmpBig        := "Money2_businessman_32"
   oItem:lShow          := .t.

   // Almacenes--------------------------------------------------------------

   oItemAlmacen         := oAcceso:Add()
   oItemAlmacen:cPrompt := 'ALMACENES'
   oItemAlmacen:cBmp    := "Folder16"
   oItemAlmacen:cBmpBig := "Folder_32"
   oItemAlmacen:lShow   := .t.

   // Almacenes----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Almacenes'
   oGrupo:cLittleBitmap := "Package_16"
   oGrupo:cBigBitmap    := "Package_32"

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Almacenes'
   oItem:cMessage       := 'Acceso a los almacenes'
   oItem:bAction        := {|| Almacen( "01035", oWnd ) }
   oItem:cId            := "01035"
   oItem:cBmp           := "Package_16"
   oItem:cBmpBig        := "Package_32"
   oItem:lShow          := .f.

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de movimientos"
   oItem:cMessage       := "Acceso a los tipos de movimientos de almacén"
   oItem:bAction        := {|| TMov( "01042", oWnd ) }
   oItem:cId            := "01042"
   oItem:cBmp           := "Package_replace2_16"
   oItem:cBmpBig        := "Package_replace2_32"
   oItem:lShow          := .f.

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ubicaciones'
   oItem:cMessage       := 'Acceso a las ubicaciones de almacenes'
   oItem:bAction        := {|| Ubicacion( "01088", oWnd ) }
   oItem:cId            := "01088"
   oItem:cBmp           := "Forklifter_16"
   oItem:cBmpBig        := "Forklifter_32"
   oItem:lShow          := .f.

   /*
   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Movimientos almacén'
   oGrupo:cLittleBitmap := "Pencil_Package_16"
   oGrupo:cBigBitmap    := "Pencil_Package_32"
   */

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Movimientos almacén'
   oItem:cMessage       := 'Acceso a los movimientos de almacén'
   oItem:bAction        := {|| RemMovAlm( "01050", oWnd ) }
   oItem:cId            := "01050"
   oItem:cBmp           := "Pencil_Package_16"
   oItem:cBmpBig        := "Pencil_Package_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:cPrompt       := 'Depósitos'
   oGrupo:cLittleBitmap := "Pencil_Package_16"
   oGrupo:cBigBitmap    := "Pencil_Package_32"

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Introducción depósitos'
   oItem:cMessage       := 'Acceso a la introducción de depósitos de almacén'
   oItem:bAction        := {|| DepAge( "01052", oWnd ) }
   oItem:cId            := "01052"
   oItem:cBmp           := "Package_add_16"
   oItem:cBmpBig        := "Package_add_32"
   oItem:lShow          := .f.

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Estado depósitos'
   oItem:cMessage       := 'Acceso a los estados de depósitos de almacén'
   oItem:bAction        := {|| ExtAge( "01053", oWnd ) }
   oItem:cId            := "01053"
   oItem:cBmp           := "Package_ok_16"
   oItem:cBmpBig        := "Package_ok_32"
   oItem:lShow          := .f.

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Liquidación depósitos'
   oItem:cMessage       := 'Acceso a las liquidaciones de depósitos de almacén'
   oItem:bAction        := {|| LqdAlm( "01054", oWnd ) }
   oItem:cId            := "01054"
   oItem:cBmp           := "Package_preferences_16"
   oItem:cBmpBig        := "Package_preferences_32"
   oItem:lShow          := .f.

   end if

   // Producción---------------------------------------------------------------

   if IsProfesional()

   oItemProduccion            := oAcceso:Add()
   oItemProduccion:cPrompt    := 'PRODUCCIÓN' 
   oItemProduccion:cBmp       := "Folder16"
   oItemProduccion:cBmpBig    := "Folder_32"
   oItemProduccion:lShow      := .t. 

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := 'Estructura'
   oGrupo:cLittleBitmap := "Package_16"
   oGrupo:cBigBitmap    := "Package_32"

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Secciones'
   oItem:cMessage       := 'Acceso a las secciones de producción'
   oItem:bAction        := {|| TSeccion():New( cPatEmp(), cDriver(), oWnd, "04001" ):Activate() }
   oItem:cId            := "04001"
   oItem:cBmp           := "Group_Worker2_16"
   oItem:cBmpBig        := "Group_Worker2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Operarios'
   oItem:cMessage       := 'Acceso a los operarios'
   oItem:bAction        := {|| TOperarios():New( cPatEmp(), cDriver(), oWnd, "04002" ):Activate() }
   oItem:cId            := "04002"
   oItem:cBmp           := "Worker2_16"
   oItem:cBmpBig        := "Worker2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo  
   oItem:cPrompt        := 'Tipos de horas'
   oItem:cMessage       := 'Acceso a tipos de horas de producción'
   oItem:bAction        := {|| THoras():New( cPatEmp(), cDriver(), oWnd, "04003" ):Activate() }
   oItem:cId            := "04003"
   oItem:cBmp           := "Worker2_Clock_16"
   oItem:cBmpBig        := "Worker2_Clock_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Operaciones'
   oItem:cMessage       := 'Acceso a las operaciones'
   oItem:bAction        := {|| TOperacion():New( cPatEmp(), cDriver(), oWnd, "04004" ):Activate() }
   oItem:cId            := "04004"
   oItem:cBmp           := "Worker2_Hammer2_16"
   oItem:cBmpBig        := "Worker2_Hammer2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos de operaciones'
   oItem:cMessage       := 'Acceso a tipos de operaciones'
   oItem:bAction        := {|| TTipOpera():New( cPatEmp(), cDriver(), oWnd, "04005" ):Activate() }
   oItem:cId            := "04005"
   oItem:cBmp           := "Worker_Folder_Blue_16"
   oItem:cBmpBig        := "Worker_Folder_Blue_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Maquinaria'
   oItem:cMessage       := 'Acceso a la maquinaria'
   oItem:bAction        := {|| StartTMaquina() }
   oItem:cId            := "04006"
   oItem:cBmp           := "Robot_16"
   oItem:cBmpBig        := "Robot_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Costes maquinaria'
   oItem:cMessage       := 'Acceso a los costes de la maquinaria'
   oItem:bAction        := {|| TCosMaq():New( cPatEmp(), cDriver(), oWnd, "04007" ):Activate() }
   oItem:cId            := "04007"
   oItem:cBmp           := "Robot_Money2_16"
   oItem:cBmpBig        := "Robot_Money2_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Producción'
   oGrupo:cLittleBitmap := "Worker2_Form_Red_16"
   oGrupo:cBigBitmap    := "Worker2_Form_Red_32"

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Partes producción'
   oItem:cMessage       := 'Acceso a los partes de producción'
   oItem:bAction        := {|| StartTProduccion( cDriver()) }
   oItem:cId            := "04008"
   oItem:cBmp           := "Worker2_Form_Red_16"
   oItem:cBmpBig        := "Worker2_Form_Red_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Costos mano obra'
   oItem:cMessage       := 'Actualiza costos de mano de obra'
   oItem:bAction        := {|| ActualizaCosto():Activate( "04009", oWnd ) }
   oItem:cId            := "04009"
   oItem:cBmp           := "Worker2_Money_16"
   oItem:cBmpBig        := "Worker2_Money_32"
   oItem:lShow          := .f.

   end if

   // Producción---------------------------------------------------------------

   if IsProfesional()

   oItemExpediente            := oAcceso:Add()
   oItemExpediente:cPrompt    := 'EXPEDIENTES'
   oItemExpediente:cBmp       := "Folder16"
   oItemExpediente:cBmpBig    := "Folder_32"
   oItemExpediente:lShow      := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Expedientes'
   oGrupo:cLittleBitmap := "Folder_document_16"
   oGrupo:cBigBitmap    := "Folder_document_32"

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipo expediente'
   oItem:cMessage       := 'Acceso a los tipos de expedientes'
   oItem:bAction        := {|| StartTTipoExpediente() }
   oItem:cId            := "04011"
   oItem:cBmp           := "Folders_16"
   oItem:cBmpBig        := "Folders_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Entidades'
   oItem:cMessage       := 'Acceso a las distintas entidades'
   oItem:bAction        := {|| TEntidades():New( cPatEmp(), cDriver(), oWnd, "04012" ):Activate() }
   oItem:cId            := "04012"
   oItem:cBmp           := "School_16"
   oItem:cBmpBig        := "School_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Colaboradores'
   oItem:cMessage       := 'Acceso a la tabla de colaboradores'
   oItem:bAction        := {|| TColaboradores():New( cPatEmp(), cDriver(), oWnd, "04013" ):Activate() }
   oItem:cId            := "04013"
   oItem:cBmp           := "Teacher_16"
   oItem:cBmpBig        := "Teacher_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Actuaciones'
   oItem:cMessage       := 'Acceso a la tabla de actuaciones'
   oItem:bAction        := {|| TActuaciones():New( cPatEmp(), cDriver(), oWnd, "04014" ):Activate() }
   oItem:cId            := "04014"
   oItem:cBmp           := "Power_Drill_16"
   oItem:cBmpBig        := "Power_Drill_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Expedientes'
   oItem:cMessage       := 'Acceso a los expedientes'
   oItem:bAction        := {|| StartTExpediente() }
   oItem:cId            := "04010"
   oItem:cBmp           := "Folder_document_16"
   oItem:cBmpBig        := "Folder_document_32"
   oItem:lShow          := .f.

   end if

   // Ventas-------------------------------------------------------------------

   oItemVentas          := oAcceso:Add()
   oItemVentas:cPrompt  := 'VENTAS'
   oItemVentas:cBmp     := "Folder16"
   oItemVentas:cBmpBig  := "Folder_32"
   oItemVentas:lShow    := .t.

   // Clientes----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := If( IsProfesional(), 7, 4 )
   oGrupo:cPrompt       := 'Clientes'
   oGrupo:cLittleBitmap := "User1_16"
   oGrupo:cBigBitmap    := "User1_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos'
   oItem:cMessage       := 'Acceso a los grupos de clientes'
   oItem:bAction        := {|| TGrpCli():New( cPatCli(), cDriver(), oWnd, "01030" ):Activate() }
   oItem:cId            := "01030"
   oItem:cBmp           := "Users2_16"
   oItem:cBmpBig        := "Users2_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Rutas'
   oItem:cMessage       := 'Acceso a las rutas de clientes'
   oItem:bAction        := {|| Ruta( "01031", oWnd ) }
   oItem:cId            := "01031"
   oItem:cBmp           := "Signpost_16"
   oItem:cBmpBig        := "Signpost_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Clientes'
   oItem:cMessage       := 'Acceso a las rutas de clientes'
   oItem:bAction        := {|| Client( "01032", oWnd ) }
   oItem:cId            := "01032"
   oItem:cBmp           := "User1_16"
   oItem:cBmpBig        := "User1_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Agentes'
   oItem:cMessage       := 'Acceso a los agentes'
   oItem:bAction        := {|| Agentes( "01033", oWnd ) }
   oItem:cId            := "01033"
   oItem:cBmp           := "Security_Agent_16"
   oItem:cBmpBig        := "Security_Agent_32"
   oItem:lShow          := .f.

   if IsProfesional()

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Programa de fidelización'
   oItem:cMessage       := 'Acceso al programa de fidelización'
   oItem:bAction        := {|| StartTFideliza() }
   oItem:cId            := "04006"
   oItem:cBmp           := "Cli"
   oItem:cBmpBig        := "Id_Card_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupo de plantillas'
   oItem:cMessage       := 'Acceso a grupos de plantillas automáticas'
   oItem:bAction        := {|| TGrpFacturasAutomaticas():New( cPatCli(), oWnd, "04018" ):Activate() }
   oItem:cId            := "04018"
   oItem:cBmp           := "folder_gear_16"
   oItem:cBmpBig        := "folder_gear_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Plantillas automáticas'
   oItem:cMessage       := 'Acceso a plantillas de ventas automáticas'
   oItem:bAction        := {|| StartTFacAutomatica() }
   oItem:cId            := "04017"
   oItem:cBmp           := "document_gear_16"
   oItem:cBmpBig        := "document_gear_32" 
   oItem:lShow          := .f.

   end if

   // Ventas-------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 8
   oGrupo:cPrompt       := 'Ventas'
   oGrupo:cLittleBitmap := "Document_user1_16"
   oGrupo:cBigBitmap    := "Document_user1_32"

   if IsStandard()

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'S.A.T.'
   oItem:cMessage       := 'Acceso al S.A.T. de clientes'
   oItem:bAction        := {|| SatCli( "01098", oWnd ) }
   oItem:cId            := "01098"
   oItem:cBmp           := "Power-drill_user1_16"
   oItem:cBmpBig        := "Power-drill_user1_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Presupuesto'
   oItem:cMessage       := 'Acceso a los presupuestos de clientes'
   oItem:bAction        := {|| PreCli( "01055", oWnd ) }
   oItem:cId            := "01055"
   oItem:cBmp           := "Notebook_user1_16"
   oItem:cBmpBig        := "Notebook_user1_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pedidos'
   oItem:cMessage       := 'Acceso a los pedidos de clientes'
   oItem:bAction        := {|| PedCli( "01056", oWnd ) }
   oItem:cId            := "01056"
   oItem:cBmp           := "Clipboard_empty_user1_16"
   oItem:cBmpBig        := "Clipboard_empty_user1_32"
   oItem:lShow          := .f.

   end if

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Albaranes'
   oItem:cMessage       := 'Acceso a los albaranes de clientes'
   oItem:bAction        := {|| AlbCli( "01057", oWnd ) }
   oItem:cId            := "01057"
   oItem:cBmp           := "Document_plain_user1_16"
   oItem:cBmpBig        := "Document_plain_user1_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas'
   oItem:cMessage       := 'Acceso a las facturas de clientes'
   oItem:bAction        := {|| FactCli( "01058", oWnd ) }
   oItem:cId            := "01058"
   oItem:cBmp           := "Document_user1_16"
   oItem:cBmpBig        := "Document_user1_32"
   oItem:lShow          := .t.

   if IsStandard()

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas anticipos'
   oItem:cMessage       := 'Acceso a las facturas de anticipos de clientes'
   oItem:bAction        := {|| FacAntCli( "01181", oWnd ) }
   oItem:cId            := "01181"
   oItem:cBmp           := "Document_money2_16"
   oItem:cBmpBig        := "Document_money2_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas rectificativas'
   oItem:cMessage       := 'Acceso a las facturas rectificativas de clientes'
   oItem:bAction        := {|| FacRec( "01182", oWnd ) }
   oItem:cId            := "01182"
   oItem:cBmp           := "Document_Delete_16"
   oItem:cBmpBig        := "Document_Delete_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ordenes de carga'
   oItem:cMessage       := 'Acceso a las ordenes de carga'
   oItem:bAction        := {|| TOrdCarga():New( cPatEmp(), "01062", oWnd ):Activate() }
   oItem:cId            := "01062"
   oItem:cBmp           := "Truck_blue_document_16"
   oItem:cBmpBig        := "Truck_blue_document_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:cPrompt       := 'Cobros'
   oGrupo:cLittleBitmap := "Briefcase_user1_16"
   oGrupo:cBigBitmap    := "Briefcase_user1_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Recibos'
   oItem:cMessage       := 'Acceso a los recibos de clientes'
   oItem:bAction        := {|| RecCli( "01059", oWnd ) }
   oItem:cId            := "01059"
   oItem:cBmp           := "Briefcase_user1_16"
   oItem:cBmpBig        := "Briefcase_user1_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Remesas bancarias'
   oItem:cMessage       := 'Acceso a las remesas bancarias'
   oItem:bAction        := {|| TRemesas():New( cPatEmp(), "01060", oWnd ):Activate() }
   oItem:cId            := "01060"
   oItem:cBmp           := "Briefcase_document_16"
   oItem:cBmpBig        := "Briefcase_document_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Liquidación de agentes'
   oItem:cMessage       := 'Acceso a las liquidaciones de agentes'
   oItem:bAction        := {|| StartTCobAge() }
   oItem:cId            := "01061"
   oItem:cBmp           := "Briefcase_security_agent_16"
   oItem:cBmpBig        := "Briefcase_security_agent_32"
   oItem:lShow          := .t.

   end if

   if IsOsCommerce()

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Comercio electrónico'
   oGrupo:cLittleBitmap := "ComercioElectronico_16"
   oGrupo:cBigBitmap    := "ComercioElectronico_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Comercio electrónico'
   oItem:cMessage       := 'Comercio electrónico'
   oItem:bAction        := {|| TComercio():New( "01108", oWnd ):dialogActivate() }
   oItem:cId            := "01108"
   oItem:cBmp           := "ComercioElectronico_16"
   oItem:cBmpBig        := "ComercioElectronico_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Pedidos electrónicos'
   oItem:cMessage       := 'Pedidos de clientes recibidos de comercio electrónico'
   oItem:bAction        := {|| PedCli( "01056", oWnd, , , , .t. ) }
   oItem:cId            := "01109"
   oItem:cBmp           := "Clipboard_Empty_Earth_16"
   oItem:cBmpBig        := "Clipboard_Empty_Earth_32"
   oItem:lShow          := .f.

   end if

   // TPV----------------------------------------------------------------------

   oItemTpv             := oAcceso:Add()
   oItemTpv:cPrompt     := 'T.P.V.'
   oItemTpv:cBmp        := "Folder16"
   oItemTpv:cBmpBig     := "Folder_32"
   oItemTpv:lShow       := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := 'T.P.V.'
   oGrupo:cLittleBitmap := "Cashier_user1_16"
   oGrupo:cBigBitmap    := "Cashier_user1_32"

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'T.P.V.'
   oItem:cMessage       := 'Acceso a terminal punto de venta'
   oItem:bAction        := {|| FrontTpv( "01063", oWnd ) }
   oItem:cId            := "01063"
   oItem:cBmp           := "Cashier_user1_16"
   oItem:cBmpBig        := "Cashier_user1_32"
   oItem:lShow          := .t.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'T.P.V. táctil'
   oItem:cMessage       := 'Acceso a terminal punto de venta táctil'
   oItem:bAction        := {|| TpvTactil():New():Activate() } // TactilTpv( "01064", oWnd ) }  // {|| TpvTactil():New( oWnd, "01116" ):Activate() } //
   oItem:cId            := "01064"
   oItem:cBmp           := "Cashier_hand_point_16"
   oItem:cBmpBig        := "Cashier_hand_point_32"
   oItem:lShow          := .f.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Entradas y salidas'
   oItem:cMessage       := 'Acceso a las entradas y salidas de caja'
   oItem:bAction        := {|| EntSal( "01065", oWnd ) }
   oItem:cId            := "01065"
   oItem:cBmp           := "Cashier_replace_16"
   oItem:cBmpBig        := "Cashier_replace_32"
   oItem:lShow          := .f.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Sala de ventas'
   oItem:cMessage       := 'Sala de ventas'
   oItem:bAction        := {|| TTpvRestaurante():New( cPatEmp(), cDriver(), oWnd, "01105" ):Activate() }
   oItem:cId            := "01105"
   oItem:cBmp           := "Cup_16"
   oItem:cBmpBig        := "Cup_32"
   oItem:lShow          := .f.

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Invitaciones'
   oItem:cMessage       := 'Acceso a los tipos de invitaciones'
   oItem:bAction        := {|| TInvitacion():New( cPatGrp(), oWnd, "01107" ):Activate() }
   oItem:cId            := "01107"
   oItem:cBmp           := "Masks_16"
   oItem:cBmpBig        := "Masks_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ordenes de comanda'
   oItem:cMessage       := 'Acceso a los comentarios de los artículos'
   oItem:bAction        := {|| TOrdenComanda():New( cPatArt(), oWnd, "01093" ):Activate() }
   oItem:cId            := "01093"
   oItem:cBmp           := "Sort_az_descending_alpha_16"
   oItem:cBmpBig        := "Sort_az_descending_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Menús'
   oItem:cMessage       := 'Acceso a los menús'
   oItem:bAction        := {|| TpvMenu():New( cPatEmp(), oWnd ):Activate() }
   oItem:cId            := "01200"
   oItem:cBmp           := "Clipboard_empty_16"
   oItem:cBmpBig        := "Clipboard_empty_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Útiles'
   oGrupo:cLittleBitmap := "Window_edit_16"
   oGrupo:cBigBitmap    := "Window_edit_32"

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Capturas T.P.V.'
   oItem:cMessage       := 'Capturas T.P.V.'
   oItem:bAction        := {|| TCaptura():New( cPatDat(), oWnd, "01083" ):Activate() }
   oItem:cId            := "01083"
   oItem:cBmp           := "Window_edit_16"
   oItem:cBmpBig        := "Window_edit_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Balanzas'
   oItem:cMessage       := 'Balanzas'
   oItem:bAction        := {|| ConfImpTiket( "01090", oWnd ) }
   oItem:cId            := "01090"
   oItem:cBmp           := "Gauge_16"
   oItem:cBmpBig        := "Gauge_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Configurar visor'
   oItem:cMessage       := 'Configurar visor'
   oItem:bAction        := {|| ConfVisor( "01092", oWnd ) }
   oItem:cId            := "01092"
   oItem:cBmp           := "Console_network_16"
   oItem:cBmpBig        := "Console_network_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cajón portamonedas'
   oItem:cMessage       := 'Cajón portamonedas'
   oItem:bAction        := {|| ConfCajPorta( "01091", oWnd ) }
   oItem:cId            := "01091"
   oItem:cBmp           := "Harddisk_16"
   oItem:cBmpBig        := "Harddisk_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Herramientas-------------------------------------------------------------

   oItemHerramientas          := oAcceso:Add()
   oItemHerramientas:cPrompt  := 'HERRAMIENTAS'
   oItemHerramientas:cBmp     := "Folder16"
   oItemHerramientas:cBmpBig  := "Folder_32"
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
   oGrupo:cLittleBitmap := "Recycle_16"
   oGrupo:cBigBitmap    := "Recycle_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Usuarios y grupos'
   oItem:cMessage       := 'Acceso a los usuarios del programa'
   oItem:bAction        := {|| Usuarios( "01074", oWnd ) }
   oItem:cId            := "01074"
   oItem:cBmp           := "Businessmen_16"
   oItem:cBmpBig        := "Businessmen_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Documentos y etiquetas'
   oItem:cMessage       := 'Configurar documentos y etiquetas'
   oItem:bAction        := {|| CfgDocs( "01068", oWnd ) }
   oItem:cId            := "01068"
   oItem:cBmp           := "Document_edit_16"
   oItem:cBmpBig        := "Document_edit_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Especificar impresora'
   oItem:cMessage       := 'Especificar impresora por defecto'
   oItem:bAction        := {|| PrinterSetup() }
   oItem:cId            := "01082"
   oItem:cBmp           := "Printer_preferences_16"
   oItem:cBmpBig        := "Printer_preferences_32"
   oItem:lShow          := .f.

   if IsProfesional()

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Centro de contabilización'
   oItem:cMessage       := 'Centro de contabilización'
   oItem:bAction        := {|| TTurno():Build( cPatEmp(), cDriver(), oWnd, "01086" ) }
   oItem:cId            := "01086"
   oItem:cBmp           := "BmpConta16"
   oItem:cBmpBig        := "BmpConta32"
   oItem:lShow          := .f.

   end if

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Útiles'
   oGrupo:cLittleBitmap := "Note_16"
   oGrupo:cBigBitmap    := "Note_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cambiar códigos'
   oItem:cMessage       := 'Cambiar códigos'
   oItem:bAction        := {|| TChgCode():New( "01073", oWnd ):Resource() }
   oItem:cId            := "01073"
   oItem:cBmp           := "Replace_16"
   oItem:cBmpBig        := "Replace_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Campos extra'
   oItem:cMessage       := 'Acceso a los campos extra'
   oItem:bAction        := {|| CamposExtra( "01127", oWnd ) }
   oItem:cId            := "01127"
   oItem:cBmp           := "form_green_add_16"
   oItem:cBmpBig        := "form_green_add_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Agenda/ CRM'
   oItem:cMessage       := 'Acceso a la agenda del usuario'
   oItem:bAction        := {|| TNotas():New( cPatDat(), , oWnd, "01075" ):Activate() }
   oItem:cId            := "01075"
   oItem:cBmp           := "Note_16"
   oItem:cBmpBig        := "Note_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Listín telefónico'
   oItem:cMessage       := 'Acceso al listín telefónico'
   oItem:bAction        := {|| TAgenda():New( cPatDat(), , oWnd, "01076" ):Activate() }
   oItem:cId            := "01076"
   oItem:cBmp           := "Telephone_16"
   oItem:cBmpBig        := "Telephone_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Scripts'
   oItem:cMessage       := 'Ejecutar scripts'
   oItem:bAction        := {|| TScripts():New( cPatEmp(), , oWnd, "01117" ):Activate() }
   oItem:cId            := "01117"
   oItem:cBmp           := "Text_code_colored_16"
   oItem:cBmpBig        := "Text_code_colored_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Archivos'
   oGrupo:cLittleBitmap := "Shield_16"
   oGrupo:cBigBitmap    := "Shield_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Regenerar índices'
   oItem:cMessage       := 'Regenerar índices'
   oItem:bAction        := {|| Reindexa() }
   oItem:cId            := "01067"
   oItem:cBmp           := "Recycle_16"
   oItem:cBmpBig        := "Recycle_32"
   oItem:lShow          := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Copia seguridad'
   oItem:cMessage       := 'Copia seguridad'
   oItem:bAction        := {|| TBackup():New( "01077", oWnd ) }
   oItem:cId            := "01077"
   oItem:cBmp           := "Shield_16"
   oItem:cBmpBig        := "Shield_32"
   oItem:lShow          := .t.

   if isProfesional()

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:nLittleItems  := 2
   oGrupo:cPrompt       := 'Exportaciones e importaciones'
   oGrupo:cLittleBitmap := "Satellite_dish_16"
   oGrupo:cBigBitmap    := "Satellite_dish_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Envío y recepción'
   oItem:cMessage       := 'Envío y recepción de información a las delegaciones'
   oItem:bAction        := {|| TSndRecInf():New( "01078", oWnd ):Activate() }
   oItem:cId            := "01078"
   oItem:cBmp           := "Satellite_dish_16"
   oItem:cBmpBig        := "Satellite_dish_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Terminales'
   oItem:cMessage       := 'Exportar e importar datos a terminales'
   oItem:bAction        := {|| TEdm():Activate( "01079", oWnd ) }
   oItem:cId            := "01079"
   oItem:cBmp           := "Pda_16"
   oItem:cBmpBig        := "Pda_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Exp. ventas'
   oItem:cMessage       := 'Exp. ventas'
   oItem:bAction        := {|| TExportaTarifas():New( "01111", oWnd ):Play() }
   oItem:cId            := "01113"
   oItem:cBmp           := "Export16"
   oItem:cBmpBig        := "Export32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Exp. compras'
   oItem:cMessage       := 'Exp. compras'
   oItem:bAction        := {|| TExportaCompras():New( "01112", oWnd ):Play() }
   oItem:cId            := "01112"
   oItem:cBmp           := "Export16"
   oItem:cBmpBig        := "Export32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Factuplus®'
   oItem:cMessage       := 'Imp. factuplus®'
   oItem:bAction        := {|| ImpFactu( "01080", oWnd ) }
   oItem:cId            := "01080"
   oItem:cBmp           := "Import16"
   oItem:cBmpBig        := "Import32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Factucont®'
   oItem:cMessage       := 'Imp. factucont®'
   oItem:bAction        := {|| ImpFacCom( "01100", oWnd ) }
   oItem:cId            := "01100"
   oItem:cBmp           := "Import16"
   oItem:cBmpBig        := "Import32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tarifas artículos'
   oItem:cMessage       := 'Importa tarifa de artículos desde Excel'
   oItem:bAction        := {|| TImpEstudio():New( "01102", oWnd ):Activate() }
   oItem:cId            := "01102"
   oItem:cBmp           := "Import16"
   oItem:cBmpBig        := "Import32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   end if

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := if( IsProfesional(), 5, 4 )
   oGrupo:nBigItems++

   oGrupo:cPrompt       := 'Extras'
   oGrupo:cLittleBitmap := "Magic_16"
   oGrupo:cBigBitmap    := "Magic_32"

   if IsProfesional()

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Sincroniza preventa'
   oItem:cMessage       := 'Sincronizamos preventa'
   oItem:bAction        := {|| SincronizaPreventa():Activate( "04016", oWnd ) }
   oItem:cId            := "04016"
   oItem:cBmp           := "pda_write_16"
   oItem:cBmpBig        := "pda_write_32"
   oItem:lShow          := .f.

   end if

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Actualizar precios'
   oItem:cMessage       := 'Actualizar precios de tarifas'
   oItem:bAction        := {|| ChgTarifa( "01081", oWnd ) }
   oItem:cId            := "01081"
   oItem:cBmp           := "Table_replace_16"
   oItem:cBmpBig        := "Table_replace_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Configurar botones'
   oItem:cMessage       := 'Configurar barra de botones'
   oItem:bAction        := {|| oWndBar:EditButtonBar( oWnd, "01085" ) }
   oItem:cId            := "01085"
   oItem:cBmp           := "Magic_16"
   oItem:cBmpBig        := "Magic_32"
   oItem:lShow          := .f.
   oItem:lHide          := .t.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Calculadora'
   oItem:cMessage       := 'Ejecuta la calculadora de windows'
   oItem:bAction        := {|| WinExec( "Calc" ) }
   oItem:cId            := "01083"
   oItem:cBmp           := "Calculator_16"
   oItem:cBmpBig        := "Calculator_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Fecha trabajo'
   oItem:cMessage       := 'Selecciona la fecha de trabajo'
   oItem:bAction        := {|| SelSysDate( "01084" ) }
   oItem:cId            := "01084"
   oItem:cBmp           := "Calendar_16"
   oItem:cBmpBig        := "Calendar_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Conversión documentos"
   oItem:cMessage       := "Conversión documentos"
   oItem:bAction        := {|| TConversionDocumentos():New():Dialog() }
   oItem:cId            := "01038"
   oItem:cBmp           := "Currency_Euro_16"
   oItem:cBmpBig        := "Currency_Euro_32"
   oItem:lShow          := .f.

   // Reporting----------------------------------------------------------------

   oItemReporting          := oAcceso:Add()
   oItemReporting:cPrompt  := 'INFORMES'
   oItemReporting:cBmp     := "Folder16"
   oItemReporting:cBmpBig  := "Folder_32"
   oItemReporting:lShow    := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Informes'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Galería de informes'
   oItem:cMessage       := 'Galería de informes'
   oItem:bAction        := {|| RunReportGalery() }
   oItem:cId            := "01119"
   oItem:cBmp           := "Document_Chart_16"
   oItem:cBmpBig        := "Document_Chart_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Informes personalizables'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Artículos'
   oItem:cMessage       := 'Informes realacionados con articulos'
   oItem:bAction        := {|| TFastVentasArticulos():New():Play() }
   oItem:cId            := "01118"
   oItem:cBmp           := "cube_yellow_chart_16"
   oItem:cBmpBig        := "cube_yellow_chart_32"
   oItem:lShow          := .f.

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Clientes'
   oItem:cMessage       := 'Informes realacionados con clientes'
   oItem:bAction        := {|| TFastVentasClientes():New():Play() }
   oItem:cId            := "01120"
   oItem:cBmp           := "user1_chart_16"
   oItem:cBmpBig        := "user1_chart_32"
   oItem:lShow          := .f.

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Proveedores'
   oItem:cMessage       := 'Informes realacionados con proveedores'
   oItem:bAction        := {|| TFastVentasProveedores():New():Play() }
   oItem:cId            := "01121"
   oItem:cBmp           := "businessman_chart_16"
   oItem:cBmpBig        := "businessman_chart_32"
   oItem:lShow          := .f.

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Producción'
   oItem:cMessage       := 'Informes realacionados con la producción'
   oItem:bAction        := {|| TFastProduccion():New():Play() }
   oItem:cId            := "01123"
   oItem:cBmp           := "Worker2_Form_Red_16"
   oItem:cBmpBig        := "Worker2_Form_Red_32"
   oItem:lShow          := .f.

   if lAIS()

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Auditor'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

   oItem                := oItemReporting:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Auditoria'
   oItem:cMessage       := 'Auditoria'
   oItem:bAction        := {|| TDataCenter():Auditor() }
   oItem:cId            := "01122"
   oItem:cBmp           := "Document_Chart_16"
   oItem:cBmpBig        := "Document_Chart_32"
   oItem:lShow          := .f.

   end if 

   // Ayudas-------------------------------------------------------------------

   oItemAyudas          := oAcceso:Add()
   oItemAyudas:cPrompt  := 'AYUDAS'
   oItemAyudas:cBmp     := "Folder16"
   oItemAyudas:cBmpBig  := "Folder_32"
   oItemAyudas:lShow    := .t.

   oGrupo               := TGrupoAcceso()

   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Ayudas'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ayuda'
   oItem:cMessage       := 'Ayuda de la aplicación'
   oItem:bAction        := {|| goWeb( __GSTHELP__ ) }
   oItem:cId            := "01093"
   oItem:cBmp           := "Lifebelt_16"
   oItem:cBmpBig        := "Lifebelt_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Visitar web'
   oItem:cMessage       := 'Visitar web'
   oItem:bAction        := {|| goWeb( __GSTWEB__ ) }
   oItem:cId            := "01094"
   oItem:cBmp           := "SndInt16"
   oItem:cBmpBig        := "SndInt32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Acerca de...'
   oItem:cMessage       := 'Datos sobre el autor'
   oItem:bAction        := {|| About() }
   oItem:cId            := "01096"
   oItem:cBmp           := "Help_16"
   oItem:cBmpBig        := "Help_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "Doctor_16"
   oItem:cBmpBig        := "Doctor_32"
   oItem:lShow          := .f.

Return ( oAcceso )

//---------------------------------------------------------------------------//

Function EnableAcceso()

Return ( nil ) // if( !Empty( oWndBar ), oWndBar:Enable(), ) )

//---------------------------------------------------------------------------//

Function DisableAcceso()

Return ( nil ) // if( !Empty( oWndBar ), oWndBar:Disable(), ) )

//---------------------------------------------------------------------------//

Function BuildMenu()

   MENU oMenu
   ENDMENU

RETURN oMenu

//---------------------------------------------------------------------------//

Function BuildPdaMenu()

   MENU oMenu

      MENUITEM       "&1. Archivos"

      MENU

         MENUITEM    "&1. Agenda";
            MESSAGE  "Acceso a la agenda del usuario" ;
            HELPID   "01075" ;
            ACTION   ( TNotas():New( cPatDat(), oWnd, oMenuItem ):Activate() );
            RESOURCE "Note_16"

      ENDMENU

      MENUITEM    "&9. Salir";
         MESSAGE  "Salir de la aplicación" ;
         ACTION   ( oWnd:End() )

   ENDMENU

RETURN oMenu

//---------------------------------------------------------------------------//

Function About()

   local oDlg
   local oTree
   local oBrush
   local oImgLst

   DEFINE BRUSH oBrush // FILE ( cBmpVersion() )

   DEFINE DIALOG oDlg RESOURCE "About" BRUSH oBrush TITLE "Acerca de " + __GSTROTOR__ + Space( 1 ) + __GSTVERSION__

      oImgLst        := TImageList():New( 24, 24 )
      oImgLst:Add( TBitmap():Define( "Angel24", ,        oDlg ) )
      oImgLst:Add( TBitmap():Define( "Security24", ,     oDlg ) )
      oImgLst:Add( TBitmap():Define( "UserHeadset24", ,  oDlg ) )
      oImgLst:Add( TBitmap():Define( "Dude224", ,        oDlg ) )

      oTree          := TTreeView():Redefine( 100, oDlg  )

      REDEFINE SAY ID 200 COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) OF oDlg

      REDEFINE BUTTON ID IDCANCEL OF oDlg ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      ON INIT     (  oTree:SetImageList( oImgLst ),;
                     oTree:Add( "Manuel Calero Solís",         0 ),;
                     oTree:Add( "Antonio Ebrero Burgos",       1 ),;
                     oTree:Add( "Dario Cruz Mauro",            3 ) ) ;
      CENTER

   oBrush:End()

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __HARBOUR__

Static Function CreateMainPdaWindow( oIconApp )

   /*
   Chequeo inicial de la aplicacion--------------------------------------------
   */

   lInitCheck()

Return nil

//---------------------------------------------------------------------------//

Static Function ExecuteMainPdaWindow( oListView, oDlg )

Return nil

//---------------------------------------------------------------------------//

Static Function InitMainTactilWindow()

   lDemoMode( .f. )

   SelCajTactil( , .t. )

   TpvTactil():New():Activate( .t. )

Return nil

//--------------------------------------------------------------------------//
// Controla los accesos al programa

FUNCTION AccesTctCode()

   local oBlock
   local oError
   local oDlg
   local oBrush
   local dbfUser
   local dbfCajas
   local oImgUsr
   local oLstUsr
   local cPath
   local cPcnUsr

   /*
   Comprobamos que exista el direcotrio USR------------------------------------
   */

   if( !lIsDir( cPatUsr() ), MakeDir( cNamePath( cPatUsr() ) ), )

   cPath          := cPatDat()
   cPcnUsr        := Rtrim( NetName() )

   // Comprobamos q exista al menos un usuario master--------------------------

   IF !File( cPath + "USERS.DBF" ) .or. ;
      !File( cPath + "MAPAS.DBF" )
		mkUsuario()
	END IF

   IF !File( cPath + "USERS.CDX" ) .or. ;
      !File( cPath + "MAPAS.CDX" )
      rxUsuario()
	END IF

   While !IsMaster()
      rxUsuario()
   End While

   // Comprobamos q exista al menos una caja-----------------------------------

   While !IsCaja()
      rxCajas()
   End While

   // Comprobamos q exista al menos una impresora de ticket--------------------

   while !IsImpTik()
      rxImpTik( cPatDat() )
   end while

   // Comprobamos q exista al menos un visor-----------------------------------

   while !IsVisor()
      rxVisor( cPatDat() )
   end while

   // Comprobamos q exista al menos un cajon portamonedas----------------------

   IsCajPorta()

   // Comprobamos q exista al menos una divisa---------------------------------

   while !IsDiv()
      rxDiv()
   end while

   //Abrimos la tabla de usuarios----------------------------------------------

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPath + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPath + "USERS.CDX" ) ADDITIVE

      USE ( cPatDat() + "CAJAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajas ) )
      SET ADSINDEX TO ( cPatDat() + "CAJAS.CDX" ) ADDITIVE

      nUsrInUse( dbfUser )

      //Cargamos la imagen de fondo de la pantalla de bienvenida------------------

      if !Os_IsWTSClient()
         DEFINE BRUSH oBrush FILE ( cBmpVersion() )
      end if

      //Montamos el diálogo con la imágen de fondo--------------------------------

      DEFINE DIALOG  oDlg ;
         RESOURCE    "WelSerTactil" ;
         TITLE       __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ + " - " + __GSTFACTORY__ ;
         BRUSH       oBrush

      /*
      Montamos la lista con los usuarios-------------------------------------
      */

         oImgUsr           := TImageList():New( 50, 50 ) //

         oLstUsr           := TListView():Redefine( 100, oDlg )
         oLstUsr:nOption   := 0
         oLstUsr:bClick    := {| nOpt | if( SelBrwBigUser( nOpt, oLstUsr, dbfUser ), oDlg:End( IDOK ), ) }

      /*
      Botones de la caja de diálogo--------------------------------------------
      */

      REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            ACTION   ( oDlg:end() )

      /*
      Al iniciar el diálogo cargamos las imágenes de los usuarios--------------
      */

      ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT     ( InitBrw( oDlg, oImgUsr, oLstUsr, dbfUser ) ) ;

      SysRefresh()

      if oDlg:nResult == IDOK
         oSetUsr( ( dbfUser )->cCodUse, dbfUser, dbfCajas, nil, .t. ):Save( dbfUser, dbfCajas )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfUser )
      ( dbfUser )->( dbCloseArea() )
   end if

   if !Empty( dbfCajas )
      ( dbfCajas )->( dbCloseArea() )
   end if

   if oBrush != nil
      oBrush:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function InitBrw( oDlg, oImgUsr, oLstUsr, dbfUsr )

   local nImg     := -1
   local nUser    := 0

   if !Empty( oImgUsr ) .and. !Empty( oLstUsr )

      oImgUsr:AddMasked( TBitmap():Define( "BIG_ADMIN" ),   Rgb( 255, 0, 255 ) )
      oImgUsr:AddMasked( TBitmap():Define( "BIG_USER" ),    Rgb( 255, 0, 255 ) )

      oLstUsr:SetImageList( oImgUsr )

      oLstUsr:EnableGroupView()

      oLstUsr:SetIconSpacing( 120, 140 )

      with object ( TListViewGroup():New() )
         :cHeader := "Administradores"
         :Create( oLstUsr )
      end with

      with object ( TListViewGroup():New() )
         :cHeader := "Usuarios"
         :Create( oLstUsr )
      end with

      ( dbfUsr )->( dbGoTop() )
      while !( dbfUsr )->( eof() )

         if !( dbfUsr )->lUseUse .and. !( dbfUsr )->lGrupo

            if !Empty( ( dbfUsr )->cImagen ) .and. File( Rtrim( ( dbfUsr )->cImagen ) )

               oImgUsr:Add( TBitmap():Define( , Rtrim( ( dbfUsr )->cImagen ) ) )

               nImg++

               with object ( TListViewItem():New() )
                  :Cargo   := ( dbfUsr )->cCodUse
                  :cText   := Capitalize( ( dbfUsr )->cNbrUse )
                  :nImage  := nImg
                  :nGroup  := if( ( dbfUsr )->nGrpUse <= 1, 1, 2 )
                  :Create( oLstUsr )
               end with

            else

               with object ( TListViewItem():New() )
                  :Cargo   := ( dbfUsr )->cCodUse
                  :cText   := Capitalize( ( dbfUsr )->cNbrUse )
                  :nImage  := if( ( dbfUsr )->nGrpUse <= 1, 0, 1 )
                  :nGroup  := if( ( dbfUsr )->nGrpUse <= 1, 1, 2 )
                  :Create( oLstUsr )
               end with

            end if

         end if


         ( dbfUsr )->( dbSkip() )

      end while

      oLstUsr:Refresh()

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//Función que chequea el usuario, la clave y nos deja pasar

Static Function SelBrwBigUser( nOpt, oLstUsr, dbfUsr )

   local oItem

   // Chequeamos que seleccione almenos un usuario-----------------------------

   if Empty( nOpt )
      MsgStop( "Seleccione usuario" )
      Return .f.
   end if

   oItem       := oLstUsr:GetItem( nOpt )

   if !Empty( oItem ) .and. dbSeekInOrd( oItem:Cargo, "cCodUse", dbfUsr )

      if !( dbfUsr )->lUseUse

         // Comprobamos la clave del usuario-----------------------------------

         if lGetPsw( dbfUsr, .t. )
            Return .t.
         end if

      else

         MsgStop( "Usuario en uso" )

         Return .f.

      end if

   else

      MsgStop( "El usuario no existe" )

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

STATIC FUNCTION lTctInitCheck( lDir, oMessage, oProgress )

   local oError
   local oBlock
   local lCheck   := .t.

   DEFAULT lDir   := .f.

   CursorWait()

   oMsgText( 'Comprobando directorios' )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lDemoMode( .f. )

      // Comprobamos que exista los directorios necesarios------------------------

      CheckDirectory()

      // Borrar los ficheros de los directorios temporales------------------------

      oMsgText( 'Borrando ficheros temporales' )

      EraseFilesInDirectory(cPatTmp(), "*.*" )

      // Cargamos los datos de la empresa-----------------------------------------

      oMsgText( 'Control de tablas de empresa' )

      TstEmpresa()

      // Chequea los cambios de las bases de datos--------------------------------

      oMsgText( 'Control de actualizaciones' )

      ChkAllEmp()

      // Apertura de ficheros-----------------------------------------------------

      SetEmpresa( , , , , , oWnd )

      // Inicializamos classes----------------------------------------------------

      oMsgText( 'Inicializamos las clases de la aplicación' )

      InitClasses()

      // Comprobamos q exista al menos un almacen---------------------------------

      oMsgText( 'Control de tablas de almacén' )

      IsAlmacen()

      // Comprobamos q exista al menos una forma de pago--------------------------

      oMsgText( 'Control de formas de pagos' )

      IsFPago()

      // Chequea q exista los contadores------------------------------------------

      oMsgText( 'Control de contadores' )

      mkCount( cPatEmp() )

      oMsgText()

      // Opciones de inicio-------------------------------------------------------

      CursorWe()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible realizar comprobaciones iniciales' )

      lCheck   := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lCheck )

//---------------------------------------------------------------------------//

Function TctCreateButtonBar()

   local oGrupo
   local oAcceso
   local oItem
   local oItemArchivo
   local oItemAyudas
   local oItemSalir

   oAcceso              := TAcceso():New()
   oAcceso:lBig         := .t.
   oAcceso:lTactil      := .t.

   oItemArchivo         := oAcceso:Add()
   oItemArchivo:cPrompt := 'Archivos'
   oItemArchivo:cBmp    := "Folder16"
   oItemArchivo:cBmpBig := "Folder_32"

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := 'Inicio'
   oGrupo:cLittleBitmap := "Home_16"
   oGrupo:cBigBitmap    := "Home_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Iniciar sesión'
   oItem:cMessage       := 'Inicia una nueva sesión de trabajo'
   oItem:bAction        := {|| if( !lCurSesion(), ChkTurno( "01000", oWnd() ), MsgStop( "Tiene una sesión en curso" ) ) }
   oItem:cBmp           := "Stopwatch_run_16"
   oItem:cBmpBig        := "Stopwatch_run_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Arqueo parcial (X)'
   oItem:cMessage       := 'arqueo parcial de la sesión de trabajo actual'
   oItem:bAction        := {|| if( lCurSesion(), CloseTurno( "01001", oWnd(), .t., .t. ), MsgStop( "No hay sesión en curso para cerrar" ) ) }
   oItem:cBmp           := "Stopwatch_Refresh_16"
   oItem:cBmpBig        := "Stopwatch_Refresh_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cerrar sesión (Z)'
   oItem:cMessage       := 'Cierra la sesión de trabajo actual'
   oItem:bAction        := {|| if( lCurSesion(), CloseTurno( "01001", oWnd(), .t. ), MsgStop( "No hay sesión en curso para cerrar" ) ) }
   oItem:cBmp           := "Stopwatch_stop_16"
   oItem:cBmpBig        := "Stopwatch_stop_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cajas"
   oItem:cMessage       := "Acceso a las cajas"
   oItem:bAction        := {|| SelCajTactil() }
   oItem:cBmp           := "Cashier_16"
   oItem:cBmpBig        := "Cashier_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Usuarios"
   oItem:cMessage       := "Acceso a los usuarios del programa"
   oItem:bAction        := {|| BrwBigUser() }
   oItem:cBmp           := "Businessmen_16"
   oItem:cBmpBig        := "Businessmen_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Clientes"
   oItem:cMessage       := "Acceso a las cuentas de clientes"
   oItem:bAction        := {|| CuentasClientes( oWnd() )  }
   oItem:cBmp           := "User1_16"
   oItem:cBmpBig        := "User1_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Entradas y salidas"
   oItem:cMessage       := "Acceso a las entradas y salidas de caja"
   oItem:bAction        := {|| AppEntSal( "01065" ) }
   oItem:cBmp           := "Cashier_replace_16"
   oItem:cBmpBig        := "Cashier_replace_32"

   // Ayudas-------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Ayudas'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ayuda'
   oItem:cMessage       := 'Ayuda de la aplicación'
   oItem:bAction        := {|| goWeb( __GSTHELP__ ) }
   oItem:cId            := "01093"
   oItem:cBmp           := "Lifebelt_16"
   oItem:cBmpBig        := "Lifebelt_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Visitar web'
   oItem:cMessage       := 'Visitar web'
   oItem:bAction        := {|| goWeb( __GSTWEB__ ) }
   oItem:cId            := "01094"
   oItem:cBmp           := "SndInt16"
   oItem:cBmpBig        := "SndInt32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Acerca de...'
   oItem:cMessage       := 'Datos sobre el autor'
   oItem:bAction        := {|| About() }
   oItem:cId            := "01096"
   oItem:cBmp           := "Help_16"
   oItem:cBmpBig        := "Help_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "Doctor_16"
   oItem:cBmpBig        := "Doctor_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Salir'
   oGrupo:cLittleBitmap := "Exit_16"
   oGrupo:cBigBitmap    := "Exit_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Salir"
   oItem:cMessage       := "Finalizar el programa"
   oItem:bAction        := {|| oWnd:End() }
   oItem:cBmp           := "Exit_16"
   oItem:cBmpBig        := "Exit_32"

Return ( oAcceso )

//---------------------------------------------------------------------------//

Function BuildTctMenu()

   MENU oMenu

      MENUITEM       "&1. Archivos"

      MENU

         MENUITEM    "&1. Iniciar sesión...";
            MESSAGE  "Inicia una nueva sesión de trabajo" ;
            ACTION   ( ChkTurno( oMenuItem, oWnd ) );
            HELPID   "01000" ;
            RESOURCE "Stopwatch_run_16" ;
            WHEN     !lCurSesion()

         MENUITEM    "&2. Arqueo parcial (X)" ;
            HELPID   "01001" ;
            MESSAGE  "Arqueo parcial de la sesión de trabajo actual";
            ACTION   ( CloseTurno( oMenuItem, oWnd, .t., .t. ) );
            RESOURCE "Stopwatch_Refresh_16" ;
            WHEN     lCurSesion()

         MENUITEM    "&3. Cerrar sesión (Z)" ;
            HELPID   "01001" ;
            MESSAGE  "Cierra la sesión de trabajo actual";
            ACTION   ( CloseTurno( oMenuItem, oWnd, .t. ) );
            RESOURCE "Stopwatch_stop_16" ;
            WHEN     lCurSesion()

         SEPARATOR

         MENUITEM    "&4. Cajas";
            HELPID   "01040" ;
            MESSAGE  "Base de datos de las cajas del establecimiento" ;
            ACTION   ( SelCajTactil() );
            RESOURCE "Cashier_16" ;

         MENUITEM    "&5. Usuarios";
            MESSAGE  "Usuarios" ;
            HELPID   "01074" ;
            ACTION   ( BrwBigUser() );
            RESOURCE "Businessmen_16"

         SEPARATOR

         MENUITEM    "&6. Clientes";
            MESSAGE  "Clientes" ;
            HELPID   "01074" ;
            ACTION   ( CuentasClientes( oWnd() ) );
            RESOURCE "User1_16"

         MENUITEM    "&7. Entradas y salidas";
            HELPID   "01065" ;
            MESSAGE  "Acceso a las entradas y salidas de caja" ;
            ACTION   ( AppEntSal( "01065" ) );
            RESOURCE "Cashier_replace_16" ;

      ENDMENU

      MENUITEM "&2. Ayudas"

      MENU

         MENUITEM    "&1. Ayuda" ;
            ACTION   ( goWeb( __GSTHELP__ ) ) ;
            MESSAGE  "Ayuda sobre el programa" ;
            RESOURCE "Lifebelt_16"

         SEPARATOR

         MENUITEM    "&2. Visitar web";
            MESSAGE  "Visitar web" ;
            ACTION   ( goWeb( __GSTWEB__ ) ) ;
            RESOURCE "SndInt16"

         MENUITEM    "&3. Acerca de...";
            MESSAGE  "Datos sobre el autor" ;
            ACTION   ( About() ) ;
            RESOURCE "Help_16"

      ENDMENU

      MENUITEM    "&3. Salir";
         MESSAGE  "Salir de la aplicación" ;
         ACTION   ( oWnd:End() )

   ENDMENU

RETURN oMenu

//--------------------------------------------------------------------------//

STATIC FUNCTION lTactilInitCheck()

   local oError
   local oBlock
   local lCheck   := .t.

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lDemoMode( .f. )

      oMsgText( 'Comprobando directorios' )

      CheckDirectory()

      // Cargamos los datos de la empresa-----------------------------------------

      oMsgText( 'Control de tablas de empresa' )

      TstEmpresa()

      // Chequea los cambios de las bases de datos--------------------------------

      oMsgText( 'Control de actualizaciones' )

      ChkAllEmp()

      // Apertura de ficheros-----------------------------------------------------

      SetEmpresa( , , , , , oWnd )

      // Inicializamos classes----------------------------------------------------

      oMsgText( 'Inicializamos las clases de la aplicación' )

      InitClasses()

      // Comprobamos q exista al menos un almacen---------------------------------

      oMsgText( 'Control de tablas de almacén' )

      IsAlmacen()

      // Comprobamos q exista al menos una forma de pago--------------------------

      oMsgText( 'Control de formas de pagos' )

      IsFPago()

      // Chequea q exista los contadores------------------------------------------

      oMsgText( 'Control de contadores' )

      mkCount( cPatEmp() )

      oMsgText()

      // Opciones de inicio-------------------------------------------------------

      CursorWe()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible realizar comprobaciones iniciales' )
      lCheck   := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lCheck )

//---------------------------------------------------------------------------//

Function TPVCreateButtonBar()

   local oGrupo
   local oAcceso
   local oItem
   local oItemArchivo

   oAcceso              := TAcceso():New()
   oAcceso:lBig         := .t.
   oAcceso:lTactil      := .t.

   oItemArchivo         := oAcceso:Add()
   oItemArchivo:cPrompt := 'Archivos'
   oItemArchivo:cBmpBig := "Folder_32"

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 6
   oGrupo:cPrompt       := 'Inicio'
   oGrupo:cLittleBitmap := "Home_16"
   oGrupo:cBigBitmap    := "Home_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Iniciar sesión'
   oItem:cMessage       := 'Inicia una nueva sesión de trabajo'
   oItem:bAction        := {|| if( !lCurSesion(), ChkTurno( "01000", oWnd() ), MsgStop( "Tiene una sesión en curso" ) ) }
   oItem:cBmpBig        := "Stopwatch_run_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Arqueo parcial (X)'
   oItem:cMessage       := 'Arqueo parcial de la sesión de trabajo actual'
   oItem:bAction        := {|| if( lCurSesion(), CloseTurno( "01001", oWnd(), .f., .t. ), MsgStop( "No hay sesión en curso para cerrar" ) ) }
   oItem:cBmpBig        := "Stopwatch_Refresh_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cerrar sesión (Z)'
   oItem:cMessage       := 'Cierra la sesión de trabajo actual'
   oItem:bAction        := {|| if( lCurSesion(), CloseTurno( "01001", oWnd(), .f. ), MsgStop( "No hay sesión en curso para cerrar" ) ) }
   oItem:cBmpBig        := "Stopwatch_stop_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cajas"
   oItem:cMessage       := "Acceso a las cajas"
   oItem:bAction        := {|| SelCajTactil() }
   oItem:cBmpBig        := "Cashier_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Usuarios"
   oItem:cMessage       := "Acceso a los usuarios del programa"
   oItem:bAction        := {|| BrwBigUser() }
   oItem:cBmpBig        := "Businessmen_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Cuentas clientes"
   oItem:cMessage       := "Acceso a las cuentas de clientes"
   oItem:bAction        := {|| CuentasClientes( oWnd() )  }
   oItem:cBmpBig        := "User1_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Entradas y salidas"
   oItem:cMessage       := "Acceso a las entradas y salidas de caja"
   oItem:bAction        := {|| AppEntSal( "01065" ) }
   oItem:cBmp           := "Cashier_replace_16"
   oItem:cBmpBig        := "Cashier_replace_32"

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
   oGrupo:cPrompt       := 'Ayudas'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ayuda'
   oItem:cMessage       := 'Ayuda de la aplicación'
   oItem:bAction        := {|| goWeb( __GSTHELP__ ) }
   oItem:cBmp           := "Lifebelt_16"
   oItem:cBmpBig        := "Lifebelt_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Visitar web'
   oItem:cMessage       := 'Visitar web'
   oItem:bAction        := {|| goWeb( __GSTWEB__ ) }
   oItem:cBmp           := "SndInt16"
   oItem:cBmpBig        := "SndInt32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Acerca de...'
   oItem:cMessage       := 'Datos sobre el autor'
   oItem:bAction        := {|| About() }
   oItem:cId            := "01096"
   oItem:cBmp           := "Help_16"
   oItem:cBmpBig        := "Help_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "Doctor_16"
   oItem:cBmpBig        := "Doctor_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Salir'
   oGrupo:cLittleBitmap := "Exit_16"
   oGrupo:cBigBitmap    := "Exit_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Salir"
   oItem:cMessage       := "Finalizar el programa"
   oItem:bAction        := {|| oWnd:End() }
   oItem:cBmp           := "Exit_16"
   oItem:cBmpBig        := "Exit_32"

Return ( oAcceso )

//--------------------------------------------------------------------------//

Function BuildTpvMenu()

   MENU oMenu

      MENUITEM       "&1. Archivos"

      MENU

         MENUITEM    "&1. Iniciar sesión...";
            MESSAGE  "Inicia una nueva sesión de trabajo" ;
            ACTION   ( ChkTurno( oMenuItem, oWnd ) );
            HELPID   "01000" ;
            RESOURCE "Stopwatch_run_16" ;
            WHEN     !lCurSesion()

         MENUITEM    "&2. Arqueo parcial (X)" ;
            HELPID   "01001" ;
            MESSAGE  "Cierra la sesión de trabajo actual";
            ACTION   ( CloseTurno( oMenuItem, oWnd, .f., .t. ) );
            RESOURCE "Stopwatch_Refresh_16" ;
            WHEN     lCurSesion()

         MENUITEM    "&3. Cerrar sesión (Z)" ;
            HELPID   "01001" ;
            MESSAGE  "Cierra la sesión de trabajo actual";
            ACTION   ( CloseTurno( oMenuItem, oWnd, .f. ) );
            RESOURCE "Stopwatch_stop_16" ;
            WHEN     lCurSesion()

         SEPARATOR

         MENUITEM    "&4. Cajas";
            HELPID   "01040" ;
            MESSAGE  "Base de datos de las cajas del establecimiento" ;
            ACTION   ( SelCajTactil() );
            RESOURCE "Cashier_16" ;

         MENUITEM    "&5. Usuarios";
            MESSAGE  "Usuarios" ;
            HELPID   "01074" ;
            ACTION   ( BrwBigUser() );
            RESOURCE "Businessmen_16"

      SEPARATOR

         MENUITEM    "&6. Cuentas clientes";
            MESSAGE  "Clientes" ;
            HELPID   "01074" ;
            ACTION   ( CuentasClientes( oWnd() ) );
            RESOURCE "User1_16"

         MENUITEM    "&7. Entradas y salidas";
            HELPID   "01065" ;
            MESSAGE  "Acceso a las entradas y salidas de caja" ;
            ACTION   ( AppEntSal( "01065" ) );
            RESOURCE "Cashier_replace_16" ;

      ENDMENU

      MENUITEM "&2. Ayudas"

      MENU

         MENUITEM    "&1. Ayuda" ;
            ACTION   ( goWeb( __GSTHELP__ ) ) ;
            MESSAGE  "Ayuda sobre el programa" ;
            RESOURCE "Lifebelt_16"

         SEPARATOR

         MENUITEM    "&2. Visitar web";
            MESSAGE  "Visitar web" ;
            ACTION   ( goWeb( __GSTWEB__ ) ) ;
            RESOURCE "SndInt16"

         MENUITEM    "&3. Acerca de...";
            MESSAGE  "Datos sobre el autor" ;
            ACTION   ( About() ) ;
            RESOURCE "Help_16"

      ENDMENU

      MENUITEM    "&3. Salir";
         MESSAGE  "Salir de la aplicación" ;
         ACTION   ( oWnd:End() )

   ENDMENU

RETURN oMenu

//--------------------------------------------------------------------------//

Function InitServices()

   // Colocamos los avisos pa las notas----------------------------------------

   if oUser():lAlerta()
      SetNotas()
   end if

   TScripts():New( cPatEmp() ):StartTimer()
   
Return ( nil )

//---------------------------------------------------------------------------//

Function StopServices()
 
   // Informe rapido de articulos----------------------------------------------

   CloseInfoArticulo()

   // Quitamos los avisos pa las notas-----------------------------------------

   if oUser():lAlerta()
      CloseNotas()
   end if

   TScripts():EndTimer()

Return ( nil )

//---------------------------------------------------------------------------//

Function oWnd() ; Return oWnd

//---------------------------------------------------------------------------//

Static Function lControlAcceso()

   if lCheckPerpetuoMode()

      lDemoMode( .f. )

      return .t.

   end if 

   /*if lCheckSaasMode()

      lDemoMode( .f. )

      return .t.

   end if*/

Return .f.

//---------------------------------------------------------------------------//

Function lDemoMode( lDemo )

   if lDemo != nil
      lDemoMode   := lDemo
   end if

Return ( lDemoMode )

//---------------------------------------------------------------------------//

Function IsReport()

Return ( .f. )

//---------------------------------------------------------------------------//
/*
Guardamos el nombre de la versión
*/

Function cNameVersion()

   if IsNil( cNameVersion )

      do case
         /*
         case File( FullCurDir() + "dccn" )

            cNameVersion      := "Oido cocina Profesional"
         */

         case File( FullCurDir() + "scmmrc" )

            cNameVersion      := "PrestaShop 1.5"

         case File( FullCurDir() + "prfsnl" )

            cNameVersion      := "Profesional"

         case File( FullCurDir() + "stndrd" )

            cNameVersion      := "Standard"

         otherwise

            cNameVersion      := "Lite"

      end case

   end if

Return ( cNameVersion )

//---------------------------------------------------------------------------//

Function cBmpVersion()

   if IsNil( cBmpVersion )

      do case
         /*case File( FullCurDir() + "dccn" )

            cBmpVersion      := FullCurDir() + "Bmp\Oidococina.bmp"*/

         case File( FullCurDir() + "scmmrc" )

            cBmpVersion      := FullCurDir() + "Bmp\GestoolPrestashop.bmp"

         case File( FullCurDir() + "prfsnl" )

            cBmpVersion      := FullCurDir() + "Bmp\GestoolPro.bmp"

         case File( FullCurDir() + "stndrd" )

            cBmpVersion      := FullCurDir() + "Bmp\GestoolStandard.bmp"

         otherwise

            cBmpVersion      := FullCurDir() + "Bmp\GestoolLite.bmp"

      end case

   end if

Return ( cBmpVersion ) 

//---------------------------------------------------------------------------//

Function cTypeVersion( cType )

   if !Empty( cType )
      cTypeVersion   := cType
   end if 

Return ( cTypeVersion )

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Oscommerce
*/

Function IsOsCommerce()

   if IsNil( lOsCommerce )

      if File( FullCurDir() + "scmmrc" )
         lOsCommerce       := .t.
      else
         lOsCommerce       := .f.
      end if

   end if

Return lOsCommerce

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Profesional
*/

Function IsProfesional()

   if IsNil( lProfesional )

      if File( FullCurDir() + "scmmrc" ) .or.;
         File( FullCurDir() + "prfsnl" )
         lProfesional     := .t.
      else
         lProfesional      := .f.
      end if

   end if

Return lProfesional

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Standard
*/

Function IsStandard()

   if IsNil( lStandard )

      if File( FullCurDir() + "scmmrc" ) .or.; 
         File( FullCurDir() + "prfsnl" ) .or.;
         File( FullCurDir() + "stndrd" )

         lStandard     := .t.

      else
         lStandard     := .f.
      end if

   end if

Return lStandard

//---------------------------------------------------------------------------//

Function lCheckPerpetuoMode( nSerialUSR )

   local n 
   local cFileIni       
   local oSerialHD
   local nSerialHD      := Abs( nSerialHD() )
   local aSerialCRC     := {}
   local nSerialCRC     := 0

   if Empty( nSerialHD )
      Return .f.
   end if

   cFileIni             := FullCurDir() + "2Ktorce.Num"  

   // Leemos las claves--------------------------------------------------------

   for n := 1 to 50

      nSerialCRC        := Val( GetPvProfString( "Main", "Access code " + Str( n, 2 ), "0", cFileIni ) )
   
      if !Empty( nSerialCRC )
   
         aAdd( aSerialCRC, nSerialCRC )
            
         if nSerialCRC == nXor( nSerialHD, SERIALNUMBER )
               
            Return .t.
   
         end if
   
      end if
   
   next

   // Parametro para registrar la aplicacion-----------------------------------

   if !Empty( nSerialUSR )

      if nSerialUSR == nXor( nSerialHD, SERIALNUMBER )

         aAdd( aSerialCRC, nSerialUSR )

         for n := 1 to len( aSerialCRC )
            WritePProString( "Main", "Access code " + Str( n, 2 ), cValToChar( aSerialCRC[ n ] ), cFileIni )
         next

         return .t.

      end if

   end if

Return .f.

//---------------------------------------------------------------------------//

#ifdef __XHARBOUR__

function lCheckSaasMode()

   local oCon
   local oQuery
   local oQuery2
   local nIdClient
   local nDaySaas          := nDaySaas()
   local lCheck            := .f.

   oCon                    := TMSConnect():New()

   if oCon:Connect( "gestool.serveftp.com", "root", "nidorino", "gestool_saas", "3306" )

      oQuery               := TMSQuery():New( oCon, "SELECT * FROM numerosserie WHERE serial='" + AllTrim( Str( Abs( nSerialHD() ) ) ) + "'" )

      if oQuery:Open() 

         // Existe el registro en la base de datos-----------------------------

         if oQuery:RecCount() > 0

            // El numero de serie no esta activo-------------------------------

            if oQuery:FieldGetByName( "activo" ) != 0

               nIdClient      := oQuery:FieldGetByName( "id_client" )

               oQuery2        := TMSQuery():New( oCon, "SELECT * FROM clientes WHERE id='" + AllTrim( Str( nIdClient ) ) + "' AND activo" )

               if oQuery2:Open() .and. oQuery2:RecCount() > 0

                  lCheck      := .t.

                  cTypeVersion( "[Saas]")

                  DeleteDaySaas()

               else 

                  // Cliente esta bloqueado------------------------------------

                  if nDaySaas > 0
                     
                     lCheck   := .t.

                     cTypeVersion( "[Saas dias: " + Alltrim( Str( nDaySaas ) ) +" ]")
                     
                     msgStop( "Le quedan " + Alltrim( Str( nDaySaas ) ) + " dias para activar su licencia", "Cliente inactivo." )

                  else 

                     cTypeVersion( "[Demo finalización licencia]" )

                     // msgStop( "Periodo de gracia expirado, el programa pasara a modo demo", "¡Atención!")

                  end if 

               end if   

            else

               // Numero de serie no esta activo ver numeros de gracia---------------


               if nDaySaas > 0
                  
                  lCheck      := .t.

                  cTypeVersion( "[Saas dias: " + Alltrim( Str( nDaySaas ) ) +" ]")
                  
                  msgStop( "Le quedan " + Alltrim( Str( nDaySaas ) ) + " dias para activar su licencia", "Licencia inactiva." )

               else 

                  cTypeVersion( "[Demo finalización licencia]" )

                  // msgStop( "Periodo de gracia expirado, el programa pasara a modo demo", "¡Atención!")

               end if 

            end if 

         end if

      end if

      oCon:Destroy()

   end if

Return ( lCheck )

#else 

function lCheckSaasMode()

return ( .f. )

#endif

//---------------------------------------------------------------------------//

Static Function SetFidelity( oBtnFidelity )

   local lFidelity            := !uFieldEmpresa( "lFidelity" )

   SetFieldEmpresa( lFidelity, "lFidelity" )

   if !Empty( oBtnFidelity )
      oBtnFidelity:lSelected  := lFidelity
      if lFidelity
         oBtnFidelity:cCaption( "Fidelity activado" )
      else
         oBtnFidelity:cCaption( "Fidelity desactivado" )
      end if
   end if

Return ( lFidelity )

//--------------------------------------------------------------------------//   

Static Function nDaySaas()

   local cRef  := "SOFTWARE\" + HB_Crypt( "Gestool", SERIALNUMBER )
   local oReg  := TReg32():Create( HKEY_LOCAL_MACHINE, cRef )
   local uVar  := oReg:Get( "Date", Date() )

   if Empty( uVar ) 
      oReg:Set( "Date", Date() )
   end if

   oReg:Close()

   if Empty( uVar )
      uVar  := Date()
   end if 
      
Return ( uVar + __DAYS__ - Date() )

//---------------------------------------------------------------------------//

Static Function DeleteDaySaas()

   local oReg
   local cRef

   cRef     := "SOFTWARE\" + HB_Crypt( "Gestool", SERIALNUMBER )
   oReg     := TReg32():Create( HKEY_LOCAL_MACHINE )
   oReg:Delete( cRef )
   oReg:Close()

Return ( nil )
 
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function MainTablet()

	local oDlg
   local nRow           
   local oGridTree
   local cAgente        := GetPvProfString( "Tablet", "Agente", "", cIniAplication() )

   nRow                 := 0
   oDlg                 := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )  

	/*
	Cabeceras------------------------------------------------------------------
   */

   TGridSay():Build(    { 	"nRow"      => nRow,;
                     		"nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                     		"bText"     => {|| "Gestool tablet" },;
                     		"oWnd"      => oDlg,;
                     		"oFont"     => oGridFontBold(),;
                     		"lPixels"   => .t.,;
                     		"nClrText"  => Rgb( 0, 0, 0 ),;
                     		"nClrBack"  => Rgb( 255, 255, 255 ),;
                     		"nWidth"    => {|| GridWidth( 5, oDlg ) },;
                     		"nHeight"   => {|| GridRow() },;
                     		"lDesign"   => .f. } )

   TGridImage():Build(  {  "nTop"      => 4,;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 138 },;
                           "nWidth"    => 138,;
                           "nHeight"   => 64,;
                           "cResName"  => "Gestool",;
                           "oWnd"      => oDlg } )

   //----------------Clientes

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "user1_64",;
                           "bLClicked" => {|| Customer():New():runNavigatorCustomer() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| Customer():New():runNavigatorCustomer() } } )

   //----------------Salir

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_End_64",;
                           "bLClicked" => {|| oDlg:End() },;
                           "oWnd"      => oDlg } )
/*
   TGridUrllink():Build({  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 10, oDlg ) },;
                           "cURL"      => "Salir",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| oDlg:End() } } )
*/
   
   //----------------Pedidos de clientes

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_clipboard_empty_user1_64",;
                           "bLClicked" => {|| OrderCustomer():New():Play() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Pedidos de clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| OrderCustomer():New():Play() } } )

   //----------------Resumen diario

   if AccessCode():lSalesView

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_about_64",;
                           "bLClicked" => {|| DailySummarySales():New():Play() },;
                           "oWnd"      => oDlg } )

   end if 

   //----------------Albaranes de clientes
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "document_plain_user1_64",;
                           "bLClicked" => {|| DeliveryNoteCustomer():New():Play() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Albaranes de clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| DeliveryNoteCustomer():New():Play() } } )

   //----------------Facturas
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 12 ) },;
                     		"nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                     		"nWidth"    => 64,;
                     		"nHeight"   => 64,;
                     		"cResName"  => "flat_document_64",;
                     		"bLClicked" => {|| InvoiceCustomer():New():play() },;     // FacCliTablet()
                     		"oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 12 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Facturas de clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| InvoiceCustomer():New():play() } } )        //FacCliTablet()

   //----------------Envio y recepcion

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_config_64",;
                           "bLClicked" => {|| TSndRecInf():New():ActivateTablet() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Envío y recepción",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| TSndRecInf():New():ActivateTablet() } } )

   //----------------Informacion empresa

   oGridTree   := TGridTreeView():Build( ;
                        {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "oWnd"      => oDlg,;
                           "lPixel"    => .t.,;
                           "nWidth"    => {|| GridWidth( 17, oDlg ) },;
                           "nHeight"   => {|| GridRow( 21, oDlg ) } } )

	// Redimensionamos y activamos el diálogo----------------------------------- 

	oDlg:bResized       := {|| GridResize( oDlg ) }
   oDlg:bStart         := {|| oGridTree:Add( "Empresa : "      + uFieldEmpresa( "CodEmp" ) + "-" + uFieldEmpresa( "cNombre" ) ),;
                              oGridTree:Add( "Usuario : "      + Rtrim( oUser():cNombre() ) ),;
                              oGridTree:Add( "Delegación : "   + Rtrim( oUser():cDelegacion() ) ),;
                              oGridTree:Add( "Caja : "         + oUser():cCaja() ),;
                              oGridTree:Add( "Almacén : "      + Rtrim( oUser():cAlmacen() ) + "-" + RetAlmacen( oUser():cAlmacen() ) ),;
                              oGridTree:Add( "Agente : "       + Rtrim( cAgente ) + "-" + AllTrim( RetNbrAge( cAgente ) ) ),;
                              oGridTree:Add( "Sesión : "       + Alltrim( Transform( cCurSesion(), "######" ) ) ) } 

	ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

Function nextRow( nRow )

   nRow := nRow + 3

Return ( by( nRow ) )

//---------------------------------------------------------------------------//

Function Test()

   local cFile    := cPatConfig() + cCodEmp() + "\prestashop.json"
   local cConfig  := memoread( cFile )
   local hConfig  
   local hWeb
   local hOutlet

   hb_jsonDecode( cConfig, @hConfig )     

   hWeb           := hGet( hConfig, "Webs" ) 
   hOutlet        := hGet( hWeb, "Outlet" )

   hSet( hOutlet, "IdProduct", "123" )

   memowrit( cFile, hb_jsonencode( hConfig, .t. ) )




/*
   local date        := date()
   local jsondecode
   local jsonencode  := hb_jsonencode( {  "texto" => "test",;
                                          "fecha" => date } )

   msgAlert( jsonencode )

   hb_jsondecode( jsonencode, @jsondecode )

   msgAlert( hb_valtoexp( jsondecode ) )
*/

Return ( nil )

  // local uGetKey  := "test teclado"

  // VirtualKey( .f., uGetKey, "Title" )

   // TComercioBudget():parseProductProperties( "Tallas",    "CINT. SRA. VAQ. PIEZAS - Tallas : 100, Color : VARIOS-900" )
   // TComercioBudget():parseProductProperties( "Color",     "CINT. SRA. VAQ. PIEZAS - Tallas : 100, Color : VARIOS-900" )

   // TScripts():CompilarEjecutarFicheroScript( FullCurDir() + "script\tpv\ImportarPricats.prg" ) 
/*
   local TPrestaShopConfig
   local TFtpCUrl

   TPrestaShopConfig          := TPrestaShopConfig():New( "2015" ) 
   TPrestaShopConfig:LoadJSON()
   TPrestaShopConfig:getWebs()

   TPrestaShopConfig:setCurrentWebName( "Temporada" )

   TFtpCUrl                   := TFtpCUrl():NewPrestashopConfig( TPrestashopConfig )
   TFtpCUrl:createConexion()
   TFtpCUrl:createFile( "c:\fw195\Gestool\bin\out\img\1-cart_default.jpg", "test4/p/1/" )
   TFtpCUrl:createFile( "c:\fw195\Gestool\bin\out\img\1-cart_default.jpg", "test4/p/2/" )
   TFtpCUrl:createFile( "c:\fw195\Gestool\bin\out\img\1-cart_default.jpg", "test4/p/3/" )
   TFtpCUrl:createFile( "c:\fw195\Gestool\bin\out\img\1-cart_default.jpg", "test4/p/4/" )
   TFtpCUrl:createFile( "c:\fw195\Gestool\bin\out\img\1-cart_default.jpg", "test4/p/5/" )
   TFtpCUrl:endConexion()
*/

/*
   LOCAL curl
   LOCAL info
   LOCAL tmp
   LOCAL tmp1
   LOCAL f
   LOCAL a
   local cFile     := "c:\img\portada.jpg"
   local cDL
   local cServer   := "ftp.lajacamoda.com"   
   local cUser     := "gestool"        
   local cPassword := "E9cV4Ehu"     
   local Url1      := "ftp://" + cUser + ":" + cPassword + "@" + cServer + "/test/p/1/" + cFile
   local Url2      := "ftp://" + cUser + ":" + cPassword + "@" + cServer + "/test/p/2/" + cFile

   LOCAL lVerbose := .F.

   ? curl_version()

   info := curl_version_info()

   debug( info )

   ? "INIT:", curl_global_init()

   IF ! Empty( curl := curl_easy_init() )

      ? "Empieza a subir 1 : ", Url1
      curl_easy_setopt( curl, HB_CURLOPT_UPLOAD )
      curl_easy_setopt( curl, HB_CURLOPT_URL, Url1 )
      curl_easy_setopt( curl, HB_CURLOPT_UL_FILE_SETUP, cFile )
      curl_easy_setopt( curl, HB_CURLOPT_INFILESIZE, hb_FSize( cFile ) )
      curl_easy_setopt( curl, HB_CURLOPT_FTP_CREATE_MISSING_DIRS, .t. )
      curl_easy_perform( curl )

      curl_easy_getinfo( curl, HB_CURLINFO_EFFECTIVE_URL )
      ? "Tiempo empleado : ", curl_easy_getinfo( curl, HB_CURLINFO_TOTAL_TIME )
      curl_easy_reset( curl )

      ? "Empieza a subir 2 : ", Url2
      curl_easy_setopt( curl, HB_CURLOPT_UPLOAD )
      curl_easy_setopt( curl, HB_CURLOPT_URL, Url2 )
      curl_easy_setopt( curl, HB_CURLOPT_UL_FILE_SETUP, cFile )
      curl_easy_setopt( curl, HB_CURLOPT_INFILESIZE, hb_FSize( cFile ) )
      curl_easy_setopt( curl, HB_CURLOPT_FTP_CREATE_MISSING_DIRS, .t. )
      curl_easy_perform( curl )

      curl_easy_getinfo( curl, HB_CURLINFO_EFFECTIVE_URL )
      ? "Tiempo empleado : ", curl_easy_getinfo( curl, HB_CURLINFO_TOTAL_TIME )
      curl_easy_reset( curl )

   ENDIF

   curl_global_cleanup()

RETURN nil

STATIC FUNCTION CurGet()
RETURN { Row(), Col() }

STATIC PROCEDURE CurSet( a )

   SetPos( a[ 1 ], a[ 2 ] )

RETURN 
*/

/* 
   LOCAL aFiles
   LOCAL cUrl
   LOCAL cStr
   LOCAL lRetVal  := .T.
   LOCAL oUrl
   LOCAL oFTP
   LOCAL cUser
   LOCAL cServer
   LOCAL cPassword
   LOCAL cFile     := ""

   cServer   := "ftp.lajacamoda.com"   
   cUser     := "gestool"        
   cPassword := "E9cV4Ehu"     
   cUrl      := "ftp://" + cUser + ":" + cPassword + "@" + cServer

   debug( cUrl, "url")

   aFiles   := Directory( "c:\img\*.*" )

   IF Len( aFiles ) > 0

      oUrl              := TUrl():New( cUrl )
      oUrl:cProto       := "ftp"
      oUrl:cServer      := cServer
      oUrl:cUserID      := cUser
      oUrl:cPassword    := cPassword
      oUrl:nPort        := 21

      oFTP              := TIPClientFTP():New( oUrl, .T. )
      oFTP:nConnTimeout := 20000
      oFTP:bUsePasv     := .f.

      // Comprobamos si el usuario contiene una @ para forzar el userid 

      IF .t.
         oFTP:oUrl:cServer   := cServer
         oFTP:oUrl:cUserID   := cUser
         oFTP:oUrl:cPassword := cPassword
      ENDIF

      IF oFTP:Open()

         FOR EACH cFile IN afiles
            debug( "Filename: " + cFile[ F_NAME ] )
            IF ! oFtp:UploadFile( cFile[ F_NAME ] )
               lRetVal := .F.
               EXIT
            ELSE
               lRetVal := .T.
            ENDIF
         NEXT

         oFTP:Close()
      ELSE
         cStr := "Could not connect to FTP server " + oURL:cServer
         IF oFTP:SocketCon == NIL
            cStr += hb_eol() + "Connection not initialized"
         ELSEIF hb_inetErrorCode( oFTP:SocketCon ) == 0
            cStr += hb_eol() + "Server response:" + " " + oFTP:cReply
         ELSE
            cStr += hb_eol() + "Error in connection:" + " " + hb_inetErrorDesc( oFTP:SocketCon )
         ENDIF
         debug( cStr )
         lRetVal := .F.
      ENDIF
   ENDIF

   RETURN lRetVal
*/

/*
   local TPrestaShopId  := TPrestaShopId():New()
   TPrestaShopId:OpenFiles()
   TPrestaShopId:setValueArticulos( "1234", "cWeb", 1234 ) 
   msgAlert( TPrestaShopId:getValueArticulos( "1234", "cWeb" ) )
   TPrestaShopId:CloseFiles()


   local n  
   local oDebtor
   local oDoc  := SepaXml():New( "c:\sepa\testSepa.xml" )

   // Documento----------------------------------------------------------------
   WITH OBJECT oDoc
     :MsgId    := id_File('REMESA001')          // Identificación del mensaje
     :NbOfTxs  := 3                             // Número de operaciones 
     :CtrlSum  := 740.70                        // Control de suma total importesCreDtTm
   ENDWITH

   // Presentador--------------------------------------------------------------
   WITH OBJECT oDoc:oInitPart
     :nEntity  := 0 // ENTIDAD_JURIDICA
     :Nm       := "NOMBRE DEL PRESENTADOR, S.L."
     :BICOrBEI := "BSABESBBXXX"
     :id       := "B12345678"
   ENDWITH

   // Acreedor-----------------------------------------------------------------
   WITH OBJECT oDoc:oCreditor
     :nEntity  := 0 // ENTIDAD_JURIDICA
     :Nm       := "NOMBRE DEL ACREEDOR, S.L."
     :BICOrBEI := "BSABESBBXXX"
     :id       := "B12345678"
   ENDWITH

   // Deudor/es----------------------------------------------------------------
   for n := 1 to 3

      oDebtor := SepaDebitActor():New()

      WITH OBJECT oDebtor
        :Nm          := "NOMBRE DEL DEUDOR "+ strzero(n, 4) 
        :nEntity     := 2  // ENTIDAD_OTRA
        :id          := "12345678Z"
        :InstdAmt    := 123.45 * n                 // Importe
        :ReqdColltnDt := ctod("02-21-2014") + (n*10)     // Fecha de cobro (Vencimiento)
        :IBAN     := "ES0321001234561234567890"
        :BICOrBEI    := "CAIXESBBXXX"
        :MndtId      := hb_md5(oDoc:oCreditor:Id + :id)  // Identificación del mandato, idea: Utilizar NIF Acreedor + NIF Deudor 
        :DtOfSgntr   := ctod("02-21-2014")            // Fecha de firma 
      ENDWITH

      oDoc:DebtorAdd( oDebtor )

   next

   oDoc:Activate()
*/

Static Function testAll()

   USE ( cPatCli() + "Client.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "Client", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "Client.Cdx" ) ADDITIVE

   USE ( cPatCli() + "Obrast.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "Obrast", @dbfObras ) )
   SET ADSINDEX TO ( cPatCli() + "Obrast.Cdx" ) ADDITIVE

   // deleteAll()

   // fillAll()

   seekAll()

   CLOSE ( dbfClient )
   CLOSE ( dbfObras )   

RETURN NIL 

//---------------------------------------------------------------------------//

STATIC FUNCTION deleteAll()

   ( dbfClient )->( __dbzap() )
   ( dbfObras  )->( __dbzap() )

RETURN NIL 

//---------------------------------------------------------------------------//

STATIC FUNCTION fillAll()

   local n
   local seconds := seconds()

   for n := 1 to 100000

      if ( n % 100 ) == 0
         msgwait( "Recno " + str(n), , 0.0001 )
      end if 

      ( dbfClient )->( dbappend() )
      if ( dbfClient )->( !neterr() )
         ( dbfClient )->cod      := strzero( n, 8 )
         ( dbfClient )->titulo   := strzero( n, 8 )
         ( dbfClient )->( dbcommit() )
         ( dbfClient )->( dbunlock() )
      endif

      ( dbfObras )->( dbappend() )
      if ( dbfObras )->( !neterr() )
         ( dbfObras )->cCodCli   := strzero( n, 8 )
         ( dbfObras )->cCodObr   := strzero( n, 8 )
         ( dbfObras )->cNomObr   := strzero( n, 8 )
         ( dbfObras )->( dbcommit() )
         ( dbfObras )->( dbunlock() )
      endif

   next

   msgStop( seconds() - seconds, "fill" )

RETURN NIL 

//---------------------------------------------------------------------------//

static Function seekAll()

   local seconds := seconds()

   ( dbfClient )->( dbGoTop() )

   while ( dbfClient )->( !eof() ) 
      retfld( ( dbfClient )->cod, dbfObras, "cCodCli" )
      retfld( ( dbfClient )->cod, dbfObras, "cCodObr" )
      retfld( ( dbfClient )->cod, dbfObras, "cNomObr" )
      ( dbfClient )->( dbskip() )
   end while

   msgStop( seconds() - seconds, "seek" )

RETURN NIL 

//---------------------------------------------------------------------------//






