//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSDataBase                                                  //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de Bases de datos en MySQL                           //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSDataBase FROM TEagle1

    DATA oConnect               // Objeto conexin
    DATA cName INIT ""          // Nombre de la DB
    DATA lAutoCommit INIT .f.   // Devuelve estado de commit automatico
    DATA cBakFileName           // Nombre ultima copia en la actual ejecucion

    METHOD New( oConn, cName, lDefault ) CONSTRUCTOR
    METHOD Used()
    METHOD Execute( cStatement )

    METHOD SetDefault()
    METHOD ShowCreate()

    // Devuelven objetos DataSet
    METHOD Table( cName, cWhere, cHaving, cOrderBy, nLimit )
    METHOD MyTable( cName, cWhere, cHaving, cOrderBy, nLimit )
    METHOD Query( cStmt )
    METHOD DBFCursor( cStmt )
    METHOD ACursor( cStmt )

    // Devuelve un objeto Comando
    METHOD Command( cStmt )

    // Gestión de transacciones:
    METHOD SetAutoCommit( lOnOff )
    METHOD Begin()
    METHOD Start()
    METHOD Commit()
    METHOD RollBack()

    // Utilidates para tablas de la Base de Datos:
    METHOD ListTables()
    METHOD ExistTable( cTbName )
    METHOD CreateTable( cTbName, aStruct, cType )
    METHOD TruncateTable( cTbName )
    METHOD RenameTable( cTbName, cNewTbName )
    METHOD DropTable( cTbName )
    METHOD OptimizeTable( cTbName )
    METHOD CheckTable( cTbName )
    METHOD RepairTable( cTbName )

    // Gestion de usuarios en la base de datos:
    METHOD SetDbGrant( cUser, aPrivileges, cPwd )
    METHOD SetDbRevoke( cUser, aPrivileges )

    // Copias de seguridad vasadas en INSERT
    METHOD Export( cBakFileName, lCreate, aTables, lDropTable )
    METHOD Import( cBakFileName )

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oConn, cName, lDefault ) CLASS TMSDataBase

    ::Init()

    if ValType( cName ) == "C" .and. "CONNECT" $ upper( oConn:ClassName )
        BYNAME cName TYPE "C"
        if oConn:ExistDataBase( cName )
            ::oConnect := oConn
            ::oError:New( ::oConnect:hConnect, ::oConnect:oError:lAutoError )
            if ValType( lDefault ) == "L" .and. lDefault
                ::SetDefault()
            endif
        else
            ::oError:Say( "La Base de Datos: " + cName + " no existe", .t. )
        endif
    else
        ::oError:Say( "Error en los parámetros -> oCon, cName", .t. )
    endif

    ::SetIName( "DataBase" )

return( Self )

//---------------------------------------------------------------------------//
// Comprueba si el objeto DB es el que hay en uso por defecto

METHOD Used() CLASS TMSDataBase
return( ( Self == ::oConnect:oDataBase ) )

//---------------------------------------------------------------------------//
// Pone el objeto por defecto en la conexin.
// Devuelve un valor lgico dependiendo de si lo consigui o no

METHOD SetDefault() CLASS TMSDataBase
return( ::oConnect:SelectDataBase( Self ) )

//---------------------------------------------------------------------------//
// Ejecuta sentencias SQL desde el objeto DB.
// IMPORTANTE: solo las que no devuelven registros.

METHOD Execute( cStatement ) CLASS TMSDataBase

    local lRet := ValType( cStatement ) == "C"

    if lRet
        if !( lRet := E1ExecDirect( ::oConnect:hConnect, cStatement ) )
            ::oError:Show( .f. )
        endif
    else
        ::oError:Say( "La sentencia no es una cadena...", .t. )
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD Table( cName, cWhere, cHaving, cOrderBy, nLimit ) CLASS TMSDataBase
return( TMSTable():New( Self, cName, cWhere, cHaving, cOrderBy, nLimit ) )

//---------------------------------------------------------------------------//

METHOD MyTable( cName, cWhere, cHaving, cOrderBy, nLimit ) CLASS TMSDataBase
return( TMyTable():New( Self, cName, cWhere, cHaving, cOrderBy, nLimit ) )

//---------------------------------------------------------------------------//

