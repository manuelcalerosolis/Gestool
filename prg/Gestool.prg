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
#include "hdo.ch"

#require "hbcurl"

#define GR_GDIOBJECTS         0
#define GR_USEROBJECTS        1   

#define CS_DBLCLKS            8

#define HKEY_LOCAL_MACHINE    2147483650

#define FONT_NAME             "Segoe UI" 

static hDLLRich

//---------------------------------------------------------------------------//

PROCEDURE RddInit()

   ANNOUNCE RDDSYS

   REQUEST DBFCDX
   REQUEST DBFFPT
   REQUEST ADS

   REQUEST RDLMYSQL 

   REQUEST OrdKeyCount
   REQUEST OrdKeyNo
   REQUEST OrdKeyGoto

   REQUEST AdsKeyNo
   REQUEST AdsKeyCount
   REQUEST AdsGetRelKeyPos 
   REQUEST AdsSetRelKeyPos

RETURN

//---------------------------------------------------------------------------//

INIT PROCEDURE InitAplication()

   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   hb_langselect( "ES" )      // Para mensajes, fechas, etc..
   hb_setcodepage( "ESWIN" )  // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

   loadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit
   
   setResDebug( .t. )

RETURN

//---------------------------------------------------------------------------//

EXIT PROCEDURE ExitAplication()

   // Informe de perdida de recursos-------------------------------------------

   freeResources()

   hb_gcall( .t. )

   __mvClear()

   if file( "checkres.txt" )
      ferase( "checkres.txt" )
   endif

   checkRes()

   winExec( "notepad checkres.txt" )

RETURN

//---------------------------------------------------------------------------//

FUNCTION Main( paramsMain, paramsSecond, paramsThird )

   local oIndex
   local oIconApp

   appParamsMain( paramsMain )

   appParamsSecond( paramsSecond )
   
   appParamsThird( paramsThird )

   appSettings()
   
   appDialogExtend() 

   appLoadAds()

   xbrNumFormat( "E", .t. )

   // Administracion SQL-------------------------------------------------------

   if ( "ADMINSQL" $ appParamsMain() ) 

      getSQLDatabase():ConnectWithoutDataBase()

      SQLGestoolMigrations():Run()

      SQLGestoolSeeders():Run()
         
      if AccessController():New( .f. ):isLoginSuperAdmin()
         CreateAdminSQLWindow( oIconApp )
      end if

      RETURN ( nil )

   end if 

   // Motor de bases de datos--------------------------------------------------

   if ( "ADMINISTRADOR" $ appParamsMain() )
      TDataCenter():lAdministratorTask()
      RETURN ( nil )
   end if

   // Conexión con MySql------------------------------------------------------

   if !( getSQLDatabase():Connect() )
      msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )
      RETURN ( nil )
   end if 

   // Motor de bases de datos--------------------------------------------------

   if !( appConnectADS() ) 
      msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
      RETURN ( nil )
   end if

   TDataCenter():BuildData()

   mainTest()

   // Icono--------------------------------------------------------------------

   DEFINE ICON oIconApp RESOURCE "Gestool"

   // Opciones especiales de arranque hace la operacion y salir----------------

   do case
      case ( "ENVIO" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

         if lInitCheck()
            TSndRecInf():Init():AutoExecute()
         end if

         RETURN ( nil )

      case ( "REINDEXA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

         if lInitCheck()
            oIndex               := TReindex():New()
            oIndex:lMessageEnd   := .f.
            oIndex:Resource( .t. )
         end if

         RETURN ( nil )

      case ( "EMPRESA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

      case ( !empty( appParamsMain() ) .and. !empty( appParamsSecond() ) .and. !empty( appParamsThird() ) )

         Auth():guardWhereUuid( appParamsMain() )

         setEmpresa( appParamsSecond() )

         ApplicationLoad()

         controllerReportGallery( appParamsThird() )

         RETURN ( nil )

   end case

   // Obtenemos la versión del programa----------------------------------------

   IsStandard()
   IsProfesional()
   IsOsCommerce()

   cNameVersion()

   // Chequeamos los datos de los usuarios-------------------------------------

   if !TReindex():lFreeHandle()
      msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicación" + CRLF + ;
               "en estos momentos, reintentelo pasados unos segundos." )
      RETURN .f.
   end if

   do case
      case ( "SQL" $ appParamsMain() ) 

         if AccessController():New():isLogin()
            CreateMainSQLWindow( oIconApp )
         end if

      otherwise

         if AccessController():New():isLogin()
            CreateMainWindow( oIconApp )
         end if

   end case

   // Destruimos el icono -----------------------------------------------------

   if !empty( oIconApp )
      oIconApp:Destroy()
   end if

   // Conexión con SQL---------------------------------------------------------

   getSQLDatabase():Disconnect() 

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION controllerReportGallery( cInitOptions )

   local hReportGallery    

   do case
      case upper( cInitOptions ) == "ARTICULOS"

         if validRunReport( "reporting_articulos" )
            TFastVentasArticulos():New():Play()
         endif

      case upper( cInitOptions ) == "CLIENTES"

         if validRunReport( "reporting_clientes" )
            TFastVentasClientes():New():Play()
         endif

      case upper( cInitOptions ) == "PROVEEDORES"

         if validRunReport( "reporting_proveedores" )
            TFastComprasProveedores():New():Play()
         end if 

      case upper( cInitOptions ) == "PRODUCCION"

         if validRunReport( "reporting_produccion" )
            TFastProduccion():New():Play()
         end if 

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION HelpTopic()

   msgStop( "Help wanted!" )

RETURN ( Nil )

//----------------------------------------------------------------------------//

FUNCTION HelpIndex()

   goWeb( __GSTHELP__ )

RETURN ( Nil )

//----------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function mainTest()

   // ? hb_MD5( "12345678" )

Return ( nil )

//---------------------------------------------------------------------------//

