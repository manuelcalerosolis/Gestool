/*
 * Proyecto: hdo
 * Fichero: ej10.prg
 * Descripción: Ejemplo de uso de los metodos get...() y fetchDirect
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main10()

    local oDb, oStmt, t, e
    local cDb := "demo.db"
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla

    oDb := THDO():new( "sqlite" )

    if oDb:connect( cDb )

        TRY		
            // Prepara la sentencia
            oStmt := oDb:prepare( cSql )
            // Ejecuta la sentencia
            oStmt:execute()
            t := seconds()
            cls
            ? "Prueba de fetchDirect y metodos get...()"
            ? "----------------------------------------"
            ?
            // Rescata todas las filas de la tabla en un hash
            while oStmt:fetchDirect()
                ? oStmt:getInt( 1 ), oStmt:getString( 2 ), oStmt:getString( 3 ), oStmt:getDouble( 11 ), oStmt:getInt( 10 )
            end
            ?
            ? transform( oStmt:rowCount(), "999,999,999,999" ), "registros en", seconds() - t, "segundos"
            espera( 10, "fin de prueba." )
        CATCH e
            msg( "Se ha producido un error" )
            muestra( oDb:errorInfo() )
            eval( errorblock(), e )
        FINALLY
            // Cierra el objeto sentencia para liberar memoria
            oStmt:free()
        end

    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
