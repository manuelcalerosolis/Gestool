/*
 * Proyecto: hdo
 * Fichero: ej02.prg
 * Descripción: Ejemplo de como crear una tabla.
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

procedure main02()

    local oDb
    local cTabla := "test"
    local cCreaTabla := ;
       "CREATE TABLE IF NOT EXISTS " + cTabla  + " ( " + ;
       "idreg INTEGER AUTO_INCREMENT PRIMARY KEY," 	+ ;
       "first       VARCHAR( 20 ),"     + ;
       "last        VARCHAR( 20 ),"     + ;
       "street      VARCHAR( 30 ),"     + ;
       "city        VARCHAR( 30 ),"     + ;
       "state       VARCHAR( 2 ),"      + ;
       "zip         VARCHAR( 20 ),"     + ;
       "hiredate    DATE,"          	+ ;
       "married     BOOLEAN,"       	+ ;
       "age         INTEGER,"       	+ ;
       "salary      DECIMAL( 9, 2 ),"   + ;
       "notes       VARCHAR( 70 ) );"

    oDb := THDO():new( _DBMS,  )

    if oDb:connect( _DB, _CONN )

        msg( _DB + " abierta" )

        try
            oDb:exec( cCreaTabla )
            msg( "La tabla " + cTabla + " se ha creado correctamente" )
        catch
            msg( "Error al crear la tabla " + cTabla )
        end

    endif

    if oDb:disconnect()
        msg( _DB + " cerrada" )
    endif

return

//------------------------------------------------------------------------------
