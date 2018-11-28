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

   // Administracion SQL-------------------------------------------------------

   if ( "ADMINSQL" $ appParamsMain() ) 

      getSQLDatabase():ConnectWithoutDataBase()

      if AccessController():New( .f. ):isLoginSuperAdmin()
         CreateAdminSQLWindow()
      end if

      RETURN ( nil )

   end if 

   // Conexión con MySQL------------------------------------------------------

   if !( getSQLDatabase():Connect() )
      msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )
      RETURN ( nil )
   end if 

   if ( "TEST" $ appParamsMain() ) 
   
      testMain()

   else

      if AccessController():isLogin()
         CreateMainSQLWindow()
      end if

   end if 

   getSQLDatabase():Disconnect() 

   destroyIconApp()

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION appTest()

   local oRootElement
   local oMemberElement
   local oMemberAttribute
   local oMemberName   
   local oDOMDocument   := CreateObject( "MSXML2.DOMDocument.6.0" )
   
   oRootElement         := oDOMDocument:createElement("Familia")
   oDOMDocument:appendChild( oRootElement )
   
   oMemberElement       := oDOMDocument:createElement("Miembro")
   oRootElement:appendChild( oMemberElement )
   
   //' Creates Attribute to the Member Element
   oMemberAttribute     := oDOMDocument:createAttribute("Relationship")
   oMemberAttribute:nodeValue    := "Padre"
   oMemberElement:setAttributeNode( oMemberAttribute )
   
   // Create element under Member element, and
   // gives value "some guy"
   oMemberName          := oDOMDocument:createCDATASection("<Name>")
   oMemberElement:appendChild( oMemberName )
   oMemberName:Text     := "Some Guy"

   //' Saves XML data to disk:
   oDOMDocument:save ("c:\temp\andrew.xml")

   oDOMDocument         := nil

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

FUNCTION testMain()

   local hEmpresa := SQLEmpresasModel():getWhereCodigo( '0001' ) 
   
   if empty( hEmpresa )
      msgStop( "No se ha podido seleccionar la empresa de pruebas" )
      RETURN ( .f. )
   end if  

   Company( hEmpresa )

   hbunit_test()

RETURN ( .f. )

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
