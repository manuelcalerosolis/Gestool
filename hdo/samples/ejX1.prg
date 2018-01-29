/*
 * Proyecto: HDO_GENERAL
 * Fichero: ejX1.prg
 * Autor: Manu Exposito
 * Fecha: 20/01/2018
 * Descripcion: Traspasa test.dbf de los ejemplos de Harbour a SQLite.
 *              Si no existe la bases de datos "hdodemo.db" la crea.
 *              Si no existe la tabla "test" la crea.
 */
/*
 Notas:
	
 - El gestor de bases de datos SQLite tienes los siguientes tipos de datos:
    NULL.   The value is a NULL value.
    INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
    REAL.    The value is a floating point value, stored as an 8-byte IEEE floating point number.
    TEXT.    The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
    BLOB.    The value is a blob of data, stored exactly as it was input.
*/
	
#include "hdo.ch"

REQUEST RDLSQLITE // Obliga al compilador a enlazar el modulo del RDL

// Definiciones locales

#define INSERT_SQL  "INSERT INTO test ( first, last, street, city, state, zip, "  + ;
									   "hiredate, married, age, salary, notes ) " + ;
					"VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );"

#define CREA_TABLE  "CREATE TABLE IF NOT EXISTS test ( "	+ ;
						"idreg INTEGER AUTO_INCREMENT  PRIMARY KEY,"  		+ ;
						"first    VARCHAR( 20 ),"     		+ ;
						"last     VARCHAR( 20 ),"     		+ ;
						"street   VARCHAR( 30 ),"     		+ ;
						"city     VARCHAR( 30 ),"     		+ ;
						"state    VARCHAR( 2 ),"      		+ ;
						"zip      VARCHAR( 20 ),"     		+ ;
						"hiredate DATE,"          	 	 	+ ;
						"married  BOOLEAN,"       	  		+ ;
						"age      INTEGER,"       	  		+ ;
						"salary   DECIMAL( 9, 2 ),"   		+ ;
						"notes    VARCHAR( 70 ) );"

//------------------------------------------------------------------------------
// Programa principal

static first, last, street, city, state, zip, hiredate, married, age, salary, notes

procedure mainx1()

    local oDb, e
	
    oDb := THDO():new( "sqlite" )

    if oDb:connect( "hdodemo.db" )

        msg( "demo.db abierta" )

        try
            oDb:execDirect( CREA_TABLE )
            msg( "Traspaso de datos..." )
            traspasa( oDb )
        catch  e
            eval( errorblock(), e )
        end

    endif

    oDb:disconnect()
    msg( "demo.db cerrada" )

return

//------------------------------------------------------------------------------
// Usa sentencias preparadas en el lado del servidor y transacciones.

procedure traspasa( oDb )

    local n := 0
    local oInsert

    if file( "test.dbf" )
		
        use test new
		
        oInsert := oDb:prepare( INSERT_SQL )
		
		bindVariables( oInsert )
		
        oDb:beginTransaction()
	
        while test->( !eof() )
            first    := test->first
            last     := test->last
            street   := test->street
            city     := test->city
            state    := test->state
            zip      := test->zip
            hiredate := hb_dtoc( test->hiredate, "yyyy-mm-dd" ) // hb_tton( test->hiredate ) // dtos( test->hiredate )
            married  := if( test->married, 1, 0 )
            age      := test->age
            salary   := test->salary
            notes    := test->notes
		    // Ejecuta la sentencia con los nuevos valores
            oInsert:execute()
		    // Muestra contador actual
            @ 10, 10 say str( ++n )
		    // Va al siguiente registro
            test->( dbskip( 1 ) )
        end
	
        oDb:commit() // Termina la transaccion
        oInsert:free()  // Libera objeto sentencia con los recursos usados
    else
        msg( "Fichero no encontrado -> test.dbf" )
    endif

return

//------------------------------------------------------------------------------

static procedure bindVariables( oIns )
							
    // Vincula las variables harbour con cada una de las "?" por su posicion
    oIns:bindParam(  1, @first  )
    oIns:bindParam(  2, @last  )
    oIns:bindParam(  3, @street )
    oIns:bindParam(  4, @city )
    oIns:bindParam(  5, @state )
    oIns:bindParam(  6, @zip )
    oIns:bindParam(  7, @hiredate )
    oIns:bindParam(  8, @married )
    oIns:bindParam(  9, @age )
    oIns:bindParam( 10, @salary )
    oIns:bindParam( 11, @notes )

return

//------------------------------------------------------------------------------
