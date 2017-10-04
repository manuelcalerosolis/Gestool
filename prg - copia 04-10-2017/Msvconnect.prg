//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSVConnect                                                  //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Conexiones en MySQL. Clase madre datas y metodos comunes     //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSVConnect FROM TEagle1

    DATA hConnect               // Manejador de conexion

    DATA lInit                  // Indicador de inicializacion
    DATA lConnected             // Indicador de conexion
    DATA lClientServer          // Indicador de entorno cliente/servidor
    DATA nClientFlag            // Bandera
    DATA oDataBase              // Objeto base de datos por defecto

    // Estas datas son obligatorias en el sistema cliente/servidor pero se
    // pueden usar en sistemas embebidos tambien:
    DATA cHost                  // Servidor: IP o Nombre
    DATA cUser                  // Usuario
    DATA cPasswd                // Palabra de acceso

    METHOD New() CONSTRUCTOR
    METHOD Init()
    METHOD Free()
    METHOD Execute( cCmd )

    METHOD SetOption( nOption, cnOption )
    METHOD SetTimeOut( nSec )

    METHOD GetStat()
    METHOD Sleep()
    METHOD Ping()

    METHOD GetServerVersion()
    METHOD GetClientVersion()

    METHOD GetInsertId()

    METHOD EscapeStr( cStr )
/*
    METHOD SetCharacterSet( cCharSet )
*/

    METHOD SetMultiStatement( lMultiStmt )
    METHOD SetServerOption( nOption )

    // Devuelven objetos DataSet
    METHOD Table( cName, cWhere, cHaving, cOrderBy, nLimit )
    METHOD MyTable( cName, cWhere, cHaving, cOrderBy, nLimit )
    METHOD Query( cSQL )
    METHOD DBFCursor( cSQL )
    METHOD ACursor( cSQL )

    METHOD Command( cCmd )

    // Gestion de bases de datos en la conexion:
    METHOD CreateDataBase( cDbName, lIfNotExist, cCharSet, cCollate )
    METHOD DropDataBase( cDbName, lIfExist )
    METHOD AlterDataBase( cDbName, cCharSet, cCollate )
    METHOD ListDataBases()
    METHOD ListTables()
    METHOD ExistDataBase( cDbName )
    METHOD SelectDataBase( coDbName )
    METHOD DataBaseByName( cDbName, lDefault )
    METHOD DataBase( cDbName, lDefault )

    // Gestion de usuarios en la conexion:
    METHOD CreateUser( cUser, cPwd )
    METHOD DropUser( cUser )
    METHOD RenameUser( cOldUser, cNewUser )
    METHOD SetPassWord( cPwd, cUser )
    METHOD SetGlobalGrant( cUser, cDb, aPrivileges, cPwd )
    METHOD SetGlobalRevoke( cUser, cDb, aPrivileges )


    METHOD GetScalarQuery( cSQL )

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase. Solo llama a ::Init para reservar memoria

METHOD New() CLASS TMSVConnect

    ::Init()

return( Self )

//---------------------------------------------------------------------------//
// Inicia variables de instancia generales

METHOD Init() CLASS TMSVConnect

    Super:Init()

    ::lInit := .t.
    ::lConnected := .f.
    ::nClientFlag := 0

return( Self )

//---------------------------------------------------------------------------//
// Cierra la conexion y libera memoria  ( destruye el objeto )

PROCEDURE Free() CLASS TMSVConnect

    if !empty( ::oDataBase )
        ::oDataBase:Free()
    endif

    E1Close( ::hConnect )

    ::nClientFlag := 0
    ::lConnected := .f.
    ::lInit := .f.
    ::hConnect := 0

    Super:Free()

return

//---------------------------------------------------------------------------//
// Ejecuta sentencias SQL que no devuelven conjunto de datos

METHOD Execute( cCmd ) CLASS TMSVConnect
return( E1Execdirect( ::hConnect, cCmd ) )

//---------------------------------------------------------------------------//
// Establece opciones de la conexion, mirar MySQL.ch para verlas.
// Tiene que ejecutarse antes del metodo ::Connect()

METHOD SetOption( nOption, cnOption )
return( E1SetOption( ::hConnect, nOption, cnOption ) )

//---------------------------------------------------------------------------//
// Establece el tiempo de espera para una conexion.
// Tiene que ejecutarse antes del metodo ::Connect()

METHOD SetTimeOut( nSec ) CLASS TMSVConnect

    local lRet := ( ValType( nSec ) == "N" )

    if lRet
        lRet := E1ConnectTimeOut( ::hConnect, nSec )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Devuelve una cadena indicando el estado de la conexion

