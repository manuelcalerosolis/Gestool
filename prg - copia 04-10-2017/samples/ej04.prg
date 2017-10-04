/*
 * Proyecto: hdo
 * Fichero: ej04.prg
 * Descripción: Uso de sentencias preparadas en el lado del servidor y herencia
 *                de la clase THDO nativa.
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------
// Prueba de herencia de las clases nativas

#include "hbclass.ch"

CLASS TMyHDO INHERIT THDO

    METHOD info()

END CLASS

PROCEDURE info() CLASS TMyHDO

    local a := ::rdlInfo()

    aadd( a, ::getHost()  + ";" + ;
       ::getDbName()      + ";" + ;
       ::getUser()        + ";" + ;
       ::getPassword()    + ";" + ;
       ::getRdlName() )

    muestra( a, "Clase " + ::className() )

return

//------------------------------------------------------------------------------

procedure main04()

    local oDb, oStmt, aRes, e
    local cDb := "demo.db"
    local cTabla := "test"
    local cSql := "SELECT count( * ) FROM " + cTabla

    oDb := TMyHDO():new( "sqlite" )

    if oDb:connect( cDb )

        oDb:info()  // De la clase heredada

        TRY

            oStmt := oDb:query( cSql )  // Prepara y ejecuta la sentencia
            aRes := oStmt:fetch()       // Pone el resultado en aRes

            msg( hb_ntos( aRes[ 1 ] ), "1.- aRes[ 1 ] Registros en " + cTabla )

            // Otra manera mas rapida y directa sin crear un array
            oStmt:execute()     // Solo ejecuta, el metodo query ya la compilo
            oStmt:fetchDirect() // Lo trae al bufer interno y getInt lo lee del mismo buffer nativo

            msg( hb_ntos( oStmt:getInt( 1 ) ), "2.- oStmt:getInt( 1 ) Registros en " + cTabla )
            msg( oDb:escapeStr( "Manuel's kely \todo mi\o" ), "Ejemplo de escapeStr" )
			msg( oStmt:getQueryStr() + ";;Tiene " + hb_ntos( oStmt:columnCount() ) + ;
                 " colunas;;" + "oStmt es de tipo: " + ;
                 oStmt:className(), "Prueba de PREPARE en un SELECT" )
        CATCH e
            msg( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + e:Operation + ";" + e:Description, "_oO ERROR Oo_" )
        FINALLY
            oStmt:free()
        end

    else
        msg( "No se ha establecido la conexion" )
    endif

    oDb:disconnect()

    msg( "FIN" )

return

//------------------------------------------------------------------------------
