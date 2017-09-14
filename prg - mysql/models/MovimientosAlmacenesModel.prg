#include "FiveWin.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenesLineas FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "Client" )

   METHOD Riesgo( idCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local nRiesgo  := 0

   nRiesgo        += AlbaranesClientesModel():Riesgo( idCliente )

   nRiesgo        += RecibosClientesModel():Riesgo( idCliente )

   nRiesgo        += TicketsClientesModel():Riesgo( idCliente )

Return ( nRiesgo )

//---------------------------------------------------------------------------//