METHOD GetStat() CLASS TMSVConnect
return( E1Stat( ::hConnect ) )

//---------------------------------------------------------------------------//
// Cierra la conexion y libera memoria, pero no destruye el objeto

METHOD Sleep() CLASS TMSVConnect

    ::RefreshVar()

    E1Close( ::hConnect )

    ::lConnected := .f.
    ::lInit      := .f.
    ::hConnect   := 0

return( Self )

//---------------------------------------------------------------------------//
// Comprueba que la conexion, si no existe, intenta una nueva conexion con
// los mismos parametros

METHOD Ping() CLASS TMSVConnect

    if ::lConnected := E1Ping( ::hConnect )
        ::SelectDataBase( ::oDataBase:cName )
        ::RefreshVar()
    endif

return( ::lConnected )

//---------------------------------------------------------------------------//
// Obtiene la version del servidor MySQL

METHOD GetServerVersion() CLASS TMSVConnect

    local cVer

    if ::lConnected
        cVer := E1GetServerVersion( ::hConnect )
    else
        ::oError:Say( "Aún no está conectado al Servidor..." )
        cVer := ""
    endif

return( cVer )

//---------------------------------------------------------------------------//
// Obtiene la version del cliente MySQL

METHOD GetClientVersion() CLASS TMSVConnect

    local nVer

    if ::lConnected
        nVer := E1GetClientVersion( ::hConnect )
    else
        ::oError:Say( "Aún no está conectado al Servidor..." )
        nVer := 0
    endif

return( nVer )

//---------------------------------------------------------------------------//
// Devuelve el último valor de una columna autoincremental

METHOD GetInsertId() CLASS TMSVConnect
return( E1GetInsertId( ::hConnect ) )

//---------------------------------------------------------------------------//
// Filtra las secuencias de escape y las cadenas especiales

METHOD EscapeStr( cStr ) CLASS TMSVConnect
return( Alltrim( E1RealEscapeStr( ::hConnect, cStr ) ) )

//---------------------------------------------------------------------------//
// Seleccionar juego de caracteres

/*
METHOD SetCharacterSet( cCharSet ) CLASS TMSVConnect
return( E1SetCharacterSet( ::hConnect, cCharSet ) )
*/

//---------------------------------------------------------------------------//
// Activa o desactiva multisentencias para la conexión:

METHOD SetMultiStatement( lMultiStmt ) CLASS TMSVConnect
return( E1SetMultiStatement( ::hConnect, lMultiStmt ) )

//---------------------------------------------------------------------------//
// Activa o desactiva opciones para la conexión:

METHOD SetServerOption( nOption ) CLASS TMSVConnect
return( E1SetServerOption( ::hConnect, nOption ) )

//---------------------------------------------------------------------------//
// Devuelve un objetos MSTable

METHOD Table( cName, cWhere, cHaving, cOrderBy, nLimit ) CLASS TMSVConnect
return( ::oDataBase:Table( cName, cWhere, cHaving, cOrderBy, nLimit ) )

//---------------------------------------------------------------------------//
// Devuelve un objeto MyTable

METHOD MyTable( cName, cWhere, cHaving, cOrderBy, nLimit ) CLASS TMSVConnect
return( ::oDataBase:MyTable(  cName, cWhere, cHaving, cOrderBy, nLimit ) )

//---------------------------------------------------------------------------//
// Devuelve un objeto MSCommand

METHOD Command( cCmd ) CLASS TMSVConnect
return( TMSCommand():New( Self, cCmd ) )

//---------------------------------------------------------------------------//
// Devuelve un objeto MSQuery

METHOD Query( cSQL ) CLASS TMSVConnect
return( ::oDataBase:Query( cSQL ) )

//---------------------------------------------------------------------------//
// Devuelve un objeto MSDBFCursor

METHOD DBFCursor( cSQL ) CLASS TMSVConnect
return( ::oDataBase:DBFCursor( cSQL ) )

//---------------------------------------------------------------------------//
// Devuelve un objeto MSACursor

METHOD ACursor( cSQL ) CLASS TMSVConnect
return( ::oDataBase:ACursor( cSQL ) )

//---------------------------------------------------------------------------//
// Crea una nueva Base de Datos en el servidor

