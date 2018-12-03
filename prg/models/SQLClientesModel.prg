#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"
   
   METHOD testCreateContado() 

END CLASS

//---------------------------------------------------------------------------//

METHOD testCreateContado() CLASS SQLClientesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", 0 )
   hset( hBuffer, "nombre", "Clientes contado" )
   hset( hBuffer, "metodo_pago_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
