/*
 * Proyecto: hdo
 * Fichero: ej01.prg
 * Descripción: Ejemplo para abrir una base de datos y crearla si no existe
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main01()

    local oDb
    local cDb

    oDb := THDO():new( "sqlite" )
	
	muestra( oDb:rdlInfo() )

    cDb := "demo.db"

    if file( cDb )
        msg( "El archivo: " + cDb + " ya existe" )
    else
        msg( "El archivo: " + cDb + " no existe" )
    endif

    if oDb:connect( cDb )
        msg( cDb + " abierta" )
    endif

    if oDb:disconnect()
        msg( cDb + " cerrada" )
    endif

return

//------------------------------------------------------------------------------
