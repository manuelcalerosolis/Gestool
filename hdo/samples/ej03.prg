/*
 * Proyecto: hdo
 * Fichero: ej03.prg
 * Descripción: Inserta datos en una tabla desde el objeto hdo con el metodo
 *                exec. Ejemplo de control de transacciones.
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "hdomysql.ch"

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
		#define _CONN  "127.0.0.1", "root", "root",,, CLIENT_MULTI_STATEMENTS
	#endif
#endif

//------------------------------------------------------------------------------

procedure main03()

    local oDb, i, e
    local cIns := ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" + hb_eol() + ;
       "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera un poco larga' );" +  hb_eol()

    cls

    oDb := THDO():new( _DBMS )
	muestra( oDb:rdlInfo() )
	
    TRY
		
        oDb:connect( _DB, _CONN )		
        msg( _DB + " abierta;;" + if( oDb:inTransaction(), "Esta ", "No esta " ) + "en una trasaccion" )			
        oDb:beginTransaction()
        msg( "Ahora " + if( oDb:inTransaction(), "esta ", "no esta " ) + "en una trasaccion" )			
        i := oDb:exec( cIns )
        msg( hb_ntos( i ) + " - " + hb_ntos( oDb:lastInsertId() ), "Columnas afectadas y lastInsertId" )			
        oDb:commit()
		
    CATCH e
		
        muestra( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + ;
           e:Operation + ";" + e:Description, "Error desde Harbour" )
        oDb:rollBack()
		
    finally
	
        oDb:disconnect()
        msg( _DB + " cerrada" )
		
    end

return

//------------------------------------------------------------------------------
