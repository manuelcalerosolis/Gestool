#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasComprasLineasModel FROM SQLOperacionesComercialesLineasModel

   DATA cTableName            INIT  "facturas_compras_lineas"

   DATA cGroupBy              INIT  "facturas_compras_lineas.id" 

#ifdef __TEST__

   METHOD testCreateIVAal0( uuid )
   METHOD test_create_IVA_al_0_con_10_descuento( uuid )

   METHOD testCreateIVAal10( uuid )
   METHOD testCreateIVAal10ConRecargoEquivalencia( uuid )
   
   METHOD testCreateIVAal10Con15PorcientoDescuento( uuid )

   METHOD testCreateIVAal21( uuid )
   METHOD testCreateIVAal21ConRecargoEquivalencia( uuid )
   
   METHOD testCreateIVAal21Con20PorcientoDescuento( uuid )   

   METHOD testCreateIVAal21ConIncrememtoPrecio( uuid ) 

   METHOD testCreate10PorCientoDescuento15Incremento( uuid )

#endif

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreateIVAal0( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_0_con_10_descuento( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA con 10% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "descuento", 10 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreate10PorCientoDescuento15Incremento( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA con 10% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "incremento_precio", 15 )
   hset( hBuffer, "descuento", 10 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//


METHOD testCreateIVAal10( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal10ConRecargoEquivalencia( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "recargo_equivalencia", 1.4 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal10Con15PorcientoDescuento( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA con 15% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "descuento", 15 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21ConRecargoEquivalencia( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "recargo_equivalencia", 5.2 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21Con20PorcientoDescuento( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA con 20% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "descuento", 20 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21ConIncrememtoPrecio( uuid ) CLASS SQLFacturasComprasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA con 20% descuento" )
   hset( hBuffer, "articulo_unidades", 13.22 )
   hset( hBuffer, "articulo_precio", 0.40438 )
   hset( hBuffer, "incremento_precio", 0.17000 )
   hset( hBuffer, "descuento", 15.889 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "almacen_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif
