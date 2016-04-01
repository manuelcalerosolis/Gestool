//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSError                                                     //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de errores en MySQL                                  //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSError FROM TSQLVirtual  

    DATA nHandle        // Manejador de la conexion o base de datos
    DATA lAutoError     // Gestion automatica de errores del sistema

    METHOD New( nHandle, lAutoError ) CONSTRUCTOR
    METHOD Init()

    METHOD Say( cError, lAuto )
    METHOD Show( lAllways, cDefault )

    METHOD IsError()
    METHOD GetError()
    METHOD GetErrNo()
    METHOD GetState()

    METHOD SetAutoError( lOnOff )
    METHOD SetHandler( nHandle )

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( nHandle, lAutoError ) CLASS TMSError

    ::Init()

    ::SetHandler( nHandle )
    ::SetAutoError( lAutoError )

return( Self )

//---------------------------------------------------------------------------//
// Inicia variables del objeto

METHOD Init() CLASS TMSError

    ::nHandle := 0
    ::lAutoError := .t.
    ::SetIName( "TERROR" )

return( Self )

//---------------------------------------------------------------------------//
// Muestra la cadena "cError" pasada con el sistema de errores de Eagle1 y
// "lAuto" valor lógico para tener en cuenta el estado de "lAutoError".
// Estos errores no son probocados directamente por MySQL si no por la
// auto gestión de la clase. Además se puede usar por los programadores para
// mensajes usando el sistema de errores de la clase

METHOD Say( cMsg, lAuto ) CLASS TMSError

    DEFAULT lAuto := .f. TYPE "L"

    if !lAuto .or. ( lAuto .and. ::lAutoError )
        msgStop( cMsg, "Eagle1 - Atención", 1 )
    endif

return( Self )

//---------------------------------------------------------------------------//
// Muestra el mensaje de error, si se pasa TRUE muestra un mensaje.
// Siempre se tiene en cuanta el sistema de autoerror con lAutoError.

METHOD Show( lAllways, cDefault ) CLASS TMSError

    local lDisp, cError

    if ::lAutoError

        DEFAULT lAllways := .f. TYPE "L"

        if lDisp := ::IsError()
            cError := ::GetError()
            if empty( cError ) .and. ValType( cDefault ) == "C"
                cError := cDefault
            endif
        else
            cError := "No error"
        endif

        if ( lAllways .or. lDisp )
            msgStop( cError, "Eagle1 Class - ERROR " + StrNum( ::GetErrNo() ), 1 )
        endif
    endif

return( Self )

//---------------------------------------------------------------------------//
// Comprueba si ha habido algun error en la ultima sentencia

METHOD IsError() CLASS TMSError
return( E1IsError( ::nHandle ) )

//---------------------------------------------------------------------------//
// Obtiene el literal del ultimo error

METHOD GetError() CLASS TMSError
return( E1Error( ::nHandle ) )

//---------------------------------------------------------------------------//
// Obtiene el numero del ultimo error

METHOD GetErrNo() CLASS TMSError
return( E1ErrNo( ::nHandle ) )

//---------------------------------------------------------------------------//
// Obtiene el literal con estado actual

METHOD GetState() CLASS TMSError
return( E1State( ::nHandle ) )

//---------------------------------------------------------------------------//
// Activa o desactiva el control automatico de errores

METHOD SetAutoError( lAutoError ) CLASS TMSError

    local lActiveOld := ::lAutoError

    BYNAME lAutoError TYPE "L"

return( lActiveOld )

//---------------------------------------------------------------------------//
// Asigna el manejador para el control de los errores

METHOD SetHandler( nHandle ) CLASS TMSError

    local nHandleOld := ::nHandle

    BYNAME nHandle TYPE "N"

return( nHandleOld )

//---------------------------------------------------------------------------//

