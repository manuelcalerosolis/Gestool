/*
 * Proyecto: hdo
 * Fichero: ej11.prg
 * Descripción: Uso del enlace de variables con columnas con el metodo bindColumn
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main11()

    local oDb, oSelect, t, e
    local cDb := "demo.db"
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla
    local idreg, first, last, street, city, state, zip, hiredate, married, ;
	      age, salary, notes // Variables de campos

    oDb := THDO(): new( "sqlite" )

    if oDb:connect( cDb )

        TRY
            // Prepara la sentencia
            oSelect := oDb:prepare( cSql )

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

            t := seconds()
            cls
            ? "Prueba de fetchBound"
            ? "----------------------------------------"
            ?
            // Rescata todas las filas de la tabla en un hash

            while oSelect:fetchBound()
                ? idreg, first, last, street, city, state, zip, hiredate, married, age, salary, notes			
            end
            ?
            ? "Fin de la prueba...", transform( oSelect:rowCount(), "999,999,999,999" ), "registros en", seconds() - t, "segundos"
            espera( 15 )
        CATCH e
            msg( "Se ha producido un error" )
            muestra( oDb:errorInfo() )
            eval( errorblock(), e )
        FINALLY
            // Cierra el objeto sentencia para liberar memoria
            oSelect:free()
        end

    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
