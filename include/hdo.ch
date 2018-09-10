//------------------------------------------------------------------------------
// Proyecto: Harbour Data Objects hdo
// Fichero: hdo.ch
// Descripcion: includes de programas con hdo
// Autor: Manu Exposito 2014-18
// Fecha: 10/09/2018
//------------------------------------------------------------------------------

#ifndef HDO_CH_
#define HDO_CH_

//------------------------------------------------------------------------------

#include "hdocommon.ch"

//------------------------------------------------------------------------------
// Definicion de TRY CATCH para la gestion de excepciones y errores:

#xcommand TRY  => BEGIN SEQUENCE WITH { | oErr | Break( oErr ) }
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS

//------------------------------------------------------------------------------

#endif /* fin de HDO_CH_ */

//------------------------------------------------------------------------------
