/*
 * Proyecto: hdo_general
 * Fichero: HDOMySQL.ch
 * Descripción: Definiciones para el RDL de MySQL de HDO
 * Autor: Manu Exposito
 * Fecha: 15/10/2017
 */

//------------------------------------------------------------------------------

#ifndef HDOMYSQL_CH_
#define HDOMYSQL_CH_

//------------------------------------------------------------------------------
// Opciones del metodo: setAttribute( nMySQL_ATT, xValue )

#define MYSQL_OPT_CONNECT_TIMEOUT 				0
#define MYSQL_OPT_COMPRESS 						1
#define MYSQL_OPT_NAMED_PIPE 					2
#define MYSQL_INIT_COMMAND 						3
#define MYSQL_READ_DEFAULT_FILE 				4
#define MYSQL_READ_DEFAULT_GROUP 				5
#define MYSQL_SET_CHARSET_DIR 					6
#define MYSQL_SET_CHARSET_NAME 					7
#define MYSQL_OPT_LOCAL_INFILE 					8
#define MYSQL_OPT_PROTOCOL 						9
#define MYSQL_SHARED_MEMORY_BASE_NAME 			10
#define MYSQL_OPT_READ_TIMEOUT 					11
#define MYSQL_OPT_WRITE_TIMEOUT 				12
#define MYSQL_OPT_USE_RESULT 					13
#define MYSQL_OPT_USE_REMOTE_CONNECTION 		14
#define MYSQL_OPT_USE_EMBEDDED_CONNECTION 		15
#define MYSQL_OPT_GUESS_CONNECTION 				16
#define MYSQL_SET_CLIENT_IP 					17
#define MYSQL_SECURE_AUTH 						18
#define MYSQL_REPORT_DATA_TRUNCATION 			19
#define MYSQL_OPT_RECONNECT 					20
#define MYSQL_OPT_SSL_VERIFY_SERVER_CERT 		21
#define MYSQL_PLUGIN_DIR 						22
#define MYSQL_DEFAULT_AUTH 						23
#define MYSQL_OPT_BIND 							24
#define MYSQL_OPT_SSL_KEY 						25
#define MYSQL_OPT_SSL_CERT 						26
#define MYSQL_OPT_SSL_CA 						27
#define MYSQL_OPT_SSL_CAPATH 					28
#define MYSQL_OPT_SSL_CIPHER 					29
#define MYSQL_OPT_SSL_CRL 						30
#define MYSQL_OPT_SSL_CRLPATH 					31
#define MYSQL_OPT_CONNECT_ATTR_RESET 			32
#define MYSQL_OPT_CONNECT_ATTR_ADD 				33
#define MYSQL_OPT_CONNECT_ATTR_DELETE 			34
#define MYSQL_SERVER_PUBLIC_KEY 				35
#define MYSQL_ENABLE_CLEARTEXT_PLUGIN 			36
#define MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS	37
#define MYSQL_OPT_SSL_ENFORCE 					38
#define MYSQL_OPT_MAX_ALLOWED_PACKET 			39
#define MYSQL_OPT_NET_BUFFER_LENGTH 			40
#define MYSQL_OPT_TLS_VERSION 					41
#define MYSQL_OPT_SSL_MODE 						42

// Opciones del parametro ulClientFlag del metodo connect()
#define CLIENT_LONG_PASSWORD					1		/* new more secure passwords */
#define CLIENT_FOUND_ROWS						2		/* Found instead of affected rows */
#define CLIENT_LONG_FLAG						4		/* Get all column flags */
#define CLIENT_CONNECT_WITH_DB					8		/* One can specify db on connect */
#define CLIENT_NO_SCHEMA						16		/* Don't allow database.table.column */
#define CLIENT_COMPRESS							32		/* Can use compression protocol */
#define CLIENT_ODBC								64		/* Odbc client */
#define CLIENT_LOCAL_FILES						128		/* Can use LOAD DATA LOCAL */
#define CLIENT_IGNORE_SPACE						256		/* Ignore spaces before '(' */
#define CLIENT_PROTOCOL_41						512		/* New 4.1 protocol */
#define CLIENT_INTERACTIVE						1024	/* This is an interactive client */
#define CLIENT_SSL              				2048	/* Switch to SSL after handshake */
#define CLIENT_IGNORE_SIGPIPE   				4096    /* IGNORE sigpipes */
#define CLIENT_TRANSACTIONS						8192	/* Client knows about transactions */
#define CLIENT_RESERVED         				16384   /* Old flag for 4.1 protocol  */
#define CLIENT_RESERVED2        				32768	/* Old flag for 4.1 authentication */
#define CLIENT_MULTI_STATEMENTS 				hb_bitShift( 1, 16 ) /* Enable/disable multi-stmt support */
#define CLIENT_MULTI_RESULTS    				hb_bitShift( 1, 17 ) /* Enable/disable multi-results */
#define CLIENT_PS_MULTI_RESULTS 				hb_bitShift( 1, 18 ) /* Multi-results in PS-protocol */

//------------------------------------------------------------------------------

#endif /* fin de HDOMYSQL_CH_ */

//------------------------------------------------------------------------------