METHOD CreateDataBase( cDbName, lIfNotExist, cCharSet, cCollate ) CLASS TMSVConnect

    local cStmt
    local lRet := ( ValType( cDbName ) == "C" )

    if lRet
        cStmt := "create database "
        if ValType( lIfNotExist ) == "L" .and. lIfNotExist
            cStmt += "if not exists "
        endif
        cStmt += cDbName
        if ValType( cCharSet ) == "C"
            cStmt += " default character set " + cCharSet
        endif
        if ValType( cCollate ) == "C"
            cStmt += " default collate " + cCollate
        endif
        if !E1ExecDirect( ::hConnect, cStmt )
            ::oError:Show()
            lRet := .f.
        endif
    else
        ::oError:Say( "Nombre de Bases de Datos debe ser tipo caracter", .t. )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Modifica una nueva Base de Datos en el servidor

METHOD AlterDataBase( cDbName, cCharSet, cCollate ) CLASS TMSVConnect

    local cStmt
    local lRet := ( ValType( cDbName ) == "C" )

    if lRet
        cStmt := "alter database " + cDbName
        if ValType( cCharSet ) == "C"
            cStmt += " default character set " + cCharSet
        endif
        if ValType( cCollate ) == "C"
            cStmt += " default collate " + cCollate
        endif
        if !E1ExecDirect( ::hConnect, cStmt )
            ::oError:Show()
            lRet := .f.
        endif
    else
        ::oError:Say( "Nombre de Bases de Datos debe ser tipo caracter", .t. )
    endif

return( lRet )
//---------------------------------------------------------------------------//
// Destruye una base de datos en el servidor

METHOD DropDataBase( cDbName, lIfExist ) CLASS TMSVConnect

    local cStmt
    local lRet := ValType( cDbName ) == "C"

    if lRet
        cStmt := "drop database "
        if ValType( lIfExist ) == "L" .and. lIfExist
            cStmt += "if exists "
        endif
        cStmt += cDbName
        if !E1ExecDirect( ::hConnect, cStmt )
            ::oError:Show()
            lRet := .f.
        endif
    else
        ::oError:Say( "Nombre de Bases de Datos debe ser tipo caracter", .t. )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Devuelve la lista de bases de datos en el servidor

METHOD ListDataBases() CLASS TMSVConnect
return( E1ListQuery( ::hConnect, "show databases" ) )

//---------------------------------------------------------------------------//
// Devuelve un array con los nombre de las tablas de la BD por defecto

METHOD ListTables() CLASS TMSVConnect
return( E1ListQuery( ::hConnect, "show tables" ) )

//---------------------------------------------------------------------------//
// Comprueba si existe una base de datos en la conexion

METHOD ExistDataBase( cDbName ) CLASS TMSVConnect

    local lRet := ( ValType( cDbName ) == "C" )

    if lRet
        cDbName := upper( AllTrim( cDbName ) )
        lRet := ( AScan( ::ListDataBases(), { | e | upper( e ) == cDbName } ) > 0 )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Pone la base de datos indicada por el nombre o por el objeto DataBase
// como la de uso por defecto

METHOD SelectDataBase( coDbName ) CLASS TMSVConnect

    local lRet := ( ValType( coDbName ) == "C" )

    if lRet
        coDbName := AllTrim( coDbName )
        if lRet := E1SelectDataBase( ::hConnect, coDbName )
            ::oDataBase := TMSDataBase():New( Self, coDbName )
        else
            ::oError:Show()
        endif
    elseif upper( coDbName:ClassName() ) == "TMSDATABASE"
        if lRet := E1SelectDataBase( ::hConnect, coDbName:cName )
            ::oDataBase := coDbName
        else
            ::oError:Show()
        endif
    else
        ::oError:Say( "Argumento erróneo para la selección", .t. )
        lRet := .f.
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Crea un objeto DataBase a partir del nombre de la Base de Datos

METHOD DataBaseByName( cDbName, lDefault ) CLASS TMSVConnect

    local oDataBase

    if ::ExistDataBase( cDbName )
        oDataBase := TMSDataBase():New( Self, cDbName, lDefault )
    endif

return( oDataBase )

//---------------------------------------------------------------------------//
// Crea un objeto DataBase a partir del nombre de la Base de Datos

METHOD DataBase( cDbName, lDefault ) CLASS TMSVConnect
return( TMSDataBase():New( Self, cDbName, lDefault ) )

//---------------------------------------------------------------------------//
// Devuelve un valor escalar numerico o de tipo caracter desde una sentencia
// SELECT

METHOD GetScalarQuery( cSQL ) CLASS TMSVConnect
return( E1ScalarQuery( ::hConnect, cSQL ) )

//---------------------------------------------------------------------------//
// Crea una nueva cuenta de usuario sin ningun privilegio en bases de datos

