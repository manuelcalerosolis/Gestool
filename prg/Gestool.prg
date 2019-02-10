#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch" 
#include "Font.ch"
#include "Inkey.ch"
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
static oIconApp
static nSeconds               := 0

//---------------------------------------------------------------------------//

PROCEDURE RddInit()

   ANNOUNCE RDDSYS

   REQUEST DBFCDX
   REQUEST DBFFPT

   REQUEST RDLMYSQL 

   REQUEST OrdKeyCount
   REQUEST OrdKeyNo
   REQUEST OrdKeyGoto

RETURN

//---------------------------------------------------------------------------//

INIT PROCEDURE InitAplication()

   REQUEST HB_LANG_ES            // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN     // Para establecer código de página a Español (Ordenación, etc..)

   hb_langselect( "ES" )         // Para mensajes, fechas, etc..
   hb_setcodepage( "ESWIN" )     // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

   loadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit
   
   setResDebug( .t. )

RETURN

//---------------------------------------------------------------------------//

EXIT PROCEDURE ExitAplication()

   // writeResources()

RETURN

//---------------------------------------------------------------------------//

FUNCTION Main( paramsMain, paramsSecond, paramsThird )

   appParamsMain( paramsMain )

   appParamsSecond( paramsSecond )
   
   appParamsThird( paramsThird )

   appTest()

   appSettings()
   
   appDialogExtend() 

   appCheckDirectory()

   xbrNumFormat( "E", .t. )

   do case
      case ( "ADMINSQL" $ appParamsMain() ) 
         mainAdminSQL()

      case ( "TEST" $ appParamsMain() ) 
         mainTest()

      otherwise
         mainApplication()

   end case

   destroyIconApp()

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION mainAdminSQL()

   getSQLDatabase():ConnectWithoutDataBase()

   if AccessController():New():isLoginSuperAdmin()

      SQLGestoolMigrations():messageRun()

      CreateAdminSQLWindow()
   
   end if

   getSQLDatabase():Disconnect() 

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION MainTest()

   local hEmpresa 

   if !( getSQLDatabase():Connect() )
      msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )
      RETURN ( nil )
   end if 

   hEmpresa          := SQLEmpresasModel():getWhereCodigo( '0001' ) 
   
   if empty( hEmpresa )
      msgStop( "No se ha podido seleccionar la empresa de pruebas" )
      RETURN ( nil )
   end if  

   Company( hEmpresa )

   hbunit_test()

   getSQLDatabase():Disconnect() 

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION mainApplication()

   if !( getSQLDatabase():Connect() )
      msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )
      RETURN ( nil )
   end if 

   if AccessController():isLogin()
      CreateMainSQLWindow()
   end if 

   getSQLDatabase():Disconnect() 

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION appTest()

   ConversorAlbaranVentasView():Activate()

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION HelpTopic()

   msgStop( "Help wanted!" )

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION HelpIndex()

   goWeb( __GSTHELP__ )

RETURN ( nil )

//----------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION logwriteSeconds( cText )

   logwrite( cText + " -> " + str( seconds() - nSeconds ) )

   nSeconds := seconds()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION getIconApp()

   if empty( oIconApp )
      oIconApp    := TIcon():New( , , "Gestool" )
   end if 

RETURN ( oIconApp )

//---------------------------------------------------------------------------//

FUNCTION destroyIconApp()

   if !empty( oIconApp )
      oIconApp:Destroy()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
