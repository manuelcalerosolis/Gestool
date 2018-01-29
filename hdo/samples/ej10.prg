/*
 * Proyecto: hdo
 * Fichero: ej10.prg
 * Descripción: Ejemplo de uso de los metodos get...() y fetchDirect
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

procedure main10()

    local oDb, oStmt, t, e, n
	// idreg, first, last, street, city, state, zip, hiredate, married, age, salary, notes
    local cSql := "SELECT * FROM test"

	//SET DATE FORMAT TO "DD-MM-YYYY"
	
    oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )

        TRY		
			// Se puede usar estos dos metodos prepare y execute
            // Prepara la sentencia
            //oStmt := oDb:prepare( cSql )
            // Ejecuta la sentencia
            //oStmt:execute()
			// o
            // Ejecuta el metodo prepare y execute
            oStmt := oDb:query( cSql )

            t := seconds()
            cls
            ? "Prueba de fetchDirect y metodos get...()"
            ? "----------------------------------------"
            ?
            // Rescata los valores con los metodos sinonimos fetchColumn(), getColumn(), getValue()
            while oStmt:fetchDirect()
				for n := 1 to oStmt:columnCount()
					?? oStmt:fetchColumn( n )
				next
				?
            end
            ?
            ? transform( oStmt:rowCount(), "999,999,999,999" ), "registros en", seconds() - t, "segundos"
            espera( 10, "fin de prueba." )
        CATCH e
            msg( "Se ha producido un error" )
            eval( errorblock(), e )
        FINALLY
            // Cierra el objeto sentencia para liberar memoria
            oStmt:free()
        end

    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
