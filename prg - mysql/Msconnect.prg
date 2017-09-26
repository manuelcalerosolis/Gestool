//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSConnect                                                   //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de conexiones C/S en MySQL                           //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSConnect FROM TMSVConnect

    DATA nPort          // Puerto
    DATA cUnixSocket    // Enchufe para servidores en Unix/Linux

    //-------------------------------------------------------------------

    METHOD Init()
    METHOD Connect( cHost, cUser, cPasswd, cDbName, nPort, cUnixSocket, nClientFlag )
    METHOD ReConnect()
    METHOD RefreshVar()
    METHOD Free()

    METHOD SetSSL( cKey, cCert, cCa, cCaPem, cCipher )
/*
    METHOD GetSSLCipher()
*/

ENDCLASS

//---------------------------------------------------------------------------//
// Inicia variables de instancia

METHOD Init() CLASS TMSConnect

    Super:Init()

    ::hConnect := E1Init()

    if ::lInit := !( ::hConnect == 0 )
        ::oError:New( ::hConnect )
    else
        ::oError:Say( "No se puede iniciar la estructura en MySQL", .f. )
    endif

    ::cHost := ""
    ::cUser := ""
    ::cPasswd := ""
    ::nPort := 0
    ::cUnixSocket := ""
    ::lClientServer := .t.

    ::SetIName( "Connect" )

return( Self )

//---------------------------------------------------------------------------//
// Abre la conexion con los parametros especificados

METHOD Connect( cHost, cUser, cPasswd, cDbName, nPort, ;
                cUnixSocket, nClientFlag ) CLASS TMSConnect

    if ::lConnected := ( ::lInit .and. ;
                       E1RealConnect( ::hConnect, cHost, cUser, cPasswd, ;
                                      cDbName, nPort, cUnixSocket, nClientFlag ) )
        if ValType( cDbName ) == "C"
            ::oDataBase := TMSDataBase():New( Self, cDbName )
        endif
        ::RefreshVar()
    else
        ::oError:Show()
    endif

return( ::lConnected )

//---------------------------------------------------------------------------//
// Reabre la conexion con los parametros anteriores

METHOD ReConnect() CLASS TMSConnect

    local cHost := if( !empty( ::cHost ), ::cHost, nil )
    local cUser := if( !empty( ::cUser ), ::cUser, nil )
    local cPasswd := if( !empty( ::cPasswd ), ::cPasswd, nil )
    local nPort := if( !empty( ::nPort ), ::nPort, nil )
    local cUnixSocket := if( !empty( ::cUnixSocket ), ::cUnixSocket, nil )
    local nClientFlag := if( !empty( ::nClientFlag ), ::nClientFlag, nil )
    local cDbName := ::oDataBase:cName

    ::Free()

return( ::New():Connect( cHost, cUser, cPasswd, ;
                         cDbName, nPort, cUnixSocket, nClientFlag ) )

//---------------------------------------------------------------------------//
// Actualiza las DATAs de la clase, por si se han hecho cambios desde fuera
// de la clase

METHOD RefreshVar() CLASS TMSConnect

    ::nPort := E1Port( ::hConnect )
    ::nClientFlag := E1ClientFlag( ::hConnect )
    ::cHost := E1Host( ::hConnect )
    ::cUser := E1User( ::hConnect )
    ::cPasswd := E1Passwd( ::hConnect )
    ::cUnixSocket := E1UnixSocket( ::hConnect )

return( Self )

//---------------------------------------------------------------------------//
// Cierra la conexion y libera memoria  ( destruye el objeto )

PROCEDURE Free() CLASS TMSConnect

    ::cHost := nil
    ::cUser := nil
    ::cPasswd := nil

    ::nPort := 0
    ::cUnixSocket := nil

    Super:Free()

return

//---------------------------------------------------------------------------//
// Se usa para establecer conexiones seguras usando SSL.
// Debe ser llamada antes del método Connect(). No hace nada a no ser que el
// soporte OpenSSL esté activo en la librería del cliente.
//
// Parámetros:
// cKey     ruta al archivo de la clave.
// cCert    ruta al archivo de certificado.
// cCa      ruta al archivo de certificado de autoridad.
// cCaPem   ruta a un directorio con certificados SSL CA en formato PEM.
// cCipher  lista de claves disponibles para usar para encriptado SSL.

METHOD SetSSL( cKey, cCert, cCa, cCaPem, cCipher ) CLASS TMSConnect
return( E1SetSSL( ::hConnect, cKey, cCert, cCa, cCaPem, cCipher ) )

//---------------------------------------------------------------------------//
// Devuelve el código cifrado de una conexión SSL.
/*
METHOD GetSSLCipher() CLASS TMSConnect
return( E1GetSSLCipher( ::hConnect ) )
*/
//---------------------------------------------------------------------------//

