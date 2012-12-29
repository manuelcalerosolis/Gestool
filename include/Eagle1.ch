//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: Eagle1.ch                                                    //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Tabla de preprocesado                                        //
//---------------------------------------------------------------------------//

#ifndef _EAGLE1_CH
#define _EAGLE1_CH

//---------------------------------------------------------------------------//

#include "util.ch"
#include "mysql.ch"

//---------------------------------------------------------------------------//
// Definicion de conexion:

#xcommand INIT <_con: CONNECTION, CONNECT, CON> <oCon>  ;
                                [ HOST <cHost> ]            ;
                                [ USER <cUser> ]            ;
                                [ PASSWORD <cPasswd> ]  ;
                                [ DATABASE <cDbName> ]  ;
                                [ PORT <nPort> ]            ;
                                [ SOCKET <cSocket> ]        ;
                                [ FLAG <nFlag> ]            ;
=> <oCon> := TMSConnect():New();;
   <oCon>:Connect( <cHost>, <cUser>, <cPasswd>, <cDbName>, ;
                            <nPort>, <cSocket>, <nFlag> )

#xcommand CREATE DATABASE <cDbName> OF <oCon> ;
=> <oCon>:CreateDataBase( <cDbName> )

#xcommand DESTROY DATABASE <cDbName> OF <oCon> ;
=> <oCon>:DropDataBase( <cDbName>

#xcommand SELECT DATABASE <coDbName> OF <oCon> ;
=> <oCon>:SelectDataBase( <coDbName> )

#xcommand PING OF <oCon> [ TO <lVal> ] => [ <lVal> := ] <oCon>:Ping()

#xcommand SLEEP OF <oCon> => <oCon>:Sleep()

#xcommand RECONNECT OF <oCon> => <oCon>:ReConnect()

#xcommand CLOSE <_con: CONNECTION, CONNECT, CON> <oCon> => <oCon>:Free()
#xcommand FREE <_con: CONNECTION, CONNECT, CON> <oCon> => <oCon>:Free()

//---------------------------------------------------------------------------//
// Definicion de Base de Datos:

#xcommand USE DATABASE <oDb> NAME <DbName> OF <oCon> ;
=> <oDb> := <oCon>:DataBaseByName( <DbName>, .t. )

#xcommand ACTIVATE DATABASE <oDb> NAME <DbName> OF <oCon> ;
=> <oDb> := <oCon>:DataBaseByName( <DbName>, .t. )

#xcommand DEFINE DATABASE <oDb> NAME <DbName> ;
            [ <Used: USE, SELECT, DEFAULT> <lUse> ] OF <oCon> ;
=> <oDb> := <oCon>:DataBaseByName( <DbName>, <.lUse.> )

//---------------------------------------------------------------------------//
// Gestion de transacciones en la Base de Datos:
// El prepro falla con Harbour, solo funciona con C3 y xHarbour

#xcommand BEGIN TRANSACTION OF <oDB> ;
=> BEGIN SEQUENCE ;;
   <oDB>:Begin()

#xcommand COMMINT OF <oDB> ;
=>  if !<oDB>:Commit() ;;
        BREAK ;;
    endif

#xcommand ROLLBACK OF <oDB> ;
=>  RECOVER ;;
    <oDB>:RollBack() ;;
    END SEQUENCE

//---------------------------------------------------------------------------//
// Querys y Comandos

#xcommand DEFINE QUERY <oQry> STATEMENT <cStmt> OF <oConDb> ;
=> <oQry> := TMSQuery():Query( <oConDb>, <cStmt> )

#xcommand SET STATEMENT <cStmt> TO <oQry> => <oQry>:cStatement := <cStmt>

#xcommand EXECUTE <_tipo: COMMAND, QUERY> [ <cStmt> ] OF <oQry> ;
=> <oQry>:ExecDirect( [ <cStmt> ] )

#xcommand OPEN <_q: QUERY, COMMAND, TABLE> <oQry> ;
=> <oQry>:Open()

#xcommand FREE RESULT OF <oQry> => <oQry>:freeResult()

#xcommand CLOSE <_q: QUERY, COMMAND, TABLE> <oQry> => <oQry>:Close()

#xcommand DESTROY [ OBJECT ] <_q: QUERY, COMMAND, TABLE> <oQry>;
=> <oQry>:Destroy()

#xcommand FREE [ OBJECT ] <_q: QUERY, COMMAND, TABLE> <oQry>;
=> <oQry>:Free()

//---------------------------------------------------------------------------//
// Tablas:

#xcommand DEFINE TABLE <oTb> ;
            NAME <cName> DATAFIELD ;
            [ WHERE <W> ] ;
            [ HAVING <H> ] ;
            [ ORDER BY <O> ] ;
            [ LIMIT <L> ] ;
            OF <oDbCon> ;
=> <oTb> := TMyTable( <cName> ):New( <oDbCon>, <cName>, <W>, <H>, <O>, <L> )

#xcommand DEFINE TABLE <oTb> ;
            NAME <cName> ;
            [ WHERE <W> ] ;
            [ HAVING <H> ] ;
            [ ORDER BY <O> ] ;
            [ LIMIT <L> ] ;
            OF <oDbCon> ;
=> <oTb> := TMsTable( <cName> ):New( <oDbCon>, <cName>, <W>, <H>, <O>, <L> )

#xcommand SET ORDER BY [ <nCol> ] [ <lRefresh: REFRESH> ] TO <oTb> => <oTb>:SetOrder( [ <nCol> ][, <.lRefresh.> ] )

#xcommand INSERT INTO <oTb> [ <lRefresh: REFRESH> ] [ TO <lVar> ];
=> [ <lVar> := ] <oTb>:Insert( [ <.lRefresh.> ] )

#xcommand UPDATE <oTb> [ <lRefresh: REFRESH> ] [ LIMIT <nL> ] [ TO <lVar> ];
=> [ <lVar> := ] <oTb>:Update( [ <.lRefresh.> ] [, <nL> ] )

#xcommand DELETE FROM <oTb> [ <lRefresh: REFRESH> ] [ LIMIT <nL> ] [ TO <lVar> ];
=> [ <lVar> := ] <oTb>:Delete( [ <.lRefresh.> ] [, <nL> ] )

#endif

//---------------------------------------------------------------------------//

