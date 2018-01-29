/*
 * Proyecto: hdo
 * Fichero: ej01.prg
 * Descripción: Ejemplo para abrir una base de datos y crearla si no existe
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

//------------------------------------------------------------------------------

#include "hdo.ch"

#ifdef SQLITE
	REQUEST RDLSQLITE
	#define _DBMS	"sqlite"
	#define _DB 	"hdodemo.db"
	#define _CONN
#else
	#ifdef MYSQL
		REQUEST RDLMYSQL
		#define _DBMS	"mysql"
		#define _DB		"hdodemo"
		#define _CONN 	"127.0.0.1", "root", "root"
	#endif
#endif

//------------------------------------------------------------------------------

procedure main01()

    local oDb := THDO():new( _DBMS )
	
    if oDb:connect( _DB, _CONN )
        msg( "Base de datos " + _DB + " abierta" )
    endif
	
    muestra( oDb:rdlInfo() )
	
	cls
	
    ? "Estado actual de los atributos de HDO:"
    ? "------------------------------------------------------------------------"
    ? "ATTR_RDL_NAME ----------->", oDb:getAttribute( ATTR_RDL_NAME )
    ? "ATTR_AUTOCOMMIT --------->", oDb:getAttribute( ATTR_AUTOCOMMIT )
    ? "ATTR_CASE --------------->", oDb:getAttribute( ATTR_CASE )
    ? "ATTR_TIMEOUT ------------>", oDb:getAttribute( ATTR_TIMEOUT )
    ? "ATTR_CONNECTION_STATUS -->", oDb:getAttribute( ATTR_CONNECTION_STATUS )
    ? "ATTR_ERRMODE ------------>", oDb:getAttribute( ATTR_ERRMODE )
    ? "ATTR_SERVER_VERSION ----->", oDb:getAttribute( ATTR_SERVER_VERSION )
    ? "ATTR_CLIENT_VERSION ----->", oDb:getAttribute( ATTR_CLIENT_VERSION )
    ? "ATTR_SERVER_INFO -------->", oDb:getAttribute( ATTR_SERVER_INFO )
    ? "ATTR_CLIENT_INFO -------->", oDb:getAttribute( ATTR_CLIENT_INFO )
    ? "------------------------------------------------------------------------"
    espera()

	// Objerva que hay caractere que hay que escapar como comollas simples barra derecha e izquierda
	// y comillas dobles por ejemplo HDO sabe como hacrlo para cada RDL:
	msg( oDb:escapeStr( [Manuel's kely \todo mi\o /\/\ y mira las comillas dobles "j2j2"] ), "Ejemplo de escapeStr" )
	
	oDb:free()
	
	msg( _DB + " cerrada" )

return

//------------------------------------------------------------------------------
