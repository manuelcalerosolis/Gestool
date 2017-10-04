/*
 * Proyecto: HDO_GENERAL
 * Fichero: ejXX.prg
 * Autor: Manu Exposito
 * Fecha: 15/01/2017
 * Descripcion: Traspasa test.dbf de los ejemplos de Harbour a SQLite.
 *              Si no existe la bases de datos "demo.db" la crea.
 *              Si no existe la tabla "test" la crea.
 */
/*
	Notas:
	
	- El gestor de bases de datos SQLite tienes los siguientes tipos de datos:
    NULL. 	 The value is a NULL value.
    INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
    REAL.    The value is a floating point value, stored as an 8-byte IEEE floating point number.
    TEXT.    The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
    BLOB.    The value is a blob of data, stored exactly as it was input
*/
	
#include "hdo.ch"

#xcommand TEXT INTO <v> => #pragma __text|<v>+=%s+hb_eol();<v>:=""
#xcommand ENDTEXT => #pragma __endtext

#define ID_CARGA	1000000

//------------------------------------------------------------------------------
// Programa principal

procedure mainxx()

    local oDb, e, cCreaTabla

	TEXT INTO cCreaTabla
		CREATE TABLE IF NOT EXISTS test (
			idreg INTEGER PRIMARY KEY,
			first       VARCHAR( 20 ),
			last        VARCHAR( 20 ),
			street      VARCHAR( 30 ),
			city        VARCHAR( 30 ),
			state       VARCHAR( 2 ),
			zip         VARCHAR( 20 ),
			hiredate	DATE,
			married     BOOLEAN,
			age         INTEGER,
			salary      DECIMAL( 9, 2 ),
			notes       VARCHAR( 70 ) );
	ENDTEXT
	
    oDb := THDO():new( "sqlite" )
	
	oDb:setAttribute( ATTR_ERRMODE, .t. )
	
    if oDb:connect( "demo.db" )

        msg( "demo.db abierta" )

        try
            oDb:exec( cCreaTabla )
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

static procedure traspasa( oDb )

    local n := 0
    local cSentencia, oInsert
    local first, last, street, city, state, zip, hiredate, married, age, salary, notes

    TEXT INTO cSentencia
		INSERT INTO test (
				first,
				last,
				street,
				city,
				state,
				zip,
				hiredate,
				married,
				age,
				salary,
				notes )
			VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );
	ENDTEXT
	
    if file( "test.dbf" )
		
        use test new
		
        oInsert := oDb:prepare( cSentencia ) // Crea el objeto y prepara la sentencia

        // Vincula las variables harbour con cada una de las "?" por su posicion
        oInsert:bindParam(  1, @first  )
        oInsert:bindParam(  2, @last  )
        oInsert:bindParam(  3, @street )
        oInsert:bindParam(  4, @city )
        oInsert:bindParam(  5, @state )
        oInsert:bindParam(  6, @zip )
        oInsert:bindParam(  7, @hiredate )
        oInsert:bindParam(  8, @married )
        oInsert:bindParam(  9, @age )
        oInsert:bindParam( 10, @salary )
        oInsert:bindParam( 11, @notes )
       oDb:beginTransaction()
	
	while n < ID_CARGA	
	
        while test->( !eof() )
            first    := test->first
            last     := test->last
            street   := test->street
            city     := test->city
            state    := test->state
            zip      := test->zip
            hiredate := hb_dtoc( test->hiredate, "yyyy-mm-dd" )
            married  := if( test->married, 1, 0 )
            age      := test->age
            salary   := test->salary
            notes    := test->notes
		
            oInsert:execute()
		
            @ 10, 10 say str( ++n )
		
            test->( dbskip( 1 ) )
        end
	
		test->( dBgoTop() )
	end
        oDb:commit()
        oInsert:free()
    else
        msg( "Fichero no encontrado -> test.dbf" )
    endif

return

//------------------------------------------------------------------------------
