/*
 * Proyecto: hdo
 * Fichero: ej03.prg
 * Descripción: Inserta datos en una tabla desde el objeto hdo con el metodo
 *                exec. Ejemplo de control de transacciones.
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main03()

    local oDb
    local cDb := "demo.db"
    local cTabla := "test"
    local i, e
    local cIns := ;
       "INSERT INTO " + cTabla + ;
       " ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
       "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera' );"

    cls

    oDb := THDO():new( "sqlite" )

    if oDb:connect( cDb )

        msg( cDb + " abierta" )

        TRY
			msg( if( oDb:inTransaction(), "Esta ", "No esta " ) + "en una trasaccion" )
			
            oDb:beginTransaction()

			msg( "Ahora " + if( oDb:inTransaction(), "esta ", "no esta " ) + "en una trasaccion" )
			
            i := oDb:exec( cIns )

            oDb:commit()
			
            msg( hb_ntos( i ) + " - " + hb_ntos( oDb:lastInsertId() ), "Columnas afectadas y lastInsertId" )

        CATCH
            muestra( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + ;
               e:Operation + ";" + e:Description, "Error desde Harbour" )
            muestra( oDb:errorInfo(), "Datos del error" )
            oDb:rollBack()
        end

    endif

    if oDb:disconnect()
        msg( cDb + " cerrada" )
    endif

return

//------------------------------------------------------------------------------