METHOD Query( cStmt ) CLASS TMSDataBase
return( TMSQuery():New( Self, cStmt ) )

//---------------------------------------------------------------------------//

METHOD DBFCursor( cStmt ) CLASS TMSDataBase
return( TMSDbfCursor():New( Self, cStmt ) )

//---------------------------------------------------------------------------//

METHOD ACursor( cStmt ) CLASS TMSDataBase
return( TMSACursor():New( Self, cStmt ) )

//---------------------------------------------------------------------------//

METHOD Command( cStmt ) CLASS TMSDataBase
return( TMSCommand():New( Self, cStmt ) )

//---------------------------------------------------------------------------//
// Activa o desactiva el autocommit

METHOD SetAutoCommit( lOnOff )

    local lOldAC := ::lAutoCommit

    if ValType( lOnOff ) == "L" .and. lOnOff != ::lAutoCommit
        if E1SetAutoCommit( ::oConnect:hConnect, lOnOff )
            ::lAutoCommit := lOnOff
        endif
    endif

return( lOldAC )

//---------------------------------------------------------------------------//
// Comienza una transaccin

METHOD Begin() CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "begin" ) )

//---------------------------------------------------------------------------//
// Otro modo de comenzar una transaccin

METHOD Start() CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "start" ) )

//---------------------------------------------------------------------------//
// Termina una transaccin volcando los datos en la BD

METHOD Commit() CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "commit" ) )

//---------------------------------------------------------------------------//
// Deshace una transaccin

METHOD RollBack() CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "rollback" ) )

//---------------------------------------------------------------------------//
// Devuelve un array con los nombre de las tablas de esta BD

METHOD ListTables() CLASS TMSDataBase
return( E1ListQuery( ::oConnect:hConnect, "show tables from " + ::cName ) )

//---------------------------------------------------------------------------//
// Comprueba si existe una tabla en la Base de Datos

METHOD ExistTable( cTbName ) CLASS TMSDataBase

    local lRet := ValType( cTbName ) == "C"

    if lRet
        cTbName := upper( AllTrim( cTbName ) )
        lRet := ( AScan( ::ListTables(), ;
                            { | e | upper( e ) == cTbName } ) > 0 )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Crea una tabla a partir de una estructura tipo xBase

METHOD CreateTable( cTbName, aStruct, cType ) CLASS TMSDataBase

    local lRet, oTb

    if !( ValType( cTbName ) == "C" )
        lRet := .f.
        ::oError:Say( "El nombre de la tabla no es de tipo caracter", .t. )
    elseif !( ValType( aStruct ) == "A" )
        lRet := .f.
        ::oError:Say( "La estructura de tabla no es un array", .t. )
    elseif ::ExistTable( cTbName )
        lRet := .f.
        ::oError:Say( "La tabla " + cTbName + " ya existe", .t. )
    else
        oTb := TMSTable():New( Self )
        lRet := oTb:CreateTable( cTbName, aStruct, cType )
        oTb:Free()
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Borra el contenido total de una tabla

METHOD TruncateTable( cTbName ) CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "truncate table " + cTbName ) )

//---------------------------------------------------------------------------//
// Renombra el nombre de una tabla

METHOD RenameTable( cTbName, cNewTbName ) CLASS TMSDataBase

    local lRet := ( ValType( cNewTbName ) == "C" .and. ValType( cTbName ) == "C" )

    if lRet
        lRet := E1ExecDirect( ::oConnect:hConnect, "rename table " + ;
                              cTbName + " to " + cNewTbName )
    else
        ::oError:Say( "Nombre de tabla no es de tipo caracter", .t. )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Borra una tabla si existe

METHOD DropTable( cTbName ) CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "drop table " + cTbName ) )

//---------------------------------------------------------------------------//
// Optimiza una tabla

METHOD OptimizeTable( cTbName ) CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "optimize table " + cTbName ) )

//---------------------------------------------------------------------------//
// Revisa una tabla comprobando fallos

METHOD CheckTable( cTbName ) CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "check table " + cTbName ) )

//---------------------------------------------------------------------------//
// Repara una tabla

METHOD RepairTable( cTbName ) CLASS TMSDataBase
return( E1ExecDirect( ::oConnect:hConnect, "repair table " + cTbName ) )

