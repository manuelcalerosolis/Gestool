/*
 * Proyecto: hdo
 * Fichero: ej05.prg
 * Descripción: Uso de sentencias preparaadas con parametros y variables
 *                vinculadas Insert.
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "inkey.ch"

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
//

procedure main05()

    local oDb, oStmt, e
    local cTabla := "test"

    //    1      2     3       4     5      6    7         8        9    10      11
    local first, last, street, city, state, zip, hiredate, married, age, salary, notes
    local cSql := "INSERT INTO " + cTabla + ;
       " ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );"

	oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )

        TRY
			oDb:beginTransaction()
            oStmt := oDb:prepare( cSql ) // Prepara la sentencia

            // ----------------------------------------------------------------
	
            // Enlaza los valores con los parametros de sustitucion
            oStmt:bindValue( 1, 'Maria' )
            oStmt:bindValue( 2, 'Gimenez' )
            oStmt:bindValue( 3, 'Pintor Velazquez, 89' )
            oStmt:bindValue( 4, 'Dos Hermanas' )
            oStmt:bindValue( 5, 'ES' )
            oStmt:bindValue( 6, '41700' )
            oStmt:bindValue( 7,  date() )
            oStmt:bindValue( 8,  .t. )
            oStmt:bindValue( 9,  33 )
            oStmt:bindValue( 10, 5670.50 )
            oStmt:bindValue( 11, 'Esta es la nota de Maria...' )

            oStmt:execute()

            // Otra vez
            oStmt:bindValue( 1, 'Jose' )
            oStmt:bindValue( 2, 'Jimenez' )
            oStmt:bindValue( 3, 'Pintor Greco, 90' )
            oStmt:bindValue( 4, 'Dos Hermanas' )
            oStmt:bindValue( 5, 'ES' )
            oStmt:bindValue( 6, '41700' )
            oStmt:bindValue( 7,  Date() )
            oStmt:bindValue( 8,  .f. )
            oStmt:bindValue( 9,  34 )
            oStmt:bindValue( 10, 8560.50 )
            oStmt:bindValue( 11, 'Esta es la nota de Jose...' )

            oStmt:execute()

            // Y otra etc
            oStmt:bindValue( 1, 'Adrian' )
            oStmt:bindValue( 2, 'Perez' )
            oStmt:bindValue( 3, 'Sierra de Gredos, 9' )
            oStmt:bindValue( 4, 'Dos Hermanas' )
            oStmt:bindValue( 5, 'ES' )
            oStmt:bindValue( 6, '41700' )
            oStmt:bindValue( 7,  Date() )
            oStmt:bindValue( 8,  .t. )
            oStmt:bindValue( 9,  33 )
            oStmt:bindValue( 10, 10000.50 )
            oStmt:bindValue( 11, 'Esta es la nota de Adrian...' )

            oStmt:execute()

            // Cracion de binds con variables de harbour.
            // Note que la variable se pasa por REFERENCIA.
			// Com se puede ver una vez vinculadas se le da valores como una variable
			// normal de harbour y se envia el metodo execute para insertar el
			// valor en la base de datos. Es el metodo mas facil y rapido de
			// hacerlo.
		
			oStmt:bindParam(  1, @first  )
			oStmt:bindParam(  2, @last  )
			oStmt:bindParam(  3, @street )
			oStmt:bindParam(  4, @city )
			oStmt:bindParam(  5, @state )
			oStmt:bindParam(  6, @zip )
			oStmt:bindParam(  7, @hiredate )
			oStmt:bindParam(  8, @married )
			oStmt:bindParam(  9, @age )
			oStmt:bindParam( 10, @salary )
			oStmt:bindParam( 11, @notes )

            // Uso de binds

            // Asignacion de valores
            first 	 := "first.....1"
            last 	 := "last......1"
            street 	 := "street....1"
            city 	 := "city......1"
            state 	 := "s1"
            zip 	 := "41701"
            hiredate := Date() + 1
            married  := .f.
            age      := 51
            salary   := 5100.01
            notes    := "Nota......1"
            // Ejecucion de la sentencia preparada en el lado del servidor
            oStmt:execute()

            // Otro
            first 	 := "first.....2"
            last 	 := "last......2"
            street 	 := "street....2"
            city 	 := "city......2"
            state 	 := "s2"
            zip 	 := "41072"
            hiredate := Date() + 2
            married  := .t.
            age      := 52
            salary   := 5200.02
            notes    := "Nota......2"

            oStmt:execute()

            // Y otro
            first 	 := "first.....3"
            last 	 := "last......3"
            street 	 := "street....3"
            city 	 := "city......3"
            state 	 := "s3"
            zip 	 := "41073"
            hiredate := Date() + 3
            married  := .f.
            age      := 53
            salary   := 5300.03
            notes    := "Nota......3"

            oStmt:execute()

			oDb:commit()
			
            msg( "Se han insertado los registros" )

        CATCH e
            eval( errorblock(), e )
			oDb:rollBack()
        FINALLY
            oStmt:free()
        end
    endif

    oDb:disconnect()
	
	msg( "Fin de la ejecion" )

return

//------------------------------------------------------------------------------
