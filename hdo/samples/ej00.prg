/*
 * Proyecto: hdo
 * Fichero: ej00.prg
 * Descripción: Ejemplo para ver las RDL disponibles
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
 */

#include "hdo.ch"

//------------------------------------------------------------------------------

procedure main00()

    local oRDL

    oRDL := TRDL():new()

    muestra( oRDL:list(), "RDLs disponibles" )

return

//------------------------------------------------------------------------------
