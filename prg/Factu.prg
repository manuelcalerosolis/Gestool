#ifndef __PDA__ 

   #include "FiveWin.Ch"
   #include "Menu.ch"
   #include "Font.ch"
   #include "Inkey.ch"
   #include "Factu.ch"
   #include "Ads.ch"
   #include "Xbrowse.ch"

   #define GR_GDIOBJECTS     0       /* Count of GDI objects */
   #define GR_USEROBJECTS    1       /* Count of USER objects */

   #define CS_DBLCLKS        8

   ANNOUNCE RDDSYS

   REQUEST ADS, DBFCDX, DBFFPT

   REQUEST AdsKeyNo
   REQUEST AdsKeyCount
   REQUEST AdsGetRelKeyPos
   REQUEST AdsSetRelKeyPos

#else

   #include "FWCE.ch"
   #include "Vkey.Ch"

   REQUEST DBFCDX

#endif

#ifdef __SQLLIB__
   #include "sqlrdd.ch"          // Needed if you plan to use native connection to MySQL
   #include "mysql.ch"           // Needed if you plan to use native connection to MySQL
#endif

#ifndef __PDA__

static oWndBar
static oMenu

static oMsgUser
static oMsgCaja
static oMsgAlmacen
static oMsgSesion
static oMsgProgress

static oDlgProgress

static cParamsMain

static nHndReport

static hDLLRich

#else

static dbfUser
static dbfCaj
static lOpenFiles    := .f.

#endif

static oWnd
static oBmp
static lDemoMode     := .t.

static lStandard
static lProfesional
static lOsCommerce

static cNameVersion
static cBmpVersion

//---------------------------------------------------------------------------//
//Comenzamos la parte de código que se compila para el ejecutable normal

#ifndef __PDA__

function Main( cParams )

   local nError
   local cError
   local oIndex
   local oIconApp
   local cAdsType
   local cAdsIp
   local cAdsData
   local dbfUser
   local hAdsConnection

   local oDataUser
   local oDataTable

   local cSqlQuery
   local lSqlQuery

   DEFAULT cParams   := ""

   cParamsMain       := Upper( cParams )

   SET DATE FORMAT   "dd/mm/yyyy"
   SET DELETED       ON
   SET EXCLUSIVE     OFF
   SET EPOCH         TO 2000
   SET OPTIMIZE      ON
   SET EXACT         ON
   SET AUTOPEN       ON
   SET AUTORDER      TO 1

   SetHandleCount( 240 )

   // GdiPlusStartup()

   /*
   Chequeamos la existencia del fichero de configuracion-----------------------
   */

   if !File( FullCurDir() + "GstApolo.Ini" ) .and. File( FullCurDir() + "Gestion.Ini" )
      fRename( FullCurDir() + "Gestion.Ini", FullCurDir() + "GstApolo.Ini" )
   end if

   cAdsIp            := GetPvProfString( "ADS", "Ip",    "", FullCurDir() + "GstApolo.Ini" )
   cAdsType          := GetPvProfString( "ADS", "Type",  "", FullCurDir() + "GstApolo.Ini" )
   cAdsData          := GetPvProfString( "ADS", "Data",  "", FullCurDir() + "GstApolo.Ini" )

   // Motor de bases de datos--------------------------------------------------

   do case
   case ( "ADSLOCAL" $ cAdsType )

      lAds( .t. )
      cIp( cAdsIp )
      cData( cAdsData )

      RddRegister(   'ADS', 1 )
      RddSetDefault( 'ADSCDX' )

      AdsSetServerType( 1 )   // ADS_LOCAL_SERVER
      AdsSetFileType( 2 )     // ADS_CDX

      AdsRightsCheck( .f. )

   case ( "ADSREMOTE" $ cAdsType )

      lAds( .t. )
      cIp( cAdsIp )
      cData( cAdsData )

      RddRegister(   'ADS', 1 )
      RddSetDefault( 'ADSCDX' )

      AdsSetServerType( 7 )   // ADS_LOCAL_SERVER
      AdsSetFileType( 2 )     // ADS_CDX

      AdsRightsCheck( .f. )

      AdsCacheOpenTables( 250 )

      nError      := AdsIsServerLoaded( cAdsIp )
      if nError == 0
         adsGetLastError( @cError )
         msgStop( cError, "Salida de la aplicación" )
         Return .f.
      end if

   case ( "ADSINTERNET" $ cAdsType )

      lAIS( .t. )
      cIp( cAdsIp )
      cData( cAdsData )

      RddRegister(   'ADS', 1 )
      RddSetDefault( 'ADSCDX' )

      AdsSetServerType( 7 )   // TODOS
      AdsSetFileType( 2 )     // ADS_CDX

      AdsRightsCheck( .f. )

      AdsCacheOpenTables( 250 )

      with object ( TDataCenter() )

         :cDataDictionaryFile       := cAdsUNC() + "GstApolo.Add"
         :cDataDictionaryComment    := "GstApolo ADS data dictionary"

         if ( "ADMINISTRADOR" $ cParamsMain )

            :lAdministratorTask()

            Return nil

         else

            :ConnectDataDictionary()

            if !:lAdsConnection

               msgStop( "Imposible conectar con GstApolo ADS data dictionary" )

               Return nil

            else

               // :Auditor()

            end if

         end if

      end with

   otherwise

      lCdx( .t. )

      RddSetDefault( 'DBFCDX' )

   end if

   /*
   Opciones especiales de arranque hace la operacion y salir-------------------
   */

   do case
   case ( "ENVIO" $ cParamsMain )

      if ( ":" $ cParamsMain )
         cEmpUsr( Right( cParamsMain, 2 ) )
      end if

      if lInitCheck( .t. )
         TSndRecInf():New():LoadFromIni():Activate( nil, .t. ) // AutoExecute( .t. )
      end if

      return nil

   case ( "REINDEXA" $ cParamsMain )

      if ( ":" $ cParamsMain )
         cEmpUsr( Right( cParamsMain, 2 ) )
      end if

      if lInitCheck( .t. )
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

   // Iconos

   DEFINE ICON oIconApp RESOURCE "Gestool"

   // Chequeamos el directorio de datos

   if( !lIsDir( cPatDat() ),  MakeDir( cNamePath( cPatDat() ) ), )

   // Obtenemos la versión del programa

   IsStandard()
   IsProfesional()
   IsOsCommerce()

   cNameVersion()

   // Chequeamos los datos de los usuarios

   if !TReindex():lFreeHandle()
      msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicación" + CRLF + ;
               "en estos momentos, reintentelo pasados unos segundos." )
      return .f.
   end if

   XbrNumFormat( "E", .t. )

   do case
      case ( "TCT" $ cParamsMain )
         if AccessCode():TactilResource()
            CreateMainTctWindow( oIconApp )
         end if

      case ( "TACTIL" $ cParamsMain )
         if AccessCode():TactilResource()
            InitMainTactilWindow( oIconApp )
         end if

      case ( "TPV" $ cParamsMain )
         if AccesTctCode()
            CreateMainTPVWindow( oIconApp )
         end if

      case ( "PDA" $ cParamsMain )
         if AccessCode():Resource()
            CreateMainPdaWindow( oIconApp )
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

   // GdiplusShutdown()

Return Nil

//----------------------------------------------------------------------------//

Function HelpTopic()

   msgAlert( "Help wanted!" )

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

   oDlgProgress               := TMsgItem():New( oWnd:oMsgBar, "", 100,,,, .t. )

   oWnd:oMsgBar:oDate         := TMsgItem():New( oWnd:oMsgBar, Dtoc( GetSysDate() ), oWnd:oMsgBar:GetWidth( DToC( GetSysDate() ) ) + 12,,,, .t., { || SelSysDate() } )
   oWnd:oMsgBar:oDate:lTimer  := .t.
   oWnd:oMsgBar:oDate:bMsg    := { || GetSysDate() }
   oWnd:oMsgBar:CheckTimer()

   oMsgUser                   := TMsgItem():New( oWnd:oMsgBar, "Usuario : "   + Rtrim( oUser():cNombre() ), 200,,,, .t. )

   oMsgCaja                   := TMsgItem():New( oWnd:oMsgBar, "Caja : "      + oUser():cCaja(), 100,,,, .t., {|| SelectCajas() } )

   oMsgAlmacen                := TMsgItem():New( oWnd:oMsgBar, "Almacén : "   + oUser():cAlmacen(), 100,,,, .t., {|| SelectAlmacen() } )

   oMsgSesion                 := TMsgItem():New( oWnd:oMsgBar, "Sesión : "    + Transform( cCurSesion(), "######" ), 100,,,, .t. )

   // Abrimos la ventana

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT    ( WndPaint( hDC, oWnd, oBmp ) );
      ON INIT     ( lStartCheck() );
      ON RESIZE   ( WndResize( oWnd ) );
      VALID       ( EndApp() )

Return nil

//---------------------------------------------------------------------------//

Static Function StdKey( nKey )

   do case
      case nKey == 65 .and. GetKeyState( VK_CONTROL ) // Crtl + A
         CreateInfoArticulo()
      case nKey == 38 .and. GetKeyState( VK_CONTROL ) // Ctrl + Down
         NextEmpresa()
      case nKey == 40 .and. GetKeyState( VK_CONTROL ) // Ctrl + Up
         PriorEmpresa()
      case nKey == 48 .and. GetKeyState( VK_CONTROL ) // Ctrl + 0
         dbDialog()
   end case

Return Nil

//---------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//Procesos de comprobaciones iniciales y lectura de archivos .INI, cuando existan

FUNCTION CtrlApp()

   local n
   local oDlg
   local oBmp
   local oBrush
   local oSerialHD
   local aSerialCRC  := {}
   local nSerialCRC  := 0
   local nSerialUSR  := 0
   local nSerialHD   := Abs( nSerialHD() )
   local cFileIni    := FullCurDir() + "2K10.Num"

   if Empty( nSerialHD )
      lDemoMode( .f. )
      Return .t.
   end if

   for n := 1 to 50

      nSerialCRC     := Val( GetPvProfString( "Main", "Access code " + Str( n, 2 ), "0", cFileIni ) )

      if !Empty( nSerialCRC )

         aAdd( aSerialCRC, nSerialCRC )
         if nSerialCRC == nXor( nSerialHD, SERIALNUMBER )
            lDemoMode( .f. )
            return .t.
         end if

      end if

   next

   DEFINE BRUSH oBrush COLOR Rgb( 255, 255, 255 )

   DEFINE DIALOG oDlg RESOURCE "GETSERIALNO" TITLE "Sistema de protección : " + Str( nSerialHD ) BRUSH oBrush

   REDEFINE BITMAP oBmp ;
      RESOURCE "Lock_48" ;
      ID       600;
      OF       oDlg

   REDEFINE SAY oSerialHD ;
      PROMPT   nSerialHD ;
      COLOR    Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET nSerialUSR ;
      ID       110 ;
      COLOR    Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ;
      PICTURE  "99999999999999" ;
      OF       oDlg

   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 120 OF oDlg
   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 130 OF oDlg
   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 140 OF oDlg
   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 150 OF oDlg

   REDEFINE SAY PROMPT "2.- Marque el teléfono siguiente " + __GSTTELEFONO__ COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 160 OF oDlg

   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 170 OF oDlg
   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 180 OF oDlg
   REDEFINE SAY COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ID 190 OF oDlg

   with object ( TWebBtn():Redefine( 200,,,,,  {|| goWeb( __GSTWEB__ ) }, oDlg,,,,, "LEFT",,,,, Rgb( 0, 0, 255 ), Rgb( 0, 0, 255 ),,,, "Ir a la página web de " + __GSTFACTORY__ ) )
      :SetTransparent()
      :SetText( __GSTFACTORY__ )
   end with

   REDEFINE BUTTON ;
      ID       552 ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:End(), PostQuitMessage() )

   ACTIVATE DIALOG oDlg CENTER

   oBmp:end()
   oBrush:end()

   if oDlg:nResult == IDOK

      if nXor( nSerialHD, SERIALNUMBER ) == nSerialUSR

         aAdd( aSerialCRC, nSerialUSR )

         for n := 1 to len( aSerialCRC )
            WritePProString( "Main", "Access code " + Str( n, 2 ), cValToChar( aSerialCRC[ n ] ), cFileIni )
         next

         lDemoMode( .f. )

         MsgInfo( "Programa registrado con éxito" )

         return .t.

      else

         MsgStop( "Número invalido" )

         PostQuitMessage()

      end if

   end if

