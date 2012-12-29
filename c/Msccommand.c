//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: MSCCommand                                                   //
//  FECHA MOD.: 09/12/2007                                                   //
//  VERSION...: 5.05                                                         //
//  PROPOSITO.: Para ejecutar comandos SQL. TMSCommand Metodos en C          //
//---------------------------------------------------------------------------//

#include "eagle1.h"

//---------------------------------------------------------------------------//
// Hace una consulta SQL al servidor desde la clase DataBase

HB_FUNC( E1EXECDIRECT )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );
    char * query = _parc( 2 );

    if( query )
    {
        _retl( !mysql_real_query( mysql, query, _parclen( 2 ) ) );
    }
    else
    {
        _retl( FALSE );
    }
}

//---------------------------------------------------------------------------//
// Hace una consulta SQL al servidor desde la clase DataBase

HB_FUNC( E1AFFECTEDROWS )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );

    _retnl( mysql_affected_rows( mysql ) );
}

//---------------------------------------------------------------------------//
