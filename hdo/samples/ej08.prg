/*
 * Proyecto: hdo
 * Fichero: ej08.prg
 * Descripción: Uso de sentencias compiladas con variables vinculadas. Consultas
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "inkey.ch"

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

procedure main08()

	static nSocIni := 0, nSocFin := 9999
    local oDb, oStmt, oCur, e
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla + " WHERE idreg BETWEEN ? AND ? ;"
    local getlist := {}

    cls

	oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )
        TRY
            oStmt := oDb:prepare( cSql )  // Prepara la sentencia y crea el objeto oStmt

            oStmt:bindParam( 1, @nSocIni )
            oStmt:bindParam( 2, @nSocFin )

            @ maxrow(), 00 say "Presiona <INTRO> para selecionar rangos o <ESC> para salir..."

            while inkey( 0 ) != K_ESC

                cls

                @ 02, 02 say "Entrada de datos:"
                @ 04, 02 say "Entre rango inicial:" GET nSocIni picture "@K9"
                @ 05, 02 say "Entre rango final..:" GET nSocFin picture "@K9" valid validaRango( nSocIni, nSocFin )	
                read
				
                if lastkey() != K_ESC

					oStmt:execute() // Ejecuta la sentencia

                    // Creamos un cursor local (navigator) como un hash table
                    oCur := THashList():new( oStmt:fetchAll( FETCH_HASH ) )

                    cls

                    @ 00, 00 say "Resultado de la consulta -> " + hb_ntos( oStmt:rowCount() ) + " registros:" color "W+/R"
                    @ maxrow(), 00 say "<ESC> para volver al menu..." color "W+/R"

                    if oCur:reccount() > 0
                        miBrwCursor( oCur, 1, 0, maxrow() - 1, maxcol() )
                    else
                        msg( "No hay registros en ese rango" )
                    endif

                    oCur:free()
				else
					msg( "Nada que hacer..." )
                endif

                cls
                @ maxrow(), 00 say "Presiona <INTRO> para selecionar rangos o <ESC> para salir..."
            end
			
        CATCH e
            eval( errorblock(), e )
        FINALLY
            if oStmt:className() == "TSTMT"
                oStmt:free()
				msg( "Liberado el objeto TStatement" )
            endif
            msg( "Se acabo" )
        end

    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------

static function validaRango( r1, r2 )

    local lRet := ( r1 > r2 )

    if lRet
        msg( "Priemero mayor que segundo: "  + ;
           hb_ntos( r1 ) + " > " + ;
           hb_ntos( r2 ), "Error en rangos" )
    endif

return !lRet
