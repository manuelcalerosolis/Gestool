#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"
   
   METHOD testCreateContado() 

END CLASS

//---------------------------------------------------------------------------//

METHOD testCreateContado() CLASS SQLClientesModel

   local uuid     
   local hBuffer     
   local hDireccion  

   uuid              := win_uuidcreatestring()

   hDireccion        := SQLDireccionesModel():loadBlankBuffer()

   hset( hDireccion, "parent_uuid", uuid )
   hset( hDireccion, "direccion", "Cl. Real, 58" )
   hset( hDireccion, "poblacion", "La Palma del Codado" )
   hset( hDireccion, "codigo_provincia", "21" )
   hset( hDireccion, "provincia", "Huelva" )
   hset( hDireccion, "codigo_postal", "21700" )
   hset( hDireccion, "codigo_pais", "ES" )
   hset( hDireccion, "telefono", "666666666" )
   hset( hDireccion, "movil", "666666666" )
   hset( hDireccion, "email", "mail@mail.com" )

   SQLDireccionesModel():insertBuffer( hDireccion )

   hBuffer           := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "codigo", 0 )
   hset( hBuffer, "nombre", "Clientes contado" )
   hset( hBuffer, "dni", "75541180A" )
   hset( hBuffer, "metodo_pago_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