//---------------------------------------------------------------------------//

METHOD ShowCreate() CLASS TMSDataBase

    local cRet
    local oQry := TMSQuery():New( ::oConnect )

    oQry:Open( "show create database " + ::cName )

    cRet := oQry:FieldGet( 2 )

    oQry:Free()

return( cRet )

//---------------------------------------------------------------------------//
// Genera un fichero SQL donde se guardan el esquema y los datos de la
// base de datos
// Copias de seguridad vasadas en INSERT

METHOD Export( cBakFileName, lCreate, aTables, lDropTable ) CLASS TMSDataBase

    local lRet, aTbl, i, n, hFileSQL, cString

    // Se resuelve el nombre del fichero
    if ValType( cBakFileName ) == "C"
        cBakFileName := upper( cBakFileName )
    else
        cBakFileName := upper( ::cName ) + "_" + DToS( Date() ) + ".SQL"
    endif

    BYNAME cBakFileName

    // Se resuelve si se borra previamente la BBDD antes de la restauracion
    if ValType( lCreate ) != "L"
        lCreate := .f.
    endif

    // Se resuelve las tablas que se van a copiar
    if ValType( aTables ) == "A"
        n := len( aTables )
        aTbl := {}
        for i := 1 to n
            if ::Exist( aTables[ i ] )
                AAdd( aTbl, aTables[ i ] )
            endif
        next
    else
        aTbl := ::ListTables()
    endif

    // Se resuelve si las tablas se van a borrar antes de copiarlas
    if ValType( lDropTable ) != "L"
        lDropTable := .t.
    endif

    // Crea el fichero para la copia
    hFileSQL := FCreate( cBakFileName )

    // La cabecera
    cString := "#--------------------------------------------------------------------" + ;
                hb_OSNewLine()
    cString += "# " + ::cVersion + " - date: " + DToC( ::dDateVersion ) + ;
                hb_OSNewLine()
    if ::oConnect:lClientServer
        cString += "# Host: " + ::oConnect:cHost + hb_OSNewLine() + ;
                   "# Port: " + StrNum( ::oConnect:nPort ) + hb_OSNewLine()
    else
        cString += "# Embedded system" + hb_OSNewLine()
    endif
    cString += "# Database: " + ::cName + hb_OSNewLine() + ;
               "# Server version: " + ::oConnect:GetServerVersion() + hb_OSNewLine() + ;
               "# Client version: " + StrNum( ::oConnect:GetClientVersion() ) + ;
               hb_OSNewLine()
    cString += "# Date/time: " + DToC( Date() ) + "     " + Time() + hb_OSNewLine() + ;
               "#--------------------------------------------------------------------" + ;
                hb_OSNewLine() + hb_OSNewLine() + hb_OSNewLine()

    cString += "SET AUTOCOMMIT=0;" + hb_OSNewLine() + ;
               "SELECT @@AUTOCOMMIT;" + hb_OSNewLine() + ;
               "START TRANSACTION;" + hb_OSNewLine() + hb_OSNewLine()

    // La base de datos
    if lCreate
        cString += "# Destruye la base de datos " + ::cName + " si existe" + hb_OSNewLine() + ;
        "DROP DATABASE IF EXISTS `" + ::cName + "`;" + hb_OSNewLine() + hb_OSNewLine() + ;
        "# Crea la base de datos " + ::cName + " si no existe" + hb_OSNewLine() + ;
        ::ShowCreate() + ";" + hb_OSNewLine() + hb_OSNewLine()
    endif

    cString += "# Pone en uso la base de datos" + hb_OSNewLine() + ;
               "USE `" + ::cName + "`;" + hb_OSNewLine() + hb_OSNewLine()

    FWrite( hFileSQL, cString )

    // Tratamos las tablas
    n := len( aTbl )

    for i := 1 to n
        TableProcess( ::oConnect, aTbl[ i ], hFileSQL, lDropTable )
    next

    cString := hb_OSNewLine() + ;
               "COMMIT;" + hb_OSNewLine() + ;
               "SET AUTOCOMMIT=1;" + hb_OSNewLine() + ;
               "SELECT @@AUTOCOMMIT;" + hb_OSNewLine()

    FWrite( hFileSQL, cString )

    FClose( hFileSQL )

