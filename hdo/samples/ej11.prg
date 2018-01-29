/*
 * Proyecto: hdo
 * Fichero: ej11.prg
 * Descripción: Uso del enlace de variables con columnas con el metodo bindColumn
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#include "hdo.ch"

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

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

REQUEST HB_JSONENCODE

//------------------------------------------------------------------------------

procedure main11()

    local oDb, oSelect, t, e
    local cSql := "SELECT * FROM test  WHERE age BETWEEN ? AND ? AND state = ?;"
	// Variables para vincular a las columnas de la base de datos
    local idreg, first, last, street, city, state, zip, hiredate, married, age, salary, notes
    local wage1 := 20, wage2 := 99, wstate := 'AL'
	
	oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )

        try
            // Prepara la sentencia
            oSelect := oDb:prepare( cSql )
			
			oSelect:bindParam( 1, @wage1 )
			oSelect:bindParam( 2, @wage2 )
			oSelect:bindParam( 3, @wstate )
			//oSelect:bindValue( 1, wage1 )
			//oSelect:bindValue( 2, wage2 )
			//oSelect:bindValue( 3, wstate )

			oSelect:bindColumn(  1, @idreg )
			oSelect:bindColumn(  2, @first )
			oSelect:bindColumn(  3, @last )
			oSelect:bindColumn(  4, @street )
			oSelect:bindColumn(  5, @city )
			oSelect:bindColumn(  6, @state )
			oSelect:bindColumn(  7, @zip )
			oSelect:bindColumn(  8, @hiredate )
			oSelect:bindColumn(  9, @married )
			oSelect:bindColumn( 10, @age )
			oSelect:bindColumn( 11, @salary )
			oSelect:bindColumn( 12, @notes )

            // Ejecuta la sentencia
            oSelect:execute()

////////////////////////////////////////////////////////////////////////////////	

			muestra( oSelect:columnCount() )
			muestra( oSelect:fetchJSon() )
			muestra( oSelect:fetchArray() )
			muestra( oSelect:fetchHash() )
			muestra( oSelect:listColNames() )
			muestra( oSelect:getColPos( "hiredate" ) )
			muestra( oSelect:getColName( oSelect:getColPos( "hiredate" ) ) )

////////////////////////////////////////////////////////////////////////////////			
			t := seconds()
            cls
            ? "Prueba de fetchBound"
            ? "----------------------------------------"
            ?
            // Rescata todas las filas de la tabla en un hash

            while oSelect:fetchBound()
//                ? idreg, first, last, street, city, state, zip, hiredate, married, age, salary, notes			
                ? city, state, age, salary			
            end
			
            ?
            ? "Fin de la prueba...", transform( oSelect:rowCount(), "999,999,999,999" ), "registros en", seconds() - t, "segundos"
        catch e
            eval( errorblock(), e )
        finally
            // Cierra el objeto sentencia para liberar memoria
            oSelect:free()
        end

    endif

    oDb:disconnect()

	msg( "FIN" )

return

//------------------------------------------------------------------------------
