//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSStatement                                                 //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de sentecias SQL en MySQL                            //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSStatement FROM TEagle1

    DATA oConnect               // Objeto conexion
    DATA lInit INIT .f.         // Indicador de inicializacion
    DATA cStatement INIT ""     // Sentencia SQL

    METHOD New( oDbCon, cStatement ) CONSTRUCTOR

    METHOD GetStatement()
    METHOD SetStatement( cStatement )

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cStatement ) CLASS TMSStatement

    local cType := upper( oDbCon:ClassName() )

    ::Init()

    BYNAME cStatement TYPE "C"

    if "CONNECT" $ cType
        ::oConnect := oDbCon
        ::lInit := .t.
    elseif cType == "TMSDATABASE"
        ::oConnect := oDbCon:oConnect
        ::lInit := .t.
    else
        ::oError:Say( "1 Parámetro no es un objeto válido", .f. )
        ::lInit := .f.
    endif

    if ::lInit // Aqui se establece el gestor de errores en la clase
        ::oError:New( ::oConnect:hConnect, ::oConnect:oError:lAutoError )
    endif

    ::SetIName( "Statement" )

return( Self )

//---------------------------------------------------------------------------//
// Obtiene la sentencia

METHOD GetStatement() CLASS TMSStatement
return( ::cStatement )

//---------------------------------------------------------------------------//
// Asigna la nueva sentencia y de vuelve la anterior

METHOD SetStatement( cStatement ) CLASS TMSStatement

    local cStmtOld := ::cStatement

    BYNAME cStatement TYPE "C"

return( cStmtOld )

//---------------------------------------------------------------------------//



