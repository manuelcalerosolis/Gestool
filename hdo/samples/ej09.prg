/*
 * Proyecto: hdo
 * Fichero: ej09.prg
 * Descripción: Uso de los metodos fetchDirect y fetchColumn (Sin cursores locales)
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

procedure main09()

    local oDb, oStmt
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla

	oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )

        TRY
            // Prepara y Ejecuta la sentencia
            oStmt := oDb:query( cSql )
            cls
            ? "Prueba de fetchDirect"
            ? "----------------------------------"
            ?
            while oStmt:fetchDirect()
                ? oStmt:fetchColumn( 1 ), oStmt:fetchColumn( 2 ), ;
				  oStmt:fetchColumn( 3 ), oStmt:fetchColumn( 4 ), ;
				  oStmt:fetchColumn( 5 ), oStmt:fetchColumn( 6 )
            end
            ?
            espera( 10, "Fin de la prueba..." )
        CATCH
            msg( "Se ha producido un error" )
        FINALLY
            // Cierra el objeto sentencia para liberar memoria
            oStmt:free()
        end

    endif

    oDb:disconnect()
	
	msg( "Fin" )

return

//------------------------------------------------------------------------------
