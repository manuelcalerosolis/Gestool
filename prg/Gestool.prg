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

   // local oCertificate   := SELCERT()

   // msgalert( hb_valtoexp( oCertificate ), valtype( oCertificate ) )

   FacturaeController():New():Run()


/*
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
   oDOMDocument:save( "c:\temp\andrew.xml" )

   oDOMDocument         := nil
*/

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <windows.h>

#define CRYPTUI_SELECT_LOCATION_COLUMN 0x000000010

//Definir el prototipo de las funciones:
typedef HCERTSTORE (WINAPI * PTYPECERTOPEN) (HCRYPTPROV, LPTSTR);
typedef PCCERT_CONTEXT (WINAPI * PTYPECERTSELECTDLG) (HCERTSTORE, HWND, LPCWSTR, LPCWSTR, DWORD, DWORD, void*);
typedef PCCERT_CONTEXT (WINAPI * PTYPECERTENUM) (HCERTSTORE, PCCERT_CONTEXT);
typedef DWORD (WINAPI * PTYPECERTGETNAME) (PCCERT_CONTEXT, DWORD, DWORD, VOID*, LPTSTR, DWORD);
typedef DWORD (WINAPI * PTYPECERTNAMETOSTR) (DWORD, PCERT_NAME_BLOB, DWORD, LPTSTR, DWORD);
typedef BOOL (WINAPI * PTYPECERTFREECC) (PCCERT_CONTEXT);
typedef BOOL (WINAPI * PTYPECERTCLOSESTORE) (HCERTSTORE, DWORD);

HB_FUNC(SELCERT)
{

   // Hay varios ejemplos en: https://msdn.microsoft.com/en-us/librar ... 61(v=vs.85).aspx

   HCERTSTORE hStore;
   PCCERT_CONTEXT PrevContext, CurContext;
   PCHAR sNombre;
   DWORD cbSize;
   PHB_ITEM pArray;
   PHB_ITEM pItem;
   PCCERT_CONTEXT   pCertContext;
   // Cargamos las librerías de las que queremos la dirección de las funciones.
   HMODULE HCrypt = LoadLibrary("Crypt32.dll");
   HMODULE HCrypt2 = LoadLibrary("Cryptui.dll");

   // Declaramos el tipo de puntero a la función, tenemos la definición arriba.
   PTYPECERTOPEN    pCertOpen;
   PTYPECERTSELECTDLG    pCertSelectDlg;
   PTYPECERTGETNAME pCertGetName;
   PTYPECERTNAMETOSTR pCertNameToStr;
   PTYPECERTFREECC pCertFreeCC;
   PTYPECERTCLOSESTORE pCertCloseStore;


   if (HCrypt != NULL && HCrypt2 != NULL){
      //Sacamos el puntero todas las funciones que vamos a usar mediante GetProcAddress:
      #ifdef UNICODE
         pCertOpen    = (PTYPECERTOPEN) GetProcAddress(HCrypt, "CertOpenSystemStoreW");
         pCertGetName = (PTYPECERTGETNAME) GetProcAddress(HCrypt, "CertGetNameStringW");
      #else
         pCertOpen    = (PTYPECERTOPEN) GetProcAddress(HCrypt, "CertOpenSystemStoreA");
         pCertGetName = (PTYPECERTGETNAME) GetProcAddress(HCrypt, "CertGetNameStringA");
      #endif
      pCertSelectDlg = (PTYPECERTSELECTDLG) GetProcAddress(HCrypt2, "CryptUIDlgSelectCertificateFromStore");
      pCertFreeCC  = (PTYPECERTFREECC) GetProcAddress(HCrypt, "CertFreeCertificateContext");
      pCertCloseStore  = (PTYPECERTCLOSESTORE) GetProcAddress(HCrypt, "CertCloseStore");
   }

   if (pCertOpen){
      // Llamada a CertOpenSystemStore:
      hStore = pCertOpen(NULL, TEXT("MY"));
   }

   if (hStore){
      // Diálogo de selección de certificado:
      pCertContext = pCertSelectDlg(hStore, NULL, NULL, NULL, CRYPTUI_SELECT_LOCATION_COLUMN, 0, NULL);

      if (pCertContext){
         cbSize = pCertGetName(pCertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, NULL, NULL, 0);
         if (cbSize>0) {
            //Reservamos la memoria que necesitamos para el texto que recibiremos
            sNombre = (LPTSTR)malloc(cbSize * sizeof(TCHAR));

            pCertGetName(pCertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, NULL, sNombre, cbSize);

            // Llamada a CertFreeCertificateContext:
            pCertFreeCC(pCertContext);
         }
      }

      // Cerrar el almacen de certificados:
      // Llamada a CertCloseStore:
      pCertCloseStore(hStore, 0);
    }

    FreeLibrary(HCrypt);
    FreeLibrary(HCrypt2);

    hb_retc(sNombre);

}

#pragma ENDDUMP

