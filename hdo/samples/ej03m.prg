/*
 * Proyecto: hdo_general
 * Fichero: ej03m.prg
 * Descripción: Ejemplo de como ejecutar multi sentencias desde HDO
 * Autor: Manu Exposito Suarez
 * Fecha: 22/10/2017
 */

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "HDOMySQL.ch"

REQUEST RDLMYSQL

//------------------------------------------------------------------------------

procedure main()

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

    oDb := THDO():new( "mysql" )
	
    TRY		
        oDb:connect( "hdodemo", "127.0.0.1", "root", "root",,, CLIENT_MULTI_STATEMENTS )	// Observa CLIENT_MULTI_STATEMENTS para ejecutar multisentencias
       			
        oDb:beginTransaction()
        			
        i := oDb:execDirect( cIns ) // Se ejecuta desde el objeto conexion o sea HDO y devuelve las filas afectadas
		
        msg( hb_ntos( i ) + " - " + hb_ntos( oDb:lastInsertId() ), "Columnas afectadas y lastInsertId" ) // Mira eso		

		oDb:commit()		
    CATCH e		
        muestra( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + ;
           e:Operation + ";" + e:Description, "Error visto desde Harbour" )
		
        muestra( oDb:errorInfo(), "Datos del error visto desde HDO" )
		
        oDb:rollBack()		
    finally
        oDb:disconnect()		
    end

return

//------------------------------------------------------------------------------