METHOD CreateUser( cUser, cPwd ) CLASS TMSVConnect

    local lRet := ( Valtype( cUser ) == "C" )

    if lRet
        if ValType( cPwd ) == "C"
            lRet := ::Execute( "CREATE USER " + "'" + cUser + "'@'" + ::cHost + "'" + ;
                               " IDENTIFIED BY '" + cPwd + "'" )
        else
            lRet := ::Execute( "CREATE USER " + "'" + cUser + "'@'" + ::cHost + "'" )
        endif
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Elimina una cuenta de usuario

METHOD DropUser( cUser ) CLASS TMSVConnect

    local lRet := ( ValType( cUser ) == "C" )

    if lRet
        lRet := ::Execute( "DROP USER " + "'" + cUser + "'@'" + ::cHost + "'" )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Renombra el nombre de un usuario

METHOD RenameUser( cOldUser, cNewUser ) CLASS TMSVConnect

    local lRet := ( ValType( cOldUser ) == "C" .and. ValType( cNewUser ) == "C" )

    if lRet
        lRet := ::Execute( "RENAME USER " + "'" + cOldUser + "'@'" + ::cHost + "'" + ;
                           " TO " + "'" + cNewUser + "'@'" + ::cHost + "'" )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Asigna una clave a una cuenta de usuario

METHOD SetPassWord( cPwd, cUser ) CLASS TMSVConnect

    local lRet := ( ValType( cPwd ) == "C" )

    if lRet
        if ValType( cUser ) == "C"
            lRet := ::Execute( "SET PASSWORD FOR " + ;
                               "'" + cUser + "'@'" + ::cHost + "'" + ;
                               " = PASSWORD( '" + cPwd + "' )" )
        else
            lRet := ::Execute( "SET PASSWORD = PASSWORD( '" + cPwd + "' )" )
        endif
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Asigna permisos a un usuario en una o mas bases de datos de la conexion
// pudiendo también asignar una password

METHOD SetGlobalGrant( cUser, cDb, aPrivileges, cPwd, cRequire ) CLASS TMSVConnect

    local cPrivileges, n, i, cExec
    local lRet := ( ValType( cUser ) == "C" )

    if lRet

        DEFAULT cDb := "*" TYPE "C"

        SWITCH ValType( aPrivileges )

            CASE 'A'
                if n := len( aPrivileges ) > 0
                    cPrivileges := ""
                    for i := 1 to n
                        if ValType( aPrivileges[ i ] ) == "C"
                            cPrivileges += aPrivileges[ i ] + ", "
                        endif
                    next
                    cPrivileges := ChgAtEnd( cPrivileges, "", 2 )
                endif

                EXIT

            CASE 'C'
                cPrivileges := aPrivileges

                EXIT

            DEFAULT
                cPrivileges := "ALL"

        END

        cExec := "GRANT " + cPrivileges + " ON " + cDb + ".* TO " + ;
                 "'" + cUser + "'@'" + ::cHost + "'"

        if ValType( cPwd ) == "C"
            cExec += " IDENTIFIED BY '" + cPwd + "'"
        endif

        if ValType( cRequire ) == "C"
            cExec += " REQUIRE " + cRequire
        endif

        lRet := ::Execute( cExec )

    endif

return( lRet )

//---------------------------------------------------------------------------//
// Quita permisos a un usuario en una o mas bases de datos de la conexion

METHOD SetGlobalRevoke( cUser, cDb, aPrivileges ) CLASS TMSVConnect

    local cPrivileges, n, i, cExec
    local lRet := ( ValType( cUser ) == "C" )

    if lRet

        DEFAULT cDb := "*" TYPE "C"

        SWITCH ValType( aPrivileges )

            CASE 'A'
                if n := len( aPrivileges ) > 0
                    cPrivileges := ""
                    for i := 1 to n
                        if ValType( aPrivileges[ i ] ) == "C"
                            cPrivileges += aPrivileges[ i ] + ", "
                        endif
                    next
                    cPrivileges := ChgAtEnd( cPrivileges, "", 2 )
                endif

                EXIT

            CASE 'C'
                cPrivileges := aPrivileges

                EXIT

            DEFAULT
                cPrivileges := "ALL"

        END

        cExec := "REVOKE " + cPrivileges + " ON " + cDb + ".* FROM " + ;
                 "'" + cUser + "'@'" + ::cHost + "'"

        lRet := ::Execute( cExec )
    endif

return( lRet )

//---------------------------------------------------------------------------//

