//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TStoreProc                                                   //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de prodimientos almacenados en MySQL                 //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TStoredProc FROM TEagle1

    DATA cName
    DATA oConnect   // Objeto conexion
    DATA aParams INIT {}                        // <------------------------ pner en init estos dos
    DATA nParamCount INIT 0                     // <

    METHOD New( oDbCon ) CONSTRUCTOR
    METHOD Call()

    //---------------------------------------------------
    // Gestion de parametros de entrada
    METHOD CreateParams( nPCount )
    METHOD AddParam( uVal )
    METHOD DelParam( n )
    METHOD SetParam( nParam, uVal )
    METHOD GetParam( nParam )
    METHOD GetParamCount()
    METHOD SetParamCount()
    METHOD ShowCreate( nType )

    //--------------------------------------------------
    // Funcion almacenadas
    METHOD GetResults()
    METHOD Select()


ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon ) CLASS TStoredProc

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

    if ::lInit
        ::oError:New( ::oConnect:hConnect, ::oConnect:oError:lAutoError )
    endif

    ::SetIName( "VStrPrcFunc" )

return( Self )

//---------------------------------------------------------------------------//
// Ejecuta la llamada al procediento almacenado.
// Previamente se han tenido que actualizar los parametros

METHOD Call() CLASS TStoredProc

    local i, n := len( ::aParams )
    local uParam, cParam
    local cStmt := "CALL " + ::cName

    if n > 0
        cStmt += "( "
        for i := 1 to n
            uParam := ::GetParam( n )
            if ValType( uParam ) != "C"
                cParam := transform( uParam, "@" )
                cStmt += cParam + ", "
            else
                cStmt += "'" + cParam + "', "
            endif
        next
        cStmt := ChgAtEnd( cStmt, ' )', 2 )
    else
        cStmt += "()"
    endif

return( ::Execute( cStmt ) )

//---------------------------------------------------------------------------//
// Devuelve una cadena con la sentencia de creacion del procedimiento o
// funcion almacenados

METHOD ShowCreate( nType ) CLASS TStoredProc

    local cRet, oQry, cType

    SWITCH nType
        CASE 0
            cType := "PROCEDURE"
            EXIT

        CASE 1
            cType := "FUNCTION"
            EXIT
        DEFAULT
            cType := "PROCEDURE"
    END

    oQry := TMSQuery():New( ::oConnect, "SHOW CREATE " + cType + " " + ::cName )

    oQry:Open()

    cRet := oQry:FieldGet( 2 )

    oQry:Free()

return( cRet )

//---------------------------------------------------------------------------//
// Trata el array de parametros para poner el numero de elementos indicado
// y actualiza el contador de parametros

METHOD CreateParams( nPCount ) CLASS TStoredProc

    if ValType( nPCount ) == "N" .and. nPCount > 0
        ::nParamCount := nPCount
    endif

    ASize( ::aParams, ::nParamCount )

return( Self )

//---------------------------------------------------------------------------//
// Añade un parametro nuevo e incrementa el contador de parametros

METHOD AddParam( uVal ) CLASS TStoredProc

    ::nParamCount++

return( AAdd( ::aParams, uVal ) )

//---------------------------------------------------------------------------//
// Elimina el parametro de la posición n y recalcula el array y el contador
// de parametros

METHOD DelParam( n ) CLASS TStoredProc

    if ValType( n ) == "N" .and. n > 0 .and. n <= ::nParamCount
        ADel( ::aParams, n )
        ASize( --::nParamCount )
    endif

return( ::aParams )

//---------------------------------------------------------------------------//
// Asigna el valor "uVal" en el parametro "nParam"

METHOD SetParam( nParam, uVal ) CLASS TStoredProc

    local uValOld := ::aParams[ nParam ]

    if nParam > 0 .and. nParam <= ::nParamCount .and. !( uVal == nil )
        ::aParams[ nParam ] := uVal
    endif

return( uValOld )

//---------------------------------------------------------------------------//
// Obtiene el valor del parametro "nParam"

METHOD GetParam( nParam ) CLASS TStoredProc

    local uRet

    if nParam > 0 .and. nParam <= ::nParamCount
        uRet := ::aParams[ nParam ]
    endif

return( uRet )

//---------------------------------------------------------------------------//
// Obtiene el numero de parametros

METHOD GetParamCount() CLASS TStoredProc
return( ::nParamCount )

//---------------------------------------------------------------------------//
// Asigna el numero de parametros. Ojo amplia o disminuye el array aParams
// por lo que se pueden perder valores o añadir nuevos nulos

METHOD SetParamCount( nParams ) CLASS TStoredProc

    local nOldParams := ::nParamCount

    if ValType( nParams ) == "N" .and. ::nParamCount != nParams
        ::nParamCount := nParams
        ASize( ::aParams )
    endif

return( nOldParams )

//---------------------------------------------------------------------------//
// Funciones almacenadas
//---------------------------------------------------------------------------//
// Devuelve los valores de los parametros de salida
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

METHOD GetResults() CLASS TStoredProc
return( aResults )

//---------------------------------------------------------------------------//
// Devuelve un conjunto de datos si es posible
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
METHOD Select() CLASS TStoredProc

    local i
    local uParam, cParam
    local cStmt := "SELECT " + ::cName

    if n > 0
        cStmt += "( "
        for i := 1 to n
            uParam := ::GetParam( n )
            if ValType( uParam ) != "C"
                cParam := transform( uParam, "@" )
                cStmt += cParam + ", "
            else
                cStmt += "'" + cParam + "', "
            endif
        next
        cStmt := ChgAtEnd( cStmt, ' )', 2 )
    else
        cStmt += "()"
    endif

return( ::oQuery:Open( cStmt ) )

//---------------------------------------------------------------------------//