return( lRet )

//---------------------------------------------------------------------------//

static procedure TableProcess( oCon, cTbName, hFileSQL, lDropTable )

    local oTb := TMSTable():New( oCon, cTbName )
    local cString, nFieldCount, i

    oTb:Open()

    //----------------------------------------------------------------------
    // Tratamos el guion de creacion de la tabla

    cString := "# Tratamiento de la tabla " + oTb:cName + hb_OSNewLine()

    if lDropTable
        cString += "DROP TABLE IF EXISTS `" + cTbName + "`;" + ;
                    hb_OSNewLine() + hb_OSNewLine()
    endif

    cString += oTb:ShowCreate() + ";" + hb_OSNewLine() + hb_OSNewLine()

    FWrite( hFileSQL, cString + hb_OSNewLine() )

    //----------------------------------------------------------------------
    // Si hay registros se generan los INSERTs

    if oTb:RecCount() > 0
        cString := "# Bloqueo de la tabla " + cTbName + hb_OSNewLine() + ;
                   "LOCK TABLES `" + cTbName + "` WRITE;" + hb_OSNewLine()


        cString += "# Aquí van los datos de la tabla " + oTb:cName + hb_OSNewLine() + ;
                   "INSERT INTO `" + oTb:cName + "` ( "

        nFieldCount := oTb:FieldCount() - 1

        for i := 1 to nFieldCount
            cString += "`" + oTb:FieldName( i ) + "`, "
        next

        cString += "`" + oTb:FieldName( i ) + "` ) VALUES "

        FWrite( hFileSQL, cString + hb_OSNewLine() )

        // Los datos:
        RowsProcess( oTb, hFileSQL )

        cString := hb_OSNewLine() + hb_OSNewLine() + ;
                   "# Desbloqueo de la tabla " + oTb:cName + hb_OSNewLine() + ;
                   "UNLOCK TABLES;"+ hb_OSNewLine()

        FWrite( hFileSQL, cString )
    endif

 return

//---------------------------------------------------------------------------//

static procedure RowsProcess( oTb, hFileSQL )

    local cString := ""
    local nFieldCount := oTb:FieldCount()
    local nRecCount := oTb:RecCount()
    local n, i

    oTb:GoTop()

    for n := 1 to nRecCount

        cString := "( "

        for i := 1 to nFieldCount
            if oTb:ColIsNumeric( i )
                cString += oTb:ColRead( i ) + ", "
            else
                cString += "'" + oTb:EscapeStr( i ) + "', "
            endif
        next

        oTb:Skip( 1 )

        if oTb:Eof()
            cString := ChgAtEnd( cString, " ); ", 2 ) + hb_OSNewLine()
        else
            cString := ChgAtEnd( cString, " ), ", 2 ) + hb_OSNewLine()
        endif

        FWrite( hFileSQL, cString )
    end

return

//---------------------------------------------------------------------------//
// Importa copia

METHOD Import( cBakFileName ) CLASS TMSDataBase

    local lRet := ( ValType( cBakFileName ) == "C" .and. File( cBakFileName ) )

    if lRet
        lRet := ::Execute( MemoRead( cBakFileName ) )
    else
        ::oError:Say( "Nombre de fichero de copia erroneo o no existe", .t. )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Ejecuta la sentencia GRANT

METHOD SetDBGrant( cUser, aPrivileges, cPwd, cRequire ) CLASS TMSDataBase

    local cPrivileges, n, i, cExec
    local lRet := ( ValType( cUser ) == "C" )

    if lRet

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

        cExec := "GRANT " + cPrivileges + " ON " + ::cName + ".* TO " + ;
                 "'" + cUser + "'@'" + ::oConnect:cHost + "'"

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
// Ejecuta la sentencia REVOKE

METHOD SetDbRevoke( cUser, aPrivileges ) CLASS TMSDataBase

    local cPrivileges, n, i, cExec
    local lRet := ( ValType( cUser ) == "C" )

    if lRet
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

        cExec := "REVOKE " + cPrivileges + " ON " + ::cName + ".* FROM " + ;
                 "'" + cUser + "'@'" + ::oConnect:cHost + "'"

        lRet := ::Execute( cExec )
    endif

return( lRet )

//---------------------------------------------------------------------------//

