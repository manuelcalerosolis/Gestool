/*
 * Proyecto: hdo
 * Fichero: ej02.prg
 * Descripción: Ejemplo de como crear una tabla.
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */
	
#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main02()

    local oDb
    local cDb := "demo.db"
    local cTabla := "test"
    local cCreaTabla := ;
       "CREATE TABLE " + cTabla  + " ( " + ;
       "idreg INTEGER PRIMARY KEY," 	+ ;
       "first       VARCHAR( 20 ),"     + ;
       "last        VARCHAR( 20 ),"     + ;
       "street      VARCHAR( 30 ),"     + ;
       "city        VARCHAR( 30 ),"     + ;
       "state       VARCHAR( 2 ),"      + ;
       "zip         VARCHAR( 20 ),"     + ;
       "hiredate    DATE,"          	+ ;
       "married     BOOLEAN,"       	+ ;
       "age         INTEGER,"       	+ ;
       "salary      DECIMAL( 9, 2 ),"   + ;
       "notes       VARCHAR( 70 ) );"

    oDb := THDO():new( "sqlite" )

    if oDb:connect( cDb )

        msg( cDb + " abierta" )

        try
            oDb:exec( cCreaTabla )
            msg( "La tabla " + cTabla + " se ha creado correctamente" )
        catch
            msg( "Error al crear la tabla " + cTabla )
            muestra( oDb:errorInfo() )
        end

    endif

    if oDb:disconnect()
        msg( cDb + " cerrada" )
    endif

return

//------------------------------------------------------------------------------
