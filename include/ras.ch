// include file for tRas

#define RAS_MSGS        {;
        {4096,"PAUSA"} ,;                           // RASCS_PAUSED = &H1000
        {8192,"Conectado correctamente"},;          // RASCS_DONE = &H2000
        {0,"Abriendo puerto de comunicaciones"},;   // RASCS_OpenPort
        {1,"Puerto abierto correctamente"},;        // RASCS_PortOpened
        {2,"Conectando con el dispositivo"},;       // RASCS_ConnectDevice
        {3,"Dispositivo conectado"},;               // RASCS_DeviceConnected
        {4,"Todos los dispositivos conectados"},;   // RASCS_AllDevicesConnected
        {5,"Verificando Nombre y Contraseña"},;     // RASCS_Authenticate
        {6,"Nombre y Contraseña correctos"},;       // RASCS_AuthNotify
        {7,"Reintentando confirmación de identidad"},; // RASCS_AuthRetry
        {8,"Autentificación mediante retorno de llamada"},; // RASCS_AuthCallback =
        {9,"Obligación de cambiar la contraseña"},; // RASCS_AuthChangePassword
        {10,"RASCS_AuthProject"},;                  // RASCS_AuthProject
        {11,"Verificando velocidad de conexión"},;  // RASCS_AuthLinkSpeed
        {12,"Verificando autentificación de conexión"},; // RASCS_AuthAck
        {13,"Repitiendo autentificación"},;         // RASCS_ReAuthenticate
        {14,"Autentificado"} ,;                     // RASCS_Authenticated
        {15,"Preparando para retorno de llamada"} ,;// RASCS_PrepareForCallback
        {16,"Esperando inicialización del modem"},; // RASCS_WaitForModemReset
        {17,"Esperando retorno de llamda"},;        // RASCS_WaitForCallback
        {4097,"Reintentando autentificación"} ,;   // RASCS_RetryAuthentication = RASCS_PAUSED + 1
        {4098,"Retorno de llamada pedido por el llamante"},; // RASCS_CallbackSetByCaller = RASCS_PAUSED + 2
        {4099,"La contraseña ha expirado"},;     // RASCS_PasswordExpired = RASCS_PAUSED + 3
        {8193,"Ha sido desconectado"}; // RASCS_Disconnected = RASCS_DONE + 1
            }

#define ERR_NOWIN "ERROR:Necesita una ventana"
#define ERR_NOPHONE "ERROR:Sin Numero de Telefono"
#define ERR_NOPASS "ERROR:Sin Password"
#define ERR_NOUSER "ERROR:Necesario un Usuario"


#xcommand Dialer <oDial> of <oWnd> => <oDial> := tRas():New( <oWnd> )




#xCommand DIAL USING <oDial> ;
                [ ENTRY <cEntry> ] ;
                [ PHONE <cPhone> ] ;
                [ PASSWORD <cPass> ] ;
                [ USER <cUser> ] ;
                [ BITMAPS <aBitMaps> ];
                [ <lFromUser:SELECT> ];
                [ <lAuto:AUTODIAL> ];
                [ ACTION <bStatus> ];
                [ <lDialog:DIALOG> ] => <oDial>:Call( <.lAuto.> ,<cPhone>, <cUser>,;
                         <cPass>, <cEntry>, <.lFromUser.>, <aBitMaps> ,;
                         <{bStatus}>, <.lDialog.> )

