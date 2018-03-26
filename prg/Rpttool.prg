#include "Fivewin.ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Ads.ch"

ANNOUNCE RDDSYS

REQUEST ADS
REQUEST DBFCDX
REQUEST DBFFPT

REQUEST AdsKeyNo
REQUEST AdsKeyCount
REQUEST AdsGetRelKeyPos 
REQUEST AdsSetRelKeyPos

//---------------------------------------------------------------------------//

Function Main( cCodEmp, cCodUsr, cInitOptions )

   local nError
   local cError

   DEFAULT cCodEmp   := alltrim( str( year( date() ) ) )
   DEFAULT cCodUsr   := "000"

   appSettings()

   // Modificaciones de las clases de fw---------------------------------------

   appDialogExtend() 

   // Chequeamos la existencia del fichero de configuracion--------------------

   appLoadAds()

   // Motor de bases de datos--------------------------------------------------
 
   if !( appConnectADS() )
      msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
      Return nil
   end if
      
   TDataCenter():BuildData()

   // Seleccionamos el usuario-------------------------------------------------

   oUser( cCodUsr )

   // Ponemos el directorio para los ficheros----------------------------------

   cPatEmp( cCodEmp )
   cPatEmp( cCodEmp, nil, .t. )
   cPatEmp( cCodEmp, nil, .t. )
   cPatEmp( cCodEmp, nil, .t. )
   cPatEmp( cCodEmp, nil, .t. )

   // Seleccionamos la empresa-------------------------------------------------

   cCodigoEmpresaEnUso( cCodEmp )

   aEmpresa( cCodEmp )

   // Cargamos la estructura de ficheros de la empresa-------------------------

   TDataCenter():BuildEmpresa()

   // Apertura de ventana------------------------------------------------------

   controllerReportGallery( cInitOptions )

Return nil

//---------------------------------------------------------------------------//

Static Function controllerReportGallery( cInitOptions )

Return nil

//---------------------------------------------------------------------------//

init procedure RddInit()

   REQUEST DBFCDX
   REQUEST DBFFPT

   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   hb_langselect("ES")        // Para mensajes, fechas, etc..
   hb_setcodepage("ESWIN")    // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

return

//------------------------------------------------------------------//

#pragma BEGINDUMP

#include <C:\bcc582\Include\windows.h>
#include <C:\bcc582\Include\winuser.h>
#include <C:\bcc582\Include\wingdi.h>
#include "hbapi.h"

HB_FUNC( SETWINDOWRGN )
{
   hb_retni( SetWindowRgn( ( HWND ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ), hb_parl( 3 ) ) );
}

#pragma ENDDUMP

//------------------------------------------------------------------//