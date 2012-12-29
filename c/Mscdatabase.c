//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: MSCDataBase                                                  //
//  FECHA MOD.: 09/12/2007                                                   //
//  VERSION...: 5.05                                                         //
//  PROPOSITO.: Clase TMSDataBase. Metodos en C                              //
//---------------------------------------------------------------------------//

#include "eagle1.h"

//---------------------------------------------------------------------------//
// Empieza una transaccin

HB_FUNC( E1BEGIN )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );

    _retl( !mysql_real_query( mysql, "BEGIN", 5 ) );
}

//---------------------------------------------------------------------------//
// Empieza una transaccin

HB_FUNC( E1START )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );

    _retl( !mysql_real_query( mysql, "START", 5 ) );
}

//---------------------------------------------------------------------------//
// Finaliza una transaccin

HB_FUNC( E1COMMIT )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );

    _retl( !mysql_real_query( mysql, "COMMIT", 6 ) );
}

//---------------------------------------------------------------------------//
// Deshace una transaccin

HB_FUNC( E1ROLLBACK )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );

    _retl( !mysql_real_query( mysql, "ROLLBACK", 8 ) );
}

//---------------------------------------------------------------------------//
// Devuelve un array con los nombres de las tablas de la Base de Datos
// especificada o los de la que hay por defecto

HB_FUNC( E1LISTTABLES )
{
    MYSQL * mysql = ( MYSQL *) _parnl( 1 );
    char * dbname = _parc( 2 );
    MYSQL_RES *hStatement = NULL;
    unsigned long i;
    char stmt[ MAXBUFLEN ] = "SHOW TABLES ";

    if( dbname )
    {
        strcat( stmt, "FROM " );
        strcat( stmt, dbname );
    }

    if ( !mysql_real_query( mysql, stmt, strlen( stmt ) ) )
    {
        hStatement = mysql_store_result( mysql );

        _reta( hStatement->row_count );

        for( i = 1; i <= hStatement->row_count; i++ )
        {
            _storc( *( mysql_fetch_row( hStatement ) ), -1, i );
        }
    }

    mysql_free_result( hStatement );
}

//---------------------------------------------------------------------------//