return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EndApp()

   local oAni
   local oDlg
   local oError
   local oBlock
   local oBrush
   local oBtnOk
   local oBtnZip
   local oBtnCancel

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      SysRefresh()

      if !Empty( oWnd )
         oWnd:CloseAll()
      end if

      SysRefresh()

      if !( Os_IsWTSClient() )
         DEFINE BRUSH oBrush FILE ( cBmpVersion() )
      end if

      DEFINE DIALOG oDlg RESOURCE "EndApp" BRUSH oBrush

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

      if oBrush != nil
         oBrush:End()
      end if

      if oDlg:nResult == IDOK

         WritePProString( "main", "Ultima Empresa", cCodEmp(), FullCurDir() + "GstApolo.Ini" )

         lFreeUser()

         // Cerramos las auditorias-----------------------------------------------

         StopServices()

         // Cerramos el report----------------------------------------------------

         if !Empty( nHndReport )
            PostMessage( nHndReport, WM_CLOSE )
         end if

         // Cerramos el Activex---------------------------------------------------

         CloseWebBrowser( oWnd )

      end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
// Remember to use 'exit' procedures to asure that resources are
// freed on a possible application error

exit procedure Finish()

   FreeResources()

   FreeLibrary( hDLLRich )

Return

//-----------------------------------------------------------------------------//

Function WndResize( oWnd )

   if !Empty( oWnd )

      aEval( oWnd:oWndClient:aWnd, {|o| oWnd:oWndClient:ChildMaximize( o ) } )

      if !Empty( oWndBar )
         oWndBar:CreateLogo()
      end if

   end if

Return nil

//-----------------------------------------------------------------------------//
// Comprobaciones iniciales

