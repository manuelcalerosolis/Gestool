//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: MySQL.ch                                                     //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Opciones de MySQL para mysql_options()                       //
//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

#ifndef _MYSQL_CH
#define _MYSQL_CH

//---------------------------------------------------------------------------//

/*
 * Ojo!!! es una enumeracion en C cada vez que cambie la version
 * de MySQL habria que comprobar que siguen exactamente igual
 */

#define MYSQL_OPT_CONNECT_TIMEOUT               0
#define MYSQL_OPT_COMPRESS                      1
#define MYSQL_OPT_NAMED_PIPE                    2
#define MYSQL_INIT_COMMAND                      3
#define MYSQL_READ_DEFAULT_FILE                 4
#define MYSQL_READ_DEFAULT_GROUP                5
#define MYSQL_SET_CHARSET_DIR                   6
#define MYSQL_SET_CHARSET_NAME                  7
#define MYSQL_OPT_LOCAL_INFILE                  8
#define MYSQL_OPT_PROTOCOL                      9
#define MYSQL_SHARED_MEMORY_BASE_NAME           10
#define MYSQL_OPT_READ_TIMEOUT                  11
#define MYSQL_OPT_WRITE_TIMEOUT                 12
#define MYSQL_OPT_USE_RESULT                    13
#define MYSQL_OPT_USE_REMOTE_CONNECTION         14
#define MYSQL_OPT_USE_EMBEDDED_CONNECTION       15
#define MYSQL_OPT_GUESS_CONNECTION              16
#define MYSQL_SET_CLIENT_IP                     17
#define MYSQL_SECURE_AUTH                       18
#define MYSQL_REPORT_DATA_TRUNCATION            19
#define MYSQL_OPT_RECONNECT                     20


/* Optiones para mysql_set_option
 * es una enumeracion en C
 */

#define MYSQL_OPTION_MULTI_STATEMENTS_ON        0
#define MYSQL_OPTION_MULTI_STATEMENTS_OFF       1

/*
 * Estado de las sentencias preparadas
 * Es una enumeracion, empieza en 1
 */

#define MYSQL_STMT_INIT_DONE                    1
#define MYSQL_STMT_PREPARE_DONE                 2
#define MYSQL_STMT_EXECUTE_DONE                 3
#define MYSQL_STMT_FETCH_DONE                   4

/*
 * Opciones de real_connect()
 */

#define CLIENT_LONG_PASSWORD            1
#define CLIENT_FOUND_ROWS               2
#define CLIENT_LONG_FLAG                4
#define CLIENT_CONNECT_WITH_DB          8
#define CLIENT_NO_SCHEMA                16
#define CLIENT_COMPRESS                 32
#define CLIENT_ODBC                     64
#define CLIENT_LOCAL_FILES              128
#define CLIENT_IGNORE_SPACE             256
#define CLIENT_PROTOCOL_41              512
#define CLIENT_INTERACTIVE              1024
#define CLIENT_SSL                      2048
#define CLIENT_IGNORE_SIGPIPE           4096
#define CLIENT_TRANSACTIONS             8192
#define CLIENT_RESERVED                 16384
#define CLIENT_SECURE_CONNECTION        32768
#define CLIENT_MULTI_STATEMENTS         HB_BitShift( 1, 16 ) /* 1 << 16 */
#define CLIENT_MULTI_RESULTS            HB_BitShift( 1, 17 ) /* 1 << 17 */
#define CLIENT_SSL_VERIFY_SERVER_CERT   HB_BitShift( 1, 30 ) /* 1 << 30 */
#define CLIENT_REMEMBER_OPTIONS         HB_BitShift( 1, 31 ) /* 1 << 31 */

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//


