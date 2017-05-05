/*
 * Proyecto: hdo
 * Fichero: ej07.prg
 * Descripción: Uso de sentencias compiladas con parametros. Consultas. Cursores
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main07()

    local oDb, oStmt, oCur, e, n1 := 0, n2 := 999999, getlist := {}, a, n
    local cDb := "demo.db"
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla + " WHERE idreg BETWEEN ? AND ? ;"

    cls

    oDb := THDO():new( "sqlite" )

    if oDb:connect( cDb )
        TRY
            oStmt := oDb:prepare( cSql )  // Prepara la sentencia y crea el objeto oStmt

            @ maxrow(), 00 say "Presiona <INTRO> para selecionar rangos o <ESC> para salir..."

            while inkey( 0 ) != 27

                cls

                @ 02, 02 say "Entrada de datos:"
                @ 04, 02 say "Entre rango inicial:" GET n1 picture "@K"
                @ 05, 02 say "Entre rango final..:" GET n2 picture "@K" valid validaRango( n1, n2 )
                read

                // Enlaza valores
                oStmt:putInt( 1, n1 ) // Primer  ?
                oStmt:putInt( 2, n2 ) // Segundo ?
                // o se puede usar la generica
                // oStmt:bindValue( 1, n1 ) // Primer  ?
                // oStmt:bindValue( 2, n2 ) // Segundo ?

                oStmt:execute() // Ejecuta la sentencia

                // Creamos un cursor local (navigator) como un hash table
                oCur := THashCursor():new( oStmt:fetchAll( FETCH_HASH ) )

                cls
                @ 00, 00 say "Resultado de la consulta -> " + hb_ntos( oStmt:rowCount() ) + " registros:" color "W+/R"
                @ maxrow(), 00 say "<ESC> para volver al menu..." color "W+/R"

                if oCur:reccount() > 0
                    miBrwCursor( oCur, 1, 0, maxrow() - 1, maxcol() )
                else
                    msg( "No hay registros en ese rango" )
                endif

                oCur:free()

                cls
                @ maxrow(), 00 say "Presiona <INTRO> para selecionar rangos o <ESC> para salir..."
            end
        CATCH e
            msg( "Se ha producido un error" )
            muestra( oDb:errorInfo() )
            muestra( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + ;
               e:Operation + ";" + e:Description, "CATCH 2 - Error desde Harbour" )
        FINALLY
            if oStmt:className() == "TSTMT"
                oStmt:free()
            endif
            msg( "Se acabo" )
        END TRY

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