FUNCTION lInitCheck( lDir, oMessage, oProgress )

   local oError
   local lCheck      := .t.

   DEFAULT lDir      := .f.

   CursorWait()

   if !Empty( oProgress )
      oProgress:SetTotal( 6 )
   end if

   if !Empty( oMessage )
      oMessage:SetText( 'Comprobando directorios' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   // Comprobamos que exista los directorios necesarios------------------------

   if( !lIsDir( cPatDat() ),     MakeDir( cNamePath( cPatDat() ) ), )
   if( !lIsDir( cPatADS() ),     MakeDir( cNamePath( cPatADS() ) ), )
   if( !lIsDir( cPatIn()  ),     MakeDir( cNamePath( cPatIn()  ) ), )
   if( !lIsDir( cPatTmp() ),     MakeDir( cNamePath( cPatTmp() ) ), )
   if( !lIsDir( cPatOut() ),     MakeDir( cNamePath( cPatOut() ) ), )
   if( !lIsDir( cPatSnd() ),     MakeDir( cNamePath( cPatSnd() ) ), )
   if( !lIsDir( cPatLog() ),     MakeDir( cNamePath( cPatLog() ) ), )
   if( !lIsDir( cPatBmp() ),     MakeDir( cNamePath( cPatBmp() ) ), )
   if( !lIsDir( cPatHtm() ),     MakeDir( cNamePath( cPatHtm() ) ), )
   if( !lIsDir( cPatXml() ),     MakeDir( cNamePath( cPatXml() ) ), )
   if( !lIsDir( cPatSafe()),     MakeDir( cNamePath( cPatSafe()) ), )
   if( !lIsDir( cPatPsion()),    MakeDir( cNamePath( cPatPsion())), )
   if( !lIsDir( cPatEmpTmp() ),  MakeDir( cNamePath( cPatEmpTmp() ) ), )
   if( !lIsDir( cPatScript() ),  MakeDir( cNamePath( cPatScript() ) ), )

   // Elimina los temporales de la aplicación----------------------------------

   lRdDir( cPatTmp(), "*.*" )
   lRdDir( cPatLog(), "*.*" )

   // Cargamos los datos de la empresa-----------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Control de tablas de empresa' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   TstEmpresa()

   // Cargamos los datos de la divisa------------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Control de tablas de divisas' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   TstDivisas()

   // Cargamos los datos de la cajas-------------------------------------------

   if !Empty( oMessage )
      oMessage:SetText( 'Control de tablas de cajas' )
   end if

   if !Empty( oProgress )
      oProgress:AutoInc()
   end if

   TstCajas()

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

   if !Empty( oMessage )
      oMessage:SetText( 'Iniciando los servicios' )
   end if

   InitServices()

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

   ChkAllEmp()

   // Ponemos el titulo de la empresa------------------------------------------

   SetTituloEmpresa()

   // Controla de acceso a la aplicación---------------------------------------

   oMsgText( 'Control de acceso a la aplicación' )

   CtrlApp()

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

   TCreaFacAutomaticas():Create()

   // Aviso de pedidos pendientes de procesar----------------------------------

   oMsgText( 'Pedidos por la web' )

   lPedidosWeb()

   // Compilamos y ejecutamos un prg en tiempo de ejecución--------------------

   //Ejecutascript()

   // Colocamos los avisos pa las notas----------------------------------------

   oMsgText( 'Emision de alertas' )

   if oUser():lAlerta()
      SetNotas()
   end if

   // Navegación------------------------------------------------------------

   oMsgText( 'Abriendo panel de navegación' )

   if !Empty( oWnd ) .and. !( Os_IsWTSClient() )
       OpenWebBrowser( oWnd )
   end if

   oMsgText()

   CursorWe()

Return ( .t. )

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

   dFecha         := cToD( GetPvProfString( "SCRIPT", "Fecha",    "", FullCurDir() + "GstApolo.Ini" ) )

   if dFecha  < GetSysDate()

      aScripts    := Directory( cPatScript() + "*.hrb" )

      if Len( aScripts ) > 0

         for each cScript in aScripts

            /*
            Ejecutamos el script-----------------------------------------------
            */

            pHrb := __hrbLoad( cPatScript() + cScript[1] )
            u := __hrbDo( pHrb )
            __hrbUnload( pHrb )

         next

      end if

   end if

   /*
   Anotamos la fecha del último envio de script--------------------------------
   */

   WritePProString( "SCRIPT", "Fecha", Dtoc( GetSysDate() ), FullCurDir() + "GstApolo.Ini" )

Return u

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg directamente
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

Function DirectEjecutaScript()

   local aScripts
   local cScript  := ""
   Local pHrb
   Local u

   /*
   Cerramos todas las ventanas antes de entrar---------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Comprobaciones iniciales antes de mandar el script--------------------------
   */

   aScripts    := Directory( cPatScript() + "*.hrb" )

   if Len( aScripts ) > 0

      for each cScript in aScripts

         /*
         Ejecutamos el script--------------------------------------------------
         */

         pHrb := __hrbLoad( cPatScript() + cScript[1] )
         u := __hrbDo( pHrb )
         __hrbUnload( pHrb )

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
   TBandera()
   TCatalogo()
   TGrpCli()
   TInfoArticulo()
   TSndRecInf()
   TNotas()
   TOrdCarga()
   TPais()
   TReindex()
   TRemesas()
   TRemMovAlm()
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
   THisMovSenderReciver()
   TTurno()
   TInvitacion()
   TXBrowse():Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

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
   local nLen  := Len( oMsgBar:aItem )
   local nPos  := oMsgBar:nRight - 3

   if nLen > 0
      for n := 1 to nLen
         nPos -= ( oMsgBar:aItem[ n ]:nWidth + 4 )
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

init procedure RddInit()

#ifdef __SQLLIB__
   REQUEST SQLRDD             // SQLRDD should be linked in
   REQUEST SR_MYSQL           // Needed if you plan to use native connection to MySQL
#endif


   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   HB_LangSelect( "ES" )      // Para mensajes, fechas, etc..
   HB_SetCodePage( "ESWIN" )  // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

   hDLLRich    := LoadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit

return

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

Function RunReportGalery()

   local nLevel   := nLevelUsr( "01066" )

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

      goWeb( __GSTWEB__ + "/Client/Client.exe" )

   end if

   /*
   if DirChange( FullCurDir() ) != 0
      MsgStop( "No puedo cambiar al directorio " + FullCurDir() )
      Return nil
   end if

   */

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
   local oItemSalir

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
   oItem:bAction        := {|| CloseTurno( "01001", oWnd(), .f., .t. ) }
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
   oItem:cBmp           := "clock_16"
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
   oItem:cPrompt        := 'Tanques'
   oItem:cMessage       := 'Acceso a los tanques de combustible'
   oItem:bAction        := {|| TTankes():New( cPatEmp(), oWnd, "01017" ):Activate() }
   oItem:cId            := "01017"
   oItem:cBmp           := "Potion_Red_16"
   oItem:cBmpBig        := "Potion_Red_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Unidades medición'
   oItem:cMessage       := 'Unidades de Medición'
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
   oItem:bAction        := {|| TTipArt():New( cPatArt(), oWnd, "01013" ):Activate() }
   oItem:cId            := "01013"
   oItem:cBmp           := "Cubes_Blue_16"
   oItem:cBmpBig        := "Cubes_Blue_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Categorías'
   oItem:cMessage       := 'Acceso al fichero de categorías'
   oItem:bAction        := {|| Categoria( "01101", oWnd() ) }
   oItem:cId            := "01101"
   oItem:cBmp           := "Colors_16"
   oItem:cBmpBig        := "Colors_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Temporadas'
   oItem:cMessage       := 'Acceso al fichero de temporadas'
   oItem:bAction        := {|| Temporada( "01114", oWnd() ) }
   oItem:cId            := "01114"
   oItem:cBmp           := "Sun_and_cloud_16"
   oItem:cBmpBig        := "Colors_32"
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
   oGrupo:nBigItems     := 2
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
   oItem:bAction        := {|| TCtaRem():New( cPatCli(), oWnd, "01044" ):Activate() }
   oItem:cId            := "01044"
   oItem:cBmp           := "Address_book2_16"
   oItem:cBmpBig        := "Address_book2_32"
   oItem:lShow          := .f.

   // Otros--------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 10
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
   oItem:cPrompt        := 'Frases publicitarias'
   oItem:cMessage       := 'Frases publicitarias'
   oItem:bAction        := {|| TFrasesPublicitarias():New( cPatArt(), oWnd, "01104" ):Activate() }
   oItem:cId            := "01104"
   oItem:cBmp           := "Led_Red_16"
   oItem:cBmpBig        := "Led_Red_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Paises"
   oItem:cMessage       := "Acceso a los paises"
   oItem:bAction        := {|| TPais():New( cPatDat(), oWnd, "01041" ):Activate() }
   oItem:cId            := "01041"
   oItem:cBmp           := "Flag_spain_16"
   oItem:cBmpBig        := "Flag_spain_32"
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
   oItem:bAction        := {|| Situaciones( "01096", oWnd ) }
   oItem:cId            := "01096"
   oItem:cBmp           := "Document_Attachment_16"
   oItem:cBmpBig        := "Document_Attachment_32"
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

   /*
   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Historico movimientos'
   oItem:cMessage       := 'Acceso a los movimientos historicos de almacén'
   oItem:bAction        := {|| HisMovAlm( "01051", oWnd ) }
   oItem:cId            := "01051"
   oItem:cBmp           := "Package_book_red_16"
   oItem:cBmpBig        := "Package_book_red_32"
   oItem:lShow          := .f.
   */

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
   oItem:bAction        := {|| TSeccion():New( cPatEmp(), oWnd, "04001" ):Activate() }
   oItem:cId            := "04001"
   oItem:cBmp           := "Group_Worker2_16"
   oItem:cBmpBig        := "Group_Worker2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Operarios'
   oItem:cMessage       := 'Acceso a los operarios'
   oItem:bAction        := {|| TOperarios():New( cPatEmp(), oWnd, "04002" ):Activate() }
   oItem:cId            := "04002"
   oItem:cBmp           := "Worker2_16"
   oItem:cBmpBig        := "Worker2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo  
   oItem:cPrompt        := 'Tipos de horas'
   oItem:cMessage       := 'Acceso a tipos de horas de producción'
   oItem:bAction        := {|| THoras():New( cPatEmp(), oWnd, "04003" ):Activate() }
   oItem:cId            := "04003"
   oItem:cBmp           := "Worker2_Clock_16"
   oItem:cBmpBig        := "Worker2_Clock_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Operaciones'
   oItem:cMessage       := 'Acceso a las operaciones'
   oItem:bAction        := {|| TOperacion():New( cPatEmp(), oWnd, "04004" ):Activate() }
   oItem:cId            := "04004"
   oItem:cBmp           := "Worker2_Hammer2_16"
   oItem:cBmpBig        := "Worker2_Hammer2_32"
   oItem:lShow          := .f.

   oItem                := oItemProduccion:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos de operaciones'
   oItem:cMessage       := 'Acceso a tipos de operaciones'
   oItem:bAction        := {|| TTipOpera():New( cPatEmp(), oWnd, "04005" ):Activate() }
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
   oItem:bAction        := {|| TCosMaq():New( cPatEmp(), oWnd, "04007" ):Activate() }
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
   oItem:bAction        := {|| StartTProduccion() }
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
   oItem:bAction        := {|| TEntidades():New( cPatEmp(), oWnd, "04012" ):Activate() }
   oItem:cId            := "04012"
   oItem:cBmp           := "School_16"
   oItem:cBmpBig        := "School_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Colaboradores'
   oItem:cMessage       := 'Acceso a la tabla de colaboradores'
   oItem:bAction        := {|| TColaboradores():New( cPatEmp(), oWnd, "04013" ):Activate() }
   oItem:cId            := "04013"
   oItem:cBmp           := "Teacher_16"
   oItem:cBmpBig        := "Teacher_32"
   oItem:lShow          := .f.

   oItem                := oItemExpediente:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Actuaciones'
   oItem:cMessage       := 'Acceso a la tabla de actuaciones'
   oItem:bAction        := {|| TActuaciones():New( cPatEmp(), oWnd, "04014" ):Activate() }
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
   oGrupo:nBigItems     := If( IsProfesional(), 6, 4 )
   oGrupo:cPrompt       := 'Clientes'
   oGrupo:cLittleBitmap := "User1_16"
   oGrupo:cBigBitmap    := "User1_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos'
   oItem:cMessage       := 'Acceso a los grupos de clientes'
   oItem:bAction        := {|| TGrpCli():New( cPatCli(), oWnd, "01030" ):Activate() }
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
   oItem:cPrompt        := 'Plantillas automáticas'
   oItem:cMessage       := 'Acceso a plantillas de ventas automáticas'
   oItem:bAction        := {|| StartTFacAutomatica() }
   oItem:cId            := "04015"
   oItem:cBmp           := "document_gear_16"
   oItem:cBmpBig        := "document_gear_32"
   oItem:lShow          := .f.

   end if

   // Ventas-------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := 'Ventas'
   oGrupo:cLittleBitmap := "Document_user1_16"
   oGrupo:cBigBitmap    := "Document_user1_32"

   if IsStandard()

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
   oItem:bAction        := {|| TComercio():New( "01108", oWnd ):Activate() }
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
   oGrupo:nBigItems     := 5
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
   oItem:bAction        := {|| TTpvRestaurante():New( cPatEmp(), oWnd, "01105" ):Activate() }
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
   oItem:bAction        := {|| ConfVisor ( "01092", oWnd ) }
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
      oGrupo:nBigItems  := 2
   otherwise
      oGrupo:nBigItems  := 1
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
   oItem:bAction        := {|| TTurno():Build( cPatEmp(), oWnd, "01086" ) }
   oItem:cId            := "01086"
   oItem:cBmp           := "BmpConta16"
   oItem:cBmpBig        := "BmpConta32"
   oItem:lShow          := .f.

   end if

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 4
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
   oItem:cPrompt        := 'Agenda/ CRM'
   oItem:cMessage       := 'Acceso a la agenda del usuario'
   oItem:bAction        := {|| TNotas():New( cPatDat(), oWnd, "01075" ):Activate() }
   oItem:cId            := "01075"
   oItem:cBmp           := "Note_16"
   oItem:cBmpBig        := "Note_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Listín telefónico'
   oItem:cMessage       := 'Acceso al listín telefónico'
   oItem:bAction        := {|| TAgenda():New( cPatDat(), oWnd, "01076" ):Activate() }
   oItem:cId            := "01076"
   oItem:cBmp           := "Telephone_16"
   oItem:cBmpBig        := "Telephone_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Scripts'
   oItem:cMessage       := 'Ejecutar scripts'
   oItem:bAction        := {|| TScripts():New( cPatEmp(), oWnd, "01117" ):Activate() }
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
   oItem:bAction        := {|| TReindex():New( oWnd, "01067" ):Resource() }
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
   oGrupo:nBigItems     :=  1
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
   oItem:cPrompt        := "Cambio de I.V.A."
   oItem:cMessage       := "Cambio de I.V.A."
   oItem:bAction        := {|| TCambioDeIva():Create() }
   oItem:cId            := "01038"
   oItem:cBmp           := "Currency_Euro_16"
   oItem:cBmpBig        := "Currency_Euro_32"
   oItem:lShow          := .f.

   // Ayudas-------------------------------------------------------------------

   oItemAyudas          := oAcceso:Add()
   oItemAyudas:cPrompt  := 'Ayudas'
   oItemAyudas:cBmp     := "Folder16"
   oItemAyudas:cBmpBig  := "Folder_32"
   oItemAyudas:lShow    := .t.

   oGrupo               := TGrupoAcceso()

#ifdef __GST__
   oGrupo:nBigItems     := 4
#endif

#ifdef __MK__
   oGrupo:nBigItems     := 2
#endif

#ifdef __OC__
   oGrupo:nBigItems     := 2
#endif

   oGrupo:cPrompt       := 'Ayudas'
   oGrupo:cLittleBitmap := "Lifebelt_16"
   oGrupo:cBigBitmap    := "Lifebelt_32"

#ifdef __GST__

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Ayuda'
   oItem:cMessage       := 'Ayuda de la aplicación'
   oItem:bAction        := {|| goWeb( __GSTHELP__ ) }
   oItem:cId            := "01093"
   oItem:cBmp           := "Lifebelt_16"
   oItem:cBmpBig        := "Lifebelt_32"
   oItem:lShow          := .f.

#endif

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

#ifdef __GST__

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "Doctor_16"
   oItem:cBmpBig        := "Doctor_32"
   oItem:lShow          := .f.

#endif

Return ( oAcceso )

//---------------------------------------------------------------------------//

Function EnableAcceso()

Return ( nil ) // if( !Empty( oWndBar ), oWndBar:Enable(), ) )

//---------------------------------------------------------------------------//

Function DisableAcceso()

Return ( nil ) // if( !Empty( oWndBar ), oWndBar:Disable(), ) )

//---------------------------------------------------------------------------//

Function BuildMenu()

   if ( "MENU" $ cParamsMain )

      MENU oMenu // 2007

         MENUITEM       "&1. Archivos"

         MENU

            MENUITEM    "&1. Pantalla de inicio";
               MESSAGE  "Muestra la pantalla de inicio" ;
               ACTION   ( PageIni( "01004", oWnd ) );
               HELPID   "01004" ;
               RESOURCE "briefcase2_column_chart_16" ;

            MENUITEM    "&2. Iniciar sesión...";
               MESSAGE  "Inicia una nueva sesión de trabajo" ;
               ACTION   ( ChkTurno( oMenuItem, oWnd ) );
               HELPID   "01000" ;
               RESOURCE "Stopwatch_run_16" ;
               WHEN     !lCurSesion()

            MENUITEM    "&3. Arqueo parcial (X)" ;
               HELPID   "01001" ;
               MESSAGE  "Arqueo parcial de la sesión de trabajo actual";
               ACTION   ( CloseTurno( oMenuItem, oWnd, .f., .t. ) );
               RESOURCE "Stopwatch_Refresh_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&4. Cerrar sesión (Z)" ;
               HELPID   "01001" ;
               MESSAGE  "Cierra la sesión de trabajo actual";
               ACTION   ( CloseTurno( oMenuItem, oWnd ) );
               RESOURCE "Stopwatch_stop_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&5. Sesiones";
               HELPID   "01002" ;
               MESSAGE  "Sesiones del programa";
               RESOURCE "Stopwatch_16" ;
               ACTION   ( Turnos( oMenuItem, oWnd ) )

            SEPARATOR

            MENUITEM    "&6. Empresas";
               MESSAGE  "Base de datos de empresas" ;
               ACTION   ( Empresa( oMenuItem, oWnd ) );
               RESOURCE "Office_building_16" ;
               HELPID   "01003"

            SEPARATOR

            MENUITEM    "&7. Artículos";
               MESSAGE  "Ficheros relacionados con artículos" ;
               RESOURCE "Cube_Yellow_16" ;

               MENU

                  MENUITEM    "&1. Grupos de familias";
                     HELPID   "01011" ;
                     MESSAGE  "Grupos de familias" ;
                     ACTION   ( TGrpFam():New( cPatArt(), oWnd, oMenuItem ):Play() ) ;
                     RESOURCE "Folder_Cubes_Color_16" ;

                  MENUITEM    "&2. Familias";
                     MESSAGE  "Base de datos de las familias de artículos" ;
                     HELPID   "01012" ;
                     ACTION   ( Familia( oMenuItem, oWnd ) );
                     RESOURCE "Cubes_16" ;

                  MENUITEM    "&3. Tipos";
                     HELPID   "01013" ;
                     MESSAGE  "Clasificacion de artículos" ;
                     ACTION   ( TTipArt():New( cPatArt(), oWnd, oMenuItem ):Activate() );
                     RESOURCE "Cubes_Blue_16" ;

                  MENUITEM    "&4. Fabricantes";
                     HELPID   "01070" ;
                     MESSAGE  "Fabricantes" ;
                     ACTION   ( TFabricantes():New( cPatArt(), oWnd, oMenuItem ):Activate() );
                     RESOURCE "Nut_and_bolt_16" ;

                  SEPARATOR

                  MENUITEM    "&5. Artículos" + Chr( 9 ) + "Alt-F2";
                     MESSAGE  "Base de datos de artículos" ;
                     ACTION   ( Articulo( oMenuItem, oWnd ) ) ;
                     HELPID   "01014" ;
                     ACCELERATOR ACC_ALT, VK_F2;
                     RESOURCE "Cube_Yellow_16" ;

                  MENUITEM    "&6. Comentarios";
                     HELPID   "04002" ;
                     MESSAGE  "Comentarios para los artículos";
                     ACTION   ( TComentarios():New( cPatArt(), oWnd, oMenuItem ):Activate() );
                     RESOURCE "message_16" ;

                 /* MENUITEM    "&7. Códigos de barras";
                     MESSAGE  "Acceso a los códigos de barras de los artículos" ;
                     ACTION   ( ArtCodebar( oMenuItem, oWnd ) ) ;
                     HELPID   "01024" ;
                     RESOURCE "Remotecontrol_16" ;
                  */

                  SEPARATOR

                  MENUITEM    "&7. Propiedades de artículos" ;
                     HELPID   "01015" ;
                     MESSAGE  "Base de datos con las propiedades de los artículos" ;
                     ACTION   ( Prop( oMenuItem, oWnd ) );
                     RESOURCE "Die_Gold_16" ;

                  MENUITEM    "&8. Factores de conversión";
                     HELPID   "01016" ;
                     MESSAGE  "Factores de conversión" ;
                     ACTION   ( TblCnv( oMenuItem, oWnd ) );
                     RESOURCE "Tape_Measure2_16" ;

                  MENUITEM    "&9. Tanques de combustible";
                     HELPID   "01017" ;
                     MESSAGE  "Tanques de combustible" ;
                     ACTION   ( TTankes():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
                     RESOURCE "Potion_Red_16" ;

                  MENUITEM    "&A. Unidades de Medición";
                     MESSAGE  "Unidades de medición de artículos" ;
                     ACTION   ( UniMedicion():New( cPatGrp(), oWnd, oMenuItem ):Activate() ) ;
                     HELPID   "01103" ;
                     RESOURCE "Tape_Measure1_16" ;

                  MENUITEM    "&B. Categorías";
                     MESSAGE  "Categorías de artículos" ;
                     ACTION   ( Categoria( oMenuItem, oWnd ) ) ;
                     HELPID   "01101" ;
                     RESOURCE "Colors_16" ;

                  MENUITEM    "&C. Temporadas";
                     MESSAGE  "Temporadas de artículos" ;
                     ACTION   ( Temporada( oMenuItem, oWnd ) ) ;
                     HELPID   "01114" ;
                     RESOURCE "Sun_and_cloud_16"

                  SEPARATOR

                  MENUITEM    "&D. Tarifas de precios";
                     MESSAGE  "Base de datos con las tarifas de precios" ;
                     HELPID   "01019" ;
                     ACTION   ( Tarifa( oMenuItem, oWnd ) );
                     RESOURCE "Percent_16" ;

                  MENUITEM    "&E. Ofertas";
                     MESSAGE  "Base de datos de las ofertas de artículos" ;
                     HELPID   "01020" ;
                     ACTION   ( Oferta( oMenuItem, oWnd ) );
                     RESOURCE "Star_Red_16" ;

                  MENUITEM    "&F. Promociones";
                     MESSAGE  "Base de datos con las promociones comerciales" ;
                     HELPID   "01021" ;
                     ACTION   ( Promocion( oMenuItem, oWnd ) );
                     RESOURCE "Star_Blue_16" ;

                  SEPARATOR

                  MENUITEM    "&G. Búsqueda por series";
                     MESSAGE  "Búsqueda por números de serie" ;
                     ACTION   ( TSeaNumSer():Activate( oMenuItem, oWnd ) ) ;
                     HELPID   "01022" ;
                     RESOURCE "Package_Find_16" ;

                  MENUITEM    "&H. Búsqueda por lotes";
                     MESSAGE  "Búsqueda por lotes" ;
                     ACTION   ( TTrazarLote():Activate( oMenuItem, oWnd ) ) ;
                     HELPID   "01023" ;
                     RESOURCE "Package_View_16" ;

               ENDMENU

            MENUITEM    "&8. Clientes";
               MESSAGE  "Ficheros relacionados con clientes";
               RESOURCE "User1_16" ;

               MENU
                  MENUITEM    "&1. Grupos";
                     HELPID   "01030" ;
                     MESSAGE  "Base de datos de grupos de clientes" ;
                     ACTION   ( TGrpCli():New( cPatCli(), oWnd, oMenuItem ):Activate() );
                     RESOURCE "Users2_16" ;

                  MENUITEM    "&2. Rutas";
                     MESSAGE  "Base de datos de rutas" ;
                     HELPID   "01031" ;
                     ACTION   ( Ruta( oMenuItem, oWnd ) ) ;
                     RESOURCE "Signpost_16" ;

                  SEPARATOR

                  MENUITEM    "&3. Clientes";
                     MESSAGE  "Base de datos de clientes" ;
                     HELPID   "01032" ;
                     ACTION   ( Client( oMenuItem, oWnd ) ) ;
                     RESOURCE "User1_16" ;

                  SEPARATOR

                  MENUITEM    "4. Agentes";
                     MESSAGE  "Base de datos de agentes" ;
                     HELPID   "01033" ;
                     ACTION   ( Agentes( oMenuItem, oWnd ) ) ;
                     RESOURCE "Security_Agent_16" ;

                  MENUITEM    "5. Programa de fidelización";
                     MESSAGE  "Programa de fidelización" ;
                     HELPID   "04006" ;
                     ACTION   ( TFideliza():New( cPatArt(), oWnd, "04006" ):Activate() ) ;
                     RESOURCE "Cli" ;

                  MENUITEM    "&6. Plantillas de ventas automáticas";
                     HELPID   "04015" ;
                     MESSAGE  "Plantillas de ventas automáticas" ;
                     ACTION   ( TFacAutomatica():New( cPatEmp(), oWnd, "04015" ):Activate() );
                     RESOURCE "document_gear_16" ;

               ENDMENU

            MENUITEM    "&9. Proveedores";
               MESSAGE  "Ficheros relacionados con proveedores" ;
               RESOURCE "Businessman_16" ;

               MENU

                  MENUITEM    "&1. Grupos de proveedores";
                     HELPID   "01110" ;
                     MESSAGE  "Base de datos de grupos de proveedores" ;
                     ACTION   ( TGrpPrv():New( cPatPrv(), oWnd, oMenuItem ):Activate() );
                     RESOURCE "GrpPrv_16" ;

                  MENUITEM    "&2. Proveedores";
                     MESSAGE  "Base de datos de proveedores" ;
                     HELPID   "01034" ;
                     ACTION   ( Provee( oMenuItem, oWnd ) ) ;
                     RESOURCE "Businessman_16" ;

               ENDMENU

            SEPARATOR

            MENUITEM    "&A. Almacenes";
               MESSAGE  "Ficheros relacionados con almacenes";
               RESOURCE "Package_16" ;

               MENU

                  MENUITEM    "&1. Almacenes";
                     MESSAGE  "Base de datos de almacenes" ;
                     HELPID   "01035" ;
                     ACTION   ( Almacen( oMenuItem, oWnd  ) );
                     RESOURCE "Package_16" ;

                  MENUITEM    "&2. Tipos de movimientos de almacén";
                     HELPID   "01042" ;
                     MESSAGE  "Tipos de movimientos de almacén" ;
                     ACTION   ( TMov( oMenuItem, oWnd ) );
                     RESOURCE "Package_replace2_16" ;

                  MENUITEM    "&3. Ubicaciones de almacenes" ;
                     HELPID   "01088" ;
                     MESSAGE  "Base de datos con las ubicaciones de almacenes" ;
                     ACTION   ( Ubicacion( oMenuItem, oWnd ) );
                     RESOURCE "Forklifter_16" ;

               ENDMENU

            SEPARATOR

            MENUITEM    "&B. Tipos de " + cImp();
               MESSAGE  "Base de datos de los tipos de " + cImp() ;
               HELPID   "01036" ;
               ACTION   ( Tiva( oMenuItem, oWnd ) ) ;
               RESOURCE "Moneybag_16" ;

            MENUITEM    "&C. Impuestos especiales";
               MESSAGE  "Impuestos especiales" ;
               HELPID   "01037" ;
               ACTION   ( NewImp( oMenuItem, oWnd ) );
               RESOURCE "Moneybag_Dollar_16" ;

            SEPARATOR

            MENUITEM    "&D. Divisas monetarias";
               MESSAGE  "Base de datos de los tipos de divisas" ;
               HELPID   "01038" ;
               ACTION   ( Divisas( oMenuItem, oWnd ) );
               RESOURCE "Currency_Euro_16" ;

            MENUITEM    "&E. Bancos";
               HELPID   "01106" ;
               MESSAGE  "Base de datos de los bancos de la empresa" ;
               ACTION   ( TBancos():New( cPatGrp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Banc_16" ;

            MENUITEM    "&F. Formas de pago";
               MESSAGE  "Base de datos de las formas de pago" ;
               HELPID   "01039" ;
               ACTION   ( FPago( oMenuItem, oWnd ) );
               RESOURCE "Creditcards_16" ;

            MENUITEM    "&G. Cuentas de remesas";
               MESSAGE  "Cuentas de remesas para recibos por banco" ;
               HELPID   "01044" ;
               ACTION   ( TCtaRem():New( cPatCli(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Address_book2_16" ;

            MENUITEM    "&H. Cajas";
               HELPID   "01040" ;
               MESSAGE  "Base de datos de las cajas del establecimiento" ;
               ACTION   ( Cajas( oMenuItem, oWnd ) );
               RESOURCE "Cashier_16" ;

            MENUITEM    "&I. Grupos de ventas contables";
               HELPID   "01018" ;
               MESSAGE  "Base de datos de grupos de ventas de contabilidad" ;
               ACTION   ( GrpVenta( oMenuItem, oWnd ) );
               RESOURCE "Index_16" ;

            SEPARATOR

            MENUITEM    "&J. Frases publicitarias";
               MESSAGE  "Frases publicitarias de artículos" ;
               ACTION   ( TFrasesPublicitarias():New( cPatArt(), oWnd, oMenuItem ):Activate() ) ;
               HELPID   "01104" ;
               RESOURCE "Led_Red_16" ;

            MENUITEM    "&K. Paises";
               HELPID   "01041" ;
               MESSAGE  "Paises" ;
               ACTION   ( TPais():New( cPatDat(), oWnd, oMenuItem ):Activate() ) ;
               RESOURCE "Flag_spain_16" ;

            MENUITEM    "&L. Tipos de ventas";
               HELPID   "01043" ;
               MESSAGE  "Tipos de movimientos de ventas" ;
               ACTION   ( TVta( oMenuItem, oWnd ) );
               RESOURCE "Wallet_closed_16" ;

            MENUITEM    "&M. Transportistas";
               MESSAGE  "Transportistas" ;
               HELPID   "01045" ;
               ACTION   ( TTrans():New( cPatCli(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Truck_Blue_16" ;

            MENUITEM    "&N. Tipificaciones";
               MESSAGE  "Ficheros relacionados con tipificaciones";
               RESOURCE "Folder2_Red_16" ;

               MENU

                  MENUITEM    "&1. Tipos de notas";
                     MESSAGE  "Tipos de notas" ;
                     HELPID   "01097" ;
                     ACTION   ( TipoNotas( oMenuItem, oWnd ) );
                     RESOURCE "Folder2_Red_16" ;

                  MENUITEM    "&2. Tipos de incidencias";
                     MESSAGE  "Tipos de incidencias" ;
                     HELPID   "01089" ;
                     ACTION   ( TipInci( oMenuItem, oWnd ) );
                     RESOURCE "Camera_16" ;

                  MENUITEM    "&3. Situaciones de documentos";
                     MESSAGE  "Tipos de situaciones en documentos de compra y venta" ;
                     HELPID   "01115" ;
                     ACTION   ( Situaciones( oMenuItem, oWnd ) );
                     RESOURCE "Document_Attachment_16" ;

                  MENUITEM    "&4. Tipos de comandas";
                     MESSAGE  "Ordenar las comandas por tipos" ;
                     HELPID   "01098" ;
                     ACTION   ( TComandas():New( cPatArt(), oWnd(), "01011" ):Play() );
                     RESOURCE "documents_preferences_16" ;

                  MENUITEM    "&5. Tipos de impresoras";
                     MESSAGE  "Tipos de impresoras" ;
                     HELPID   "01096" ;
                     ACTION   ( TipoImpresoras( oMenuItem, oWnd ) );
                     RESOURCE "printer_view_16" ;

               ENDMENU

            ENDMENU

         MENUITEM "&2. Compras"

         MENU

            MENUITEM    "&1. Pedidos";
               HELPID   "01046" ;
               MESSAGE  "Pedidos a proveedores";
               ACTION   ( PedPrv( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Clipboard_empty_businessman_16" ;

            MENUITEM    "&2. Albaranes";
               HELPID   "01047" ;
               MESSAGE  "Albaranes de proveedores";
               ACTION   ( AlbPrv( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_plain_businessman_16" ;

            MENUITEM    "&3. Facturas";
               HELPID   "01048" ;
               MESSAGE  "Facturas de proveedores";
               ACTION   ( FacPrv( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_businessman_16" ;

            MENUITEM    "&4. Facturas rectificativas";
               HELPID   "01099" ;
               MESSAGE  "Facturas rectificativas de proveedores";
               ACTION   ( RctPrv( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_navigate_cross_16" ;

            SEPARATOR

            MENUITEM    "&5. Pagos";
               HELPID   "01049" ;
               MESSAGE  "Pagos a proveedores";
               ACTION   ( RecPrv( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Money2_businessman_16" ;

         ENDMENU

         MENUITEM "&3. Almacenes"

         MENU

            MENUITEM    "&1. Movimientos de almacén";
               HELPID   "01050" ;
               MESSAGE  "Base de datos de movimientos de almacén";
               ACTION   ( RemMovAlm( "01050", oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Pencil_Package_16"
            /*
            MENUITEM    "&2. Historico de movimientos de almacén";
               HELPID   "01051" ;
               MESSAGE  "Base de datos de movimientos de almacén";
               ACTION   ( HisMovAlm( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Package_book_red_16"
            */
            SEPARATOR

            MENUITEM    "&3. Introducción depósitos";
               HELPID   "01052" ;
               MESSAGE  "Introducción de dépositos de almacén";
               ACTION   ( DepAge( oMenuItem, oWnd ) );
               RESOURCE "Package_add_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&4. Estado depósitos";
               HELPID   "01053" ;
               MESSAGE  "Estado de los dépositos";
               ACTION   ( ExtAge( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Package_ok_16" ;

            MENUITEM    "&5. Liquidación de depósitos";
               HELPID   "01054" ;
               MESSAGE  "Liquidación de depósitos";
               ACTION   ( LqdAlm( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Package_preferences_16" ;

         ENDMENU

         MENUITEM "&4. Producción"

         MENU

            MENUITEM    "&1. Secciones" ;
               HELPID   "04001" ;
               MESSAGE  "Secciones de personal" ;
               ACTION   ( TSeccion():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Group_Worker2_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&2. Operarios";
               HELPID   "04002" ;
               MESSAGE  "Operarios";
               ACTION   ( TOperarios():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Worker2_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&3. Tipos de horas";
               HELPID   "04003" ;
               MESSAGE  "Tipos de horas" ;
               ACTION   ( THoras():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Worker2_Clock_16" ;
               WHEN     lCurSesion()

            SEPARATOR

            MENUITEM    "&4. Operaciones";
               HELPID   "04004" ;
               MESSAGE  "Operaciones" ;
               ACTION   ( TOperacion():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Worker2_Hammer2_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&5. Tipos de operaciones";
               HELPID   "04008" ;
               MESSAGE  "Tipos de operaciones" ;
               ACTION   ( TTipOpera():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Worker_Folder_Blue_16" ;
               WHEN     lCurSesion()

            SEPARATOR

            MENUITEM    "&6. Maquinaria";
               HELPID   "04005" ;
               MESSAGE  "Maquinaria" ;
               ACTION   ( TMaquina():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Robot_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&7. Costes de maquinaria";
               HELPID   "04006" ;
               MESSAGE  "Costes de maquinaria" ;
               ACTION   ( TCosMaq():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Robot_Money2_16" ;
               WHEN     lCurSesion()

            SEPARATOR

            MENUITEM    "&8. Partes de producción";
               HELPID   "04007" ;
               MESSAGE  "Partes de producción" ;
               ACTION   ( TProduccion():New( cPatEmp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Worker2_Form_Red_16" ;
               WHEN     lCurSesion()

            SEPARATOR

            MENUITEM    "&9. Costos de mano de obra";
               MESSAGE  "Actualiza costos de mano de obra" ;
               ACTION   ( ActualizaCosto():Activate( oMenuItem, oWnd ) ) ;
               HELPID   "04008" ;
               RESOURCE "Worker2_Money_16" ;

         ENDMENU


         MENUITEM "&5. Expedientes"

         MENU

            MENUITEM    "&1. Tipo expediente" ;
               HELPID   "04011" ;
               MESSAGE  "Acceso a los tipos de expedientes" ;
               ACTION   ( TTipoExpediente():New( cPatEmp(), oWnd, "04011" ):Activate() );
               RESOURCE "Folders_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&2. Entidades";
               HELPID   "04012" ;
               MESSAGE  'Acceso a las distintas entidades';
               ACTION   ( TEntidades():New( cPatEmp(), oWnd, "04012" ):Activate() );
               RESOURCE "School_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&3. Colaboradores";
               HELPID   "04013" ;
               MESSAGE  'Acceso a la tabla de colaboradores' ;
               ACTION   ( TColaboradores():New( cPatEmp(), oWnd, "04013" ):Activate() );
               RESOURCE "Teacher_16" ;
               WHEN     lCurSesion()

            MENUITEM    "&4. Actuaciones";
               HELPID   "04014" ;
               MESSAGE  'Acceso a la tabla de actuaciones' ;
               ACTION   ( TActuaciones():New( cPatEmp(), oWnd, "04014" ):Activate() );
               RESOURCE "Power_Drill_16" ;
               WHEN     lCurSesion()


            SEPARATOR

            MENUITEM    "&5. Expedientes";
               HELPID   "04010" ;
               MESSAGE  'Acceso a los expedientes' ;
               ACTION   ( TExpediente():New( cPatEmp(), oWnd, "04010" ):Activate() );
               RESOURCE "Folder_document_16" ;
               WHEN     lCurSesion()

         ENDMENU

         MENUITEM "&6. Ventas"

         MENU

            //MENUITEM    "P&lantillas";
            //   MESSAGE  "Plantillas de presupuestos";
            //   ACTION   ( PltCli( oWnd ) )
            //
            //SEPARATOR

            MENUITEM    "&1. Presupuesto";
               HELPID   "01055" ;
               MESSAGE  "Presupuesto de clientes";
               ACTION   ( PreCli( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Notebook_user1_16" ;

            MENUITEM    "&2. Pedidos";
               HELPID   "01056" ;
               MESSAGE  "Pedidos de clientes";
               ACTION   ( PedCli( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Clipboard_empty_user1_16" ;

            MENUITEM    "&3. Albaranes";
               HELPID   "01057" ;
               MESSAGE  "Albaranes de clientes";
               ACTION   ( AlbCli( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_plain_user1_16" ;

            MENUITEM    "&4. Facturas";
               HELPID   "01058" ;
               MESSAGE  "Facturas a clientes";
               ACTION   ( FactCli( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_user1_16" ;

            MENUITEM    "&5. Facturas de anticipos";
               HELPID   "01181" ;
               MESSAGE  "Facturas de anticipos";
               ACTION   ( FacAntCli( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_money2_16" ;

            MENUITEM    "&6. Facturas rectificativas";
               HELPID   "01182" ;
               MESSAGE  "Facturas rectificativas";
               ACTION   ( FacRec( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Document_Delete_16"

            SEPARATOR

            MENUITEM    "&7. Recibos";
               HELPID   "01059" ;
               MESSAGE  "Recibos a clientes";
               ACTION   ( RecCli( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Briefcase_user1_16"

            MENUITEM    "&8. Remesas bancarias";
               HELPID   "01060" ;
               MESSAGE  "Remesas bancarias de recibos" ;
               ACTION   ( TRemesas():New( cPatEmp(), oMenuItem, oWnd ):Activate() );
               WHEN     lCurSesion() ;
               RESOURCE "Briefcase_document_16"

            //MENUITEM    "&3. Cobros por agentes";
            //   HELPID   "01061" ;
            //   MESSAGE  "Cobros por agentes";
            //   ACTION   ( TRemAge():New( cPatEmp(), oMenuItem, oWnd ):Activate() );
            //   WHEN     lCurSesion()

            //
            //MENUITEM    "&4. Liquidación de agentes";
            //   HELPID   "01060" ;
            //   MESSAGE  "Liquidación comisiones a agentes" ;
            //   ACTION   ( LiqAge( oMenuItem, oWnd ) );
            //   WHEN     lCurSesion()

            SEPARATOR

            MENUITEM    "&9. Ordenes de carga";
               HELPID   "01062" ;
               MESSAGE  "Liquidación comisiones a agentes" ;
               ACTION   ( TOrdCarga():New( cPatEmp(), oMenuItem, oWnd ):Activate() );
               WHEN     lCurSesion() ;
               RESOURCE "Truck_blue_document_16"

         ENDMENU

         MENUITEM "&7. T.P.V."

         MENU

            MENUITEM    "&1. Terminal punto de venta" + Chr( 9 ) + "Alt-F3";
               HELPID   "01063" ;
               MESSAGE  "Pasar a venta por mostrador ( Alt-F3 )";
               ACTION   ( FrontTpv( oMenuItem, oWnd ) ) ;
               ACCELERATOR ACC_ALT, VK_F3;
               WHEN     lCurSesion() ;
               RESOURCE "Cashier_user1_16"

            MENUITEM    "&2. T. P. V. táctil";
               HELPID   "01064" ;
               MESSAGE  "Pasar a venta por mostrador táctil";
               ACTION   ( TactilTpv( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Cashier_hand_point_16"

            MENUITEM    "&3. Entradas y salidas";
               HELPID   "01065" ;
               MESSAGE  "Entradas y salidas de caja";
               ACTION   ( EntSal( oMenuItem, oWnd ) );
               WHEN     lCurSesion() ;
               RESOURCE "Cashier_replace_16"

            SEPARATOR

            MENUITEM    "&4. Sala de ventas";
               MESSAGE  "Sala de ventas" ;
               ACTION   ( TSalaVenta():New( cPatEmp(), oWnd, oMenuItem ):Activate() ) ;
               HELPID   "01105" ;
               RESOURCE "Cup_16" ;

            MENUITEM    "&5. Invitaciones";
               HELPID   "01107" ;
               MESSAGE  "Base de datos de tipos de invitaciones" ;
               ACTION   ( TInvitacion():New( cPatGrp(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Masks_16" ;

         ENDMENU

         MENUITEM    "&8. Galería de informes";
            MESSAGE  "Galería de informes" ;
            HELPID   "01066" ;
            ACTION   ( RunReportGalery() )

         MENUITEM "&9. Herramientas"

         MENU

            MENUITEM    "&1. Regenerar índices";
               MESSAGE  "Regenera todos los indices y empaqueta los datos" ;
               HELPID   "01067" ;
               ACTION   ( Reindexa( oWnd, "01067" ) );
               RESOURCE "Recycle_16"

            SEPARATOR

            MENUITEM    "&2. Usuarios y grupos";
               MESSAGE  "Usuarios y tipos de acceso a la aplicación" ;
               HELPID   "01074" ;
               ACTION   ( Usuarios( oMenuItem, oWnd ) );
               RESOURCE "Businessmen_16"

            /*
            MENUITEM    "&3. Auditor";
               MESSAGE  "Servicios de auditoria" ;
               HELPID   "01103" ;
               ACTION   ( ShellAuditor( cPatDat(), oWnd, oMenuItem ) );
               RESOURCE "Policeman_usa_16"
            */

            SEPARATOR

            MENUITEM    "&3. Documentos y etiquetas";
               MESSAGE  "Configurar documentos y etiquetas" ;
               HELPID   "01068" ;
               ACTION   ( CfgDocs( oMenuItem, oWnd ) );
               RESOURCE "Document_edit_16"

            MENUITEM    "&4. Capturas de T.P.V.";
               MESSAGE  "Configurar capturas de T.P.V." ;
               HELPID   "01083" ;
               ACTION   ( TCaptura():New( cPatDat(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Window_edit_16"

            SEPARATOR

            MENUITEM    "&5. Dispositivos";
               MESSAGE  "Configurar los dispositivos de la aplicación, impresora de tickets, visores, cajones" ;
               RESOURCE "Printer_16" ;

               MENU

                  MENUITEM    "&1. Configurar balanza" ;
                     HELPID   "01090" ;
                     MESSAGE  "Configurar balanzas" ;
                     ACTION   ( ConfImpTiket( oMenuItem, oWnd ) );
                     RESOURCE "Gauge_16"

                  MENUITEM    "&2. Configurar visor";
                     MESSAGE  "Configurar visor" ;
                     HELPID   "01092" ;
                     ACTION   ( ConfVisor ( oMenuItem, oWnd ) );
                     RESOURCE "Console_network_16"

                  MENUITEM    "&3. Configurar cajón portamonedas";
                     MESSAGE  "Configurar cajón portamonedas" ;
                     HELPID   "01091" ;
                     ACTION   ( ConfCajPorta( oMenuItem, oWnd )  );
                     RESOURCE "Harddisk_16"

                  MENUITEM    "&4. Especificar impresora";
                     MESSAGE  "Seleccionar impresora predeterminada" ;
                     ACTION   ( PrinterSetup() );
                     RESOURCE "Printer_preferences_16"

                  ENDMENU

            SEPARATOR

            MENUITEM    "&6. Cambiar códigos";
               MESSAGE  "Cambiar códigos de la aplicación" ;
               HELPID   "01073" ;
               ACTION   ( TChgCode():New( oMenuItem, oWnd ):Resource() );
               RESOURCE "Replace_16"

            MENUITEM    "&7. Agenda/CRM";
               MESSAGE  "Acceso a la agenda del usuario" ;
               HELPID   "01075" ;
               ACTION   ( TNotas():New( cPatDat(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Note_16"

            MENUITEM    "&8. Listín telefónico";
               HELPID   "01076" ;
               MESSAGE  "Acceso a lista de Telefonos de la Aplicación" ;
               ACTION   ( TAgenda():New( cPatDat(), oWnd, oMenuItem ):Activate() );
               RESOURCE "Telephone_16"

            SEPARATOR

            MENUITEM    "&9. Copia seguridad";
               MESSAGE  "Copia de respaldo del sistema" ;
               HELPID   "01077" ;
               ACTION   ( TBackup():New( oMenuItem, oWnd ) );
               RESOURCE "Shield_16"

            SEPARATOR

            MENUITEM    "&A. Envío y recepción de información";
               MESSAGE  "Conectarse al servidor para enviar y recibir información" ;
               HELPID   "01078" ;
               ACTION   ( TSndRecInf():New( oMenuItem, oWnd ):Activate() );
               RESOURCE "Satellite_dish_16"

            MENUITEM    "&B. Exportar e importar datos a terminales";
               MESSAGE  "Exportar e importar datos a terminales de mano" ;
               HELPID   "01079" ;
               ACTION   ( TEdm():Activate( oMenuItem, oWnd ) );
               RESOURCE "Pda_16"

            MENUITEM    "&C. Comercio electrónico";
               MESSAGE  "Comercio electrónico" ;
               RESOURCE "ComercioElectronico_16"

               MENU

               MENUITEM    "&1. Comercio electrónico";
                  HELPID   "01108" ;
                  MESSAGE  "Comercio electrónico" ;
                  ACTION   ( TComercio():New( oMenuItem, oWnd ):Activate() ) ;
                  RESOURCE "ComercioElectronico_16"

               MENUITEM    "&2. Pedidos electrónicos";
                  HELPID   "01109" ;
                  MESSAGE  "Pedidos de clientes recibidos de comercio electrónico" ;
                  ACTION   ( PedCli( "01056", oWnd, , , , .t. ) ) ;
                  RESOURCE "Clipboard_Empty_Earth_16"

               ENDMENU

            SEPARATOR

            MENUITEM    "&D. Importar datos";
               MESSAGE  "Importa los datos de otras aplicaciones a nuestra aplicación" ;
               RESOURCE "Import16" ;

               MENU

                  MENUITEM    "&1. Factuplus ®";
                     HELPID   "01080" ;
                     MESSAGE  "Importa los datos de Factuplus a nuestra aplicación" ;
                     ACTION   ( ImpFactu( oMenuItem, oWnd ) );
                     RESOURCE "Import16"

                  MENUITEM    "&2. Factucont ®";
                     HELPID   "01100" ;
                     MESSAGE  "Importa los datos de Factucont a nuestra aplicación" ;
                     ACTION   ( ImpFacCom( oMenuItem, oWnd ) );
                     RESOURCE "Import16"

                  MENUITEM    "&3. Tarifas de artículos ";
                     HELPID   "01102" ;
                     MESSAGE  "Importa tarifa de artículos desde Excel" ;
                     ACTION   ( TImpEstudio():New( oMenuItem, oWnd ):Activate() );
                     RESOURCE "Import16"

               ENDMENU

            SEPARATOR

            MENUITEM    "&E. Exportación de ventas";
               HELPID   "01113" ;
               MESSAGE  "Exporta datos de ventas";
               ACTION   ( TExportaTarifas():New( "01111", oWnd ):Play() );
               RESOURCE "Export16"

            MENUITEM    "&F. Exportación de compras";
               HELPID   "01112" ;
               MESSAGE  "Exporta datos de compras";
               ACTION   ( TExportaCompras():New( "01112", oWnd ):Play() );
               RESOURCE "Export16"

            SEPARATOR

            MENUITEM    "&G. Sincroniza preventa";
               HELPID   "04016" ;
               MESSAGE  "Sincronizamos preventa" ;
               ACTION   ( SincronizaPreventa():Activate( "04016", oWnd ) );
               RESOURCE "pda_write_16"

            MENUITEM    "&H. Actualizar precios de tarifas";
               HELPID   "01081" ;
               MESSAGE  "Actualiza los precios de las condiones particulares de clientes" ;
               ACTION   ( ChgTarifa( oMenuItem, oWnd ) );
               RESOURCE "Table_replace_16"

            MENUITEM    "&I. Configurar barra de botones" ;
               HELPID   "01085" ;
               ACTION   ( oWndBar:EditButtonBar( oWnd, "01085" ) ) ;
               RESOURCE "Magic_16"

            MENUITEM    "&J. Calculadora";
               MESSAGE  "Ejecuta la calculadora de windows" ;
               ACTION   ( WinExec( "Calc" ) ) ;
               RESOURCE "Calculator_16"

            MENUITEM    "&K. Fecha de trabajo";
               MESSAGE  "Permite cambiar la fecha de trabajo de la aplicación" ;
               HELPID   "01084" ;
               ACTION   ( SelSysDate( "01084" ) ) ;
               RESOURCE "Calendar_16"

            MENUITEM    "&L. Scripts";
               MESSAGE  "Ejecutas Scripts de trabajo" ;
               HELPID   "01117" ;
               ACTION   ( TScripts():New( cPatEmp(), oWnd, "01117" ):Activate() ) ;
               RESOURCE "text_code_colored_16"

         /*
            MENUITEM    "&K. Importación a mysql" ;
               HELPID   "01112" ;
               ACTION   ( TImpDbfToSql():Activate( "01112", oWnd ) ) ;
               RESOURCE "Data_Replace_16"
         */

         ENDMENU

         MENUITEM "&0. Ayudas"

         MENU

         #ifdef __GST__

            MENUITEM    "&1. Ayuda" ;
               ACTION   ( goWeb( __GSTHELP__ ) ) ;
               MESSAGE  "Ayuda sobre el programa" ;
               RESOURCE "Lifebelt_16"

            SEPARATOR

         #endif

            MENUITEM    "&2. Visitar web";
               MESSAGE  "Visitar web" ;
               ACTION   ( goWeb( __GSTWEB__ ) ) ;
               RESOURCE "SndInt16"

            MENUITEM    "&3. Acerca de...";
               MESSAGE  "Datos sobre el autor" ;
               ACTION   ( About() ) ;
               RESOURCE "Help_16"

         #ifdef __GST__

            MENUITEM    "&5. Solicitar asistencia remota";
               MESSAGE  "Solicitar asistencia remota" ;
               ACTION   ( RunAsistenciaRemota() ) ;
               RESOURCE "Doctor_16"

            MENUITEM    "&9. PlantillaXML";
               ACTION   ( TPlantillaXML():New( cPatEmp(), oWnd, "04006" ):Activate() ) ;
               RESOURCE "Doctor_16"

            MENUITEM    "&0. Test nuevo report";
               ACTION   ( TFastReportInfGen():New( "Acumulado de unidades vendidas por artículo y fecha" ):Play() ) ;
               RESOURCE "Doctor_16"

            MENUITEM    "&1. Test factura electrinoca";
               ACTION   ( TFacturaElectronica():New( "d:\test.xml" ):GeneraXml() ) ;
               RESOURCE "Doctor_16"

         #endif

         ENDMENU

         MENUITEM    "&S. Salir";
            MESSAGE  "Salir de la aplicación" ;
            ACTION   ( oWnd:End() )

      ENDMENU

   else

      MENU oMenu
      ENDMENU

   end if


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

#ifdef __GST__

   local oDlg
   local oTree
   local oBrush
   local oImgLst

   DEFINE BRUSH oBrush FILE ( cBmpVersion() )

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

#else

   msgAbout(   __GSTROTOR__               ,;
               __GSTFACTORY__ + CRLF +    ;
               __GSTDIRECCION__ + CRLF +  ;
               __GSTPOBLACION__ + CRLF +  ;
               __GSTOTROS__ )

#endif

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __HARBOUR__

Static Function CreateMainPdaWindow( oIconApp )

   /*
   Chequeo inicial de la aplicacion--------------------------------------------
   */

   lInitCheck()

   pdaTicket( "01063" )

Return nil

//---------------------------------------------------------------------------//

Static Function ExecuteMainPdaWindow( oListView, oDlg )

   do case
      case oListView:nOption == 1
         TNotas():New( cPatDat(), nil, "01075" ):Dialog()
      case oListView:nOption == 2
         PreCliDialog()
      case oListView:nOption == 3
         // PedCliDialog()
      case oListView:nOption == 4
         //AlbCliDialog()
      case oListView:nOption == 5
         //FactCliDialog()
   end case

Return nil

//---------------------------------------------------------------------------//

Function CreateMainTctWindow( oIconApp )

   SysRefresh()

   DEFINE WINDOW oWnd ;
      FROM     0, 0 TO 26, 82;
      TITLE    __GSTTACTIL__ + " : " ;
      MDI ;
      ICON     oIconApp ;
      MENU     BuildTctMenu()

   oWndBar                    := TctCreateButtonBar( oWnd )
   oWndBar:CreateButtonBar( oWnd, .t., .t. )

   oWnd:Cargo                 := cParamsMain

   SET MESSAGE OF oWnd TO __GSTCOPYRIGHT__ NOINSET

   DEFINE MSGITEM oDlgProgress PROMPT ""                                         OF oWnd:oMsgBar SIZE 100

   oWnd:oMsgBar:oDate         := TMsgItem():New( oWnd:oMsgBar, Dtoc( GetSysDate() ), oWnd:oMsgBar:GetWidth( DToC( GetSysDate() ) ) + 12,,,, .t., { || SelSysDate() } )
   oWnd:oMsgBar:oDate:lTimer  := .t.
   oWnd:oMsgBar:oDate:bMsg    := { || GetSysDate() }
   oWnd:oMsgBar:CheckTimer()

   DEFINE MSGITEM oMsgUser    PROMPT "Usuario : "  + Rtrim( oUser():cNombre() )  OF oWnd:oMsgBar SIZE 200

   DEFINE MSGITEM oMsgCaja    PROMPT "Caja : "     + oUser():cCaja()             OF oWnd:oMsgBar SIZE 100

   DEFINE MSGITEM oMsgSesion  PROMPT ""                                          OF oWnd:oMsgBar SIZE 100

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT    ( WndPaint( hDC, oWnd, oBmp ), SysRefresh() );
      ON INIT     ( InitMainTctWindow( oWnd ) )

      KillAutoImp()

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
         oWnd:End()
      end if

      SysRefresh()

Return nil

//--------------------------------------------------------------------------//

Static Function InitMainTctWindow( oWnd )

   lTpvInitCheck()

   SelCajTactil( , .t. )

   TactilTpv( "01064", oWnd, .t. )

Return nil

//--------------------------------------------------------------------------//

Static Function InitMainTactilWindow()

   SelCajTactil( , .t. )

   TpvTactil():New():Activate( .t. )

Return nil

//--------------------------------------------------------------------------//

Function CreateMainTpvWindow( oIconApp )

   DEFINE WINDOW oWnd ;
      FROM     0, 0 TO 26, 82;
      TITLE    __GSTTPV__ + " : " ;
      MDI ;
      ICON     oIconApp ;
      MENU     BuildTpvMenu()

   oWndBar                    := TpvCreateButtonBar( oWnd )
   oWndBar:CreateButtonBar( oWnd, .t., .t. )

   // Set the bar messages-----------------------------------------------------

   oWnd:Cargo                 := cParamsMain

   SET MESSAGE OF oWnd TO __GSTCOPYRIGHT__ NOINSET

   DEFINE MSGITEM oDlgProgress PROMPT ""                                         OF oWnd:oMsgBar SIZE 100

   oWnd:oMsgBar:oDate         := TMsgItem():New( oWnd:oMsgBar, Dtoc( GetSysDate() ), oWnd:oMsgBar:GetWidth( DToC( GetSysDate() ) ) + 12,,,, .t., { || SelSysDate() } )
   oWnd:oMsgBar:oDate:lTimer  := .t.
   oWnd:oMsgBar:oDate:bMsg    := { || GetSysDate() }
   oWnd:oMsgBar:CheckTimer()

   DEFINE MSGITEM oMsgUser    PROMPT "Usuario : "  + Rtrim( oUser():cNombre() )  OF oWnd:oMsgBar SIZE 200

   DEFINE MSGITEM oMsgCaja    PROMPT "Caja : "     + oUser():cCaja()             OF oWnd:oMsgBar SIZE 100

   DEFINE MSGITEM oMsgSesion  PROMPT ""                                          OF oWnd:oMsgBar SIZE 100

   // Abrimos la ventana

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT    ( WndPaint( hDC, oWnd, oBmp ) );
      ON INIT     ( lTpvInitCheck(), SelCajTactil( oWnd, .t. ), FrontTpv( "01063", oWnd, , , , .t. ) )

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
         oWnd:End()
      end if

      SysRefresh()

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

      if( !lIsDir( cPatDat() ),     MakeDir( cNamePath( cPatDat() ) ), )
      if( !lIsDir( cPatIn()  ),     MakeDir( cNamePath( cPatIn()  ) ), )
      if( !lIsDir( cPatTmp() ),     MakeDir( cNamePath( cPatTmp() ) ), )
      if( !lIsDir( cPatOut() ),     MakeDir( cNamePath( cPatOut() ) ), )
      if( !lIsDir( cPatSnd() ),     MakeDir( cNamePath( cPatSnd() ) ), )
      if( !lIsDir( cPatLog() ),     MakeDir( cNamePath( cPatLog() ) ), )
      if( !lIsDir( cPatBmp() ),     MakeDir( cNamePath( cPatBmp() ) ), )
      if( !lIsDir( cPatHtm() ),     MakeDir( cNamePath( cPatHtm() ) ), )
      if( !lIsDir( cPatSafe() ),    MakeDir( cNamePath( cPatSafe()) ), )
      if( !lIsDir( cPatPsion()),    MakeDir( cNamePath( cPatPsion())), )
      if( !lIsDir( cPatEmpTmp() ),  MakeDir( cNamePath( cPatEmpTmp() ) ), )

      // Borrar los ficheros de los directorios temporales------------------------

      oMsgText( 'Borrando ficheros temporales' )

      lRdDir( cPatTmp(), "*.*" )

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

      mkNewCount( cPatEmp() )

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
#ifdef __GST__
   oGrupo:nBigItems     := 4
#else
   oGrupo:nBigItems     := 3
#endif
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

#ifdef __GST__

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "Doctor_16"
   oItem:cBmpBig        := "Doctor_32"
   oItem:lShow          := .f.

#endif

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

STATIC FUNCTION lTPVInitCheck( lDir )

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

      if( !lIsDir( cPatDat() ),     MakeDir( cNamePath( cPatDat() ) ), )
      if( !lIsDir( cPatIn()  ),     MakeDir( cNamePath( cPatIn()  ) ), )
      if( !lIsDir( cPatTmp() ),     MakeDir( cNamePath( cPatTmp() ) ), )
      if( !lIsDir( cPatOut() ),     MakeDir( cNamePath( cPatOut() ) ), )
      if( !lIsDir( cPatSnd() ),     MakeDir( cNamePath( cPatSnd() ) ), )
      if( !lIsDir( cPatLog() ),     MakeDir( cNamePath( cPatLog() ) ), )
      if( !lIsDir( cPatBmp() ),     MakeDir( cNamePath( cPatBmp() ) ), )
      if( !lIsDir( cPatHtm() ),     MakeDir( cNamePath( cPatHtm() ) ), )
      if( !lIsDir( cPatSafe() ),    MakeDir( cNamePath( cPatSafe()) ), )
      if( !lIsDir( cPatPsion()),    MakeDir( cNamePath( cPatPsion())), )
      if( !lIsDir( cPatEmpTmp() ),  MakeDir( cNamePath( cPatEmpTmp() ) ), )

      // Borrar los ficheros de los directorios temporales------------------------

      oMsgText( 'Borrando ficheros temporales' )

      lRdDir( cPatTmp(), "*.*" )

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

      mkNewCount( cPatEmp() )

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
#ifdef __GST__
   oGrupo:nBigItems     := 6
#else
   oGrupo:nBigItems     := 7
#endif
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
#ifdef __GST__
   oGrupo:nBigItems     := 4
#else
   oGrupo:nBigItems     := 3
#endif
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

#ifdef __GST__

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "01095"
   oItem:cBmp           := "Doctor_16"
   oItem:cBmpBig        := "Doctor_32"
   oItem:lShow          := .f.

#endif

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

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//Comenzamos la parte que se compila para el ejecutacle de PDA

//--------------------------------------------------------------------------//

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

#pragma ENDDUMP

//--------------------------------------------------------------------------//

Function InitServices()

   if lAds()
      // ? "AdsOpenTables()"
      // AdsCacheOpenTables( 250 )
   end if

   // Colocamos los avisos pa las notas----------------------------------------

   if oUser():lAlerta()
      SetNotas()
   end if

   // Auto recepción de pedidos por internet-----------------------------------

   // SetAutoRecive()

   // SetAutoImp()

Return ( nil )

//---------------------------------------------------------------------------//

Function StopServices()

   // Informe rapido de articulos----------------------------------------------

   CloseInfoArticulo()

   // Quitamos los avisos pa las notas-----------------------------------------

   if oUser():lAlerta()
      CloseNotas()
   end if

   // Auto recepción de pedidos por internet-----------------------------------

   if lAds()

      // ? "AdsCloseCachedTables()"

      // AdsCloseCachedTables()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

#else

//---------------------------------------------------------------------------//

function Main()

   local oFont
   local oSayTit
   local oBtn        := Array( 19 )
   local oBtnTpv     := Array( 9 )

   SET DATE FORMAT   "dd/mm/yyyy"
   SET DELETED       ON
   SET EPOCH         TO 2000
   SET OPTIMIZE      ON
   SET EXACT         ON

   RddSetDefault( cLocalDriver() )

   /*
   Comprobaciones iniciales----------------------------------------------------
   */

   if pdalInitCheck()

      /*
      Una vez comprobado el usuario, montamos la ventana principal-------------
      */

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   /*
   Si estamos para versión Ventas
   */

#ifdef __PDAPRE__

      DEFINE DIALOG oWnd RESOURCE "MENU_PDA"

         REDEFINE SAY oSayTit ;
            ID       160 ;
            COLOR    "N/W*" ;
            FONT     oFont ;
            OF       oWnd

         REDEFINE BTNBMP oBtn[ 1 ] ;
            ID       100 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Mda_16.bmp" ) ;
            NOBORDER ;
            ACTION      ( nil )

         oBtn[ 1 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 6 ] ;
            ID       170 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Cubes_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaFamilia() )

         oBtn[ 6 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 7 ] ;
            ID       171 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Cube_yellow_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaArticulo() )

         oBtn[ 7 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 8 ] ;
            ID       172 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "ClipBoard_empty_user1_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaPedCli() )

         oBtn[ 8 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 9 ] ;
            ID       173 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Document_plain_user1_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaAlbCli() )

         oBtn[ 9 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 10 ] ;
            ID       174 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Document_user1_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaFacCli() )

         oBtn[ 10 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 11 ] ;
            ID       175 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "gear_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaConfig() )

         oBtn[ 11 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 12 ] ;
            ID       176 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "sync.bmp" ) ;
            NOBORDER ;
            ACTION   ( SincronizarDB() )

         oBtn[ 12 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 13 ] ;
            ID       177 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "recycle.bmp" ) ;
            NOBORDER ;
            ACTION   ( RegIndices() )

         oBtn[ 13 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 14 ] ;
            ID       178 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "user1_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaOrdenar() )

         oBtn[ 14 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 15 ] ;
            ID       179 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "money2.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaVentas() )

         oBtn[ 15 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 16 ] ;
            ID       180 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "moneybag_euro_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaLiquidaciones() )

         oBtn[ 16 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 17 ] ;
            ID       181 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Pencil_Package_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( PdaMovAlm() )

         oBtn[ 17 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 18 ] ;
            ID       182 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "folder_refresh_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( ActFicheros() )

         oBtn[ 18 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtn[ 19 ] ;
            ID       183 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "preferences_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaEstado() )

         oBtn[ 19 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      ACTIVATE DIALOG oWnd ;
         VALID       ( PdaEndPda( oWnd ) ) ;
         ON INIT     ( oWnd:SetMenu( PdaBuildMenu( oWnd ) ) )

#endif

   /*
   Si estamos para versión tpv
   */

#ifdef __PDATPV__

   DEFINE DIALOG oWnd RESOURCE "MENU_PDA_1"

         REDEFINE SAY oSayTit ;
            ID       160 ;
            COLOR    "N/W*" ;
            FONT     oFont ;
            OF       oWnd

         REDEFINE BTNBMP oBtnTpv[ 1 ] ;
            ID       100 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Mda_16.bmp" ) ;
            NOBORDER ;
            ACTION      ( nil )

         oBtnTpv[ 1 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 2 ] ;
            ID       170 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Cubes_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaFamilia() )

         oBtnTpv[ 2 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 3 ] ;
            ID       171 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "Cube_yellow_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaArticulo() )

         oBtnTpv[ 3 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 4 ] ;
            ID       175 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "gear_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaConfig() )

         oBtnTpv[ 4 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 5 ] ;
            ID       176 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "sync.bmp" ) ;
            NOBORDER ;
            ACTION   ( SincronizarDB() )

         oBtnTpv[ 5 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 9 ] ;
            ID       172 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "folder_refresh_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( ActFicheros() )

         oBtnTpv[ 9 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 6 ] ;
            ID       177 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "recycle.bmp" ) ;
            NOBORDER ;
            ACTION   ( RegIndices() )

         oBtnTpv[ 6 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 7 ] ;
            ID       182 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "cashier_user1_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaticket() )

         oBtnTpv[ 7 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP oBtnTpv[ 8 ] ;
            ID       178 ;
            OF       oWnd ;
            FILE     ( cPatBmp() + "user1_24.bmp" ) ;
            NOBORDER ;
            ACTION   ( pdaOrdenar() )

         oBtnTpv[ 8 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      if lInitTpv()
         oWnd:bStart := {|| pdaTicket() }
      end if

      ACTIVATE DIALOG oWnd ;
         VALID       ( PdaEndPda( oWnd ) ) ;
         ON INIT     ( oWnd:SetMenu( PdaBuildMenu( oWnd ) ) )

#endif
      oFont:End()

   end if

Return Nil

//---------------------------------------------------------------------------//

static function pdaAbout()

   local oDlf
   local aBtn     := Array ( 5 )
   local btnClose

   DEFINE DIALOG oDlg RESOURCE "Dlg_about"

         REDEFINE BTNBMP aBtn[1];
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "logo.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         aBtn[1]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP aBtn[2];
         ID       120 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "angel.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         aBtn[2]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP aBtn[3];
         ID       130 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "security_agent.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         aBtn[3]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP aBtn[4];
         ID       140 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "dude2.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         aBtn[4]:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE BTNBMP aBtn[5];
         ID       180 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "worker2.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         aBtn[5]:SetColor( 0, nRGB( 255, 255, 255 )  )

      ACTIVATE DIALOG oDlg ;
         ON INIT ( pdaMenuAbout( oDlg ) )

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuAbout( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 400 ;
      BITMAPS  50 ; // bitmaps resoruces ID
      IMAGES   1     // number of images in the bitmap

      REDEFINE MENUITEM ID 410 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//---------------------------------------------------------------------------//

static function PdaBuildMenu( oWnd )

   local oMenu

   DEFINE MENU oMenu RESOURCE 130 ;
      BITMAPS 30 ; // bitmap resources ID
      IMAGES 2     // number of images in the bitmap

      REDEFINE MENUITEM ID 140 OF oMenu ACTION ( pdaAbout() )

      REDEFINE MENUITEM ID 150 OF oMenu ACTION ( oWnd:End() )

Return oMenu

//---------------------------------------------------------------------------//

static function PdaEndPda( oWnd )

   lFreeUser()

return .t.

//---------------------------------------------------------------------------//

Function ErrorMessage()

Return ( "" )

//---------------------------------------------------------------------------//

Function PdalInitCheck()

   local lcheck := .f.
   local aFile
   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   CursorWait()

   // Comprobamos que existan todos los directorios----------------------------

   if( !lIsDir( cPatDat() ),  MakeDir( cNamePath( cPatDat() ) ), )

   if( !lIsDir( cPatBmp() ),  MakeDir( cNamePath( cPatBmp() ) ), )

   if !lIsDir( cPatTmp() )
      MakeDir( cNamePath( cPatTmp() ) )
   else
      aFile := Directory( cPatTmp() + "*.*" )
      AEval(aFile,{|aFile| FErase( cPatTmp() + aFile[ 1 ] ) } )
   end if

   if( !lIsDir( FullCurDir() + "EMP00\" ), MakeDir( cNamePath( FullCurDir() + "EMP00\" ) ), )

   if( !lIsDir( FullCurDir() + "GRP00\" ), MakeDir( cNamePath( FullCurDir() + "GRP00\" ) ), )

   if( !lIsDir( FullCurDir() + "USR\" ), MakeDir( cNamePath( FullCurDir() + "USR\" ) ), )

   if( !lIsDir( FullCurDir() + "TMP\" ), MakeDir( cNamePath( FullCurDir() + "TMP\" ) ), )

   CursorWait()

   // Comprobamos q exista al menos un usuario master--------------------------

   IF !File( cPatDat() + "USERS.DBF" )
		mkUsuario()
   END IF

   IF !File( cPatDat() + "USERS.CDX" )
      rxUsuario()
	END IF

   CursorWait()

   // Comprobamos que exista el usuario Master---------------------------------

   IsMaster()

   CursorWe()

   if pdalSelUsuario()

      // Comprobaciones iniciales de la empresa-----------------------------------

      //TstEmpresa()

      //CursorWait()

      // Seleccionamos la empresa-------------------------------------------------

      //SetEmpresa( , , , , , oWnd )

      cPatEmp( "00" )
      cPatGrp( "00" )
      cPatCli( "00" )
      cPatArt( "00" )

      // Comprobacion de almacen--------------------------------------------------

      IsAlmacen()

      CursorWait()

      // Seleccion de almacen-----------------------------------------------------

      /*if uFieldEmpresa( "lSelAlm" )
         SelectAlmacen()
      end if*/

      CursorWait()

      // Forma de pago------------------------------------------------------------

      IsFPago()

      CursorWait()

      // Comprobamos q exista al menos una divisa---------------------------------

      IsDiv()

      CursorWait()

      // Comprobamos q exista las tablas

      IsFamilia()

      CursorWait()

      IsArticulo()

      CursorWait()

      IsIva()

      CursorWait()

      IsClient()

      CursorWait()

      IsAgentes()

      CursorWait()

      IsRuta()

      CursorWait()

      IsCount()

      CursorWait()

      IsSitua()

      CursorWait()

      IsTipInci()

      CursorWait()

      IsPro()

      CursorWait()

      IsOferta()

      CursorWait()

      IsProvee()

      CursorWait()

      IsPedCli()

      CursorWait()

      IsAlbCli()

      CursorWait()

      IsFacCli()

      CursorWait()

      IsRecCli()

      CursorWait()

      IsAntCli()

      CursorWait()

      IsConfig()

      CursorWait()

      IsRemMov()

      CursorWait()

      IsTranspor()

      CursorWait()

      IsSalaVta()

      CursorWait()

      IsTblcnv()

      CursorWait()

      IsTMov()

      CursorWait()

      /*
      Configuración inicial de la PDA---------------------------------------------
      */

      LoadConfig()

      lCheck := .t.

   endif

   CursorWe()

   RECOVER USING oError

      lCheck        := .f.

      MsgInfo( "Necesita actualizar ficheros" )

      ActFicheros()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lCheck )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones comunes tanto para el ejecutable de pda como para el normal
//---------------------------------------------------------------------------//

Function oWnd() ; Return oWnd

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

Function cParamsMain()

Return ( cParamsMain )

//---------------------------------------------------------------------------//

#ifndef __PDA__

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

#endif

//---------------------------------------------------------------------------//

FUNCTION Test()

   ? "dbCreate"
   dbCreate( "Test.dbf", { { "nNum", "N", 10, 0 },;
                           { "nInc", "N", 10, 0, 8, 1 } },;
                           "DBFCDX" )

   ? "dbUseArea"
   dbUseArea( .t., cDriver(), "Test.dbf", "Test", .f. )

   if Test->( dbAppend() )
      Test->nNum := 1
      Test->( dbUnLock() )
   end if

   ? Test->nInc

   if Test->( dbAppend() )
      Test->nNum := 2
      Test->( dbUnLock() )
   end if

   ? Test->nInc

   if Test->( dbAppend() )
      Test->nNum := 3
      Test->( dbUnLock() )
   end if

   ? Test->nInc

   Test->( dbCloseArea() )

RETURN .t.

//--------------------------------------------------------------------------//
/*
#include "FastRepH.ch"

function Codiguito()

   local oFr

   RddSetDefault( 'DBFCDX' )

   dbUseArea( .t., "DBFCDX", "AUTOS.dbf", "AUTOS", .t. )
   AUTOS->( ordListAdd( "Autos.Cdx" ) )

   dbUseArea( .t., "DBFCDX", "D_PAGOS_AUTOS.dbf", "D_PAGOS_AUTOS", .t. )
   D_PAGOS_AUTOS->( ordListAdd( "D_PAGOS_AUTOS.Cdx" ) )

   oFr         := frReportManager():New()
   oFr:LoadLangRes( "spanish.xml" )
   oFr:SetIcon( 1 )
   oFr:SetTitle( "Imprimir Directorio clientes" )

   oFr:PreviewOptions:SetAllowEdit(.F.)

   oFr:SetWorkArea( "AUTOS", AUTOS->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )

   oFr:SetWorkArea( "D_PAGOS_AUTOS", D_PAGOS_AUTOS->( Select() ) )

   oFr:SetMasterDetail( "AUTOS", "D_PAGOS_AUTOS", {|| Autos->Poliza } )
   oFr:SetResyncPair( "AUTOS", "D_PAGOS_AUTOS" )

   oFr:LoadFromFile( "pagostotales.fr3"   )

   oFr:DesignReport()

   oFr:ClearDataSets()
   oFr:DestroyFr()

   dbCloseAll()

Return nil
*/