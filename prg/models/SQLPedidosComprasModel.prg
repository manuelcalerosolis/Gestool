#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLPedidosComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "PedidosCompras"

   DATA cTableName                     INIT "pedidos_compras"

   #ifdef __TEST__

   METHOD create_pedido_compras( hDatos )

   METHOD test_get_uuid_pedido_compras( cSerie, nNumero )

   #endif

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD create_pedido_compras( hDatos ) CLASS SQLPedidosComprasModel

   local hBuffer    := ::loadBlankBuffer( {  "tercero_codigo"           => "0" ,;
                                             "recargo_equivalencia"     =>  0  ,;
                                             "metodo_pago_codigo"       => "0" ,;
                                             "almacen_codigo"           => "0" ,;
                                             "agente_codigo"            => "0" ,;
                                             "ruta_codigo"              => "0" ,;
                                             "tarifa_codigo"            => "0" ,;
                                             "serie"                    => "A" ,;
                                             "numero"                   =>  3  } )
 
   if hb_ishash( hDatos )
      heval( hDatos, {|k,v| hset( hBuffer, k, v) } )
   end if

   ::insertBuffer( hBuffer )

RETURN( nil )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_pedido_compras( cSerie, nNumero ) CLASS SQLPedidosComprasModel

RETURN ( ::getUuidWhereSerieAndNumero( cSerie, nNumero ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
