#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"
  
#ifdef __TEST__

   METHOD testCreateContado() 

   METHOD testCreateTarifaMayorista()

#endif

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreateContado() CLASS SQLClientesModel

   local uuid     
   local hBuffer     
   local hDireccion  

   uuid              := win_uuidcreatestring() 

   hDireccion        := SQLDireccionesModel():loadBlankBuffer()

   hset( hDireccion, "parent_uuid", uuid )
   hset( hDireccion, "codigo", "0" )
   hset( hDireccion, "direccion", "Cl. Lepanto, 5" )
   hset( hDireccion, "poblacion", "La Palma del Condado" )
   hset( hDireccion, "codigo_provincia", "21" )
   hset( hDireccion, "provincia", "Huelva" )
   hset( hDireccion, "codigo_postal", "21700" )
   hset( hDireccion, "codigo_pais", "ES" )
   hset( hDireccion, "telefono", "999999999" )
   hset( hDireccion, "movil", "999999999" )
   hset( hDireccion, "email", "mail@mail.com" )

   SQLDireccionesModel():insertBuffer( hDireccion )

   hBuffer           := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "codigo", 0 )
   hset( hBuffer, "nombre", "Clientes contado" )
   hset( hBuffer, "dni", "66666666B" )
   hset( hBuffer, "metodo_pago_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateTarifaMayorista() CLASS SQLClientesModel

   local uuid     
   local hBuffer     
   local hDireccion  

   uuid              := win_uuidcreatestring() 

   hDireccion        := SQLDireccionesModel():loadBlankBuffer()

   hset( hDireccion, "parent_uuid", uuid )
   hset( hDireccion, "codigo", "0" )
   hset( hDireccion, "direccion", "Cl. Real, 58" )
   hset( hDireccion, "poblacion", "Bollullos Par del Codado" )
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
   hset( hBuffer, "codigo", "1" )
   hset( hBuffer, "nombre", "Clientes tarifa mayorista" )
   hset( hBuffer, "dni", "77777777A" )
   hset( hBuffer, "metodo_pago_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "1" )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
