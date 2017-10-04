/*
 * Proyecto: HDO_GENERAL
 * Fichero: ej17.prg
 * Descripcion:
 * Autor: Manu Exposito
 * Fecha: 15/01/2017
 */

//------------------------------------------------------------------------------

#include "HDO.CH"
#include "HBClass.CH"

//------------------------------------------------------------------------------
// Programa principal
//------------------------------------------------------------------------------

procedure main17()

    local oApp := TApplication():New()
	
    oApp:run()
	
    oApp:end()

return

//------------------------------------------------------------------------------
// Definicion de la clase TApplication
//------------------------------------------------------------------------------

CLASS TApplication
	
    DATA oSel, oIns, oUpd, oDel
	
    METHOD new() CONSTRUCTOR
    METHOD run()
    METHOD end()

END CLASS

//------------------------------------------------------------------------------
// Implementacion de la clase TApplication
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constructor

METHOD new() CLASS TApplication

    msg( "new" )
	
return Self

//------------------------------------------------------------------------------
// Corre la aplicacion

METHOD run() CLASS TApplication

    local lRet := .f.
	
    msg( "run" )
	
return lRet

//------------------------------------------------------------------------------
// Finaliza la aplicacion y libera recursos usados

PROCEDURE end() CLASS TApplication

    msg( "end" )
	
return

//------------------------------------------------------------------------------
