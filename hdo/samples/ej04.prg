/*
 * Proyecto: hdo
 * Fichero: ej04.prg
 * Descripción: Uso de sentencias preparadas en el lado del servidor y herencia
 *                de la clase THDO nativa.
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
	#define _DBMS "sqlite"
	#define _DB  "hdodemo.db"
	#define _CONN
#else
	#ifdef MYSQL
		REQUEST RDLMYSQL
		#define _DBMS "mysql"
		#define _DB  "hdodemo"
		#define _CONN  "127.0.0.1", "root", "root"
	#endif
#endif

//------------------------------------------------------------------------------
// Prueba de herencia de las clases nativas

#include "hbclass.ch"

CLASS TMyHDO INHERIT THDO

    METHOD info()

END CLASS

PROCEDURE info() CLASS TMyHDO

    local a := ::rdlInfo()

    aadd( a, ;
        "Host: "        + ::getHost()        + ";" + ;
        "DbName: "      + ::getDbName()      + ";" + ;
        "User: "        + ::getUser()        + ";" + ;
        "Password: "    + ::getPassword()    + ";" + ;
        "RdlName: "     + ::getRdlName() )
		
    muestra( a, "Clase " + ::className() )

return

//------------------------------------------------------------------------------

procedure main04()

    local oDb, oStmt, aRes, e
    local cTabla := "test"
    local cSql := "SELECT count( * ) FROM " + cTabla

    oDb := TMyHDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )
        TRY

			oDb:info()  // De la clase heredada

            oStmt := oDb:query( cSql )  // Prepara y ejecuta la sentencia
			
            aRes := oStmt:fetch()       // Pone el resultado en aRes

            msg( hb_ntos( aRes[ 1 ] ), "1.- aRes[ 1 ] Registros en " + cTabla )

            // Otra manera mas rapida y directa sin crear un array
            oStmt:execute()     // Solo ejecuta, el metodo query ya la compilo
            oStmt:fetchDirect() // Lo trae al bufer interno y lo lee del mismo buffer nativo

            msg( hb_ntos( oStmt:getValue( 1 ) ), "2.- oStmt:getValue( 1 ) Registros en " + cTabla )
            msg( oDb:escapeStr( "Manuel's kely \todo mi\o" ), "Ejemplo de escapeStr" )
			msg( oStmt:getQueryStr() + ";;Tiene " + hb_ntos( oStmt:columnCount() ) + ;
                 " colunas;;" + "oStmt es de tipo: " + ;
                 oStmt:className(), "Prueba de PREPARE en un SELECT" )
        CATCH e
			eval( errorBlock(), e )
        FINALLY
			if ValType( oStmt ) == 'O'
				oStmt:free()
			endif
        end

    else
        msg( "No se ha establecido la conexion" )
    endif

    oDb:disconnect()

    msg( "FIN" )

return

//------------------------------------------------------------------------------
