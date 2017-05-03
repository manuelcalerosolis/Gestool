/*
 * Proyecto: hdo
 * Fichero: ej09.prg
 * Descripción: Uso de los metodos fetchDirect y fetchColumn (Sin cursores locales)
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main09()

    local oDb, oStmt
    local cDb := "demo.db"
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla

    oDb := THDO():new( "sqlite" )

    if oDb:connect( cDb )

        TRY
            // Prepara y Ejecuta la sentencia
            oStmt := oDb:query( cSql )
            cls
            ? "Prueba de fetchDirect"
            ? "----------------------------------"
            ?

            while oStmt:fetchDirect()
                ? oStmt:fetchColumn( 1 ), oStmt:fetchColumn( 2 ), ;
				  oStmt:fetchColumn( 3 ), oStmt:fetchColumn( 4 ), ;
				  oStmt:fetchColumn( 5 ), oStmt:fetchColumn( 6 )
            end
            ?
            espera( 10, "Fin de la prueba..." )
        CATCH
            msg( "Se ha producido un error" )
            muestra( oDb:errorInfo() )
        FINALLY
            // Cierra el objeto sentencia para liberar memoria
            oStmt:free()
        end

    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
