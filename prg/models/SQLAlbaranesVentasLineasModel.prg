#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasLineasModel FROM SQLOperacionesComercialesLineasModel

   DATA cTableName            INIT  "albaranes_ventas_lineas"

   DATA cGroupBy              INIT  "albaranes_ventas_lineas.id" 

/*#ifdef __TEST__

   METHOD test_create_IVA_al_0_porciento( uuid )
   METHOD test_create_IVA_al_0_con_10_descuento( uuid )

   METHOD test_create_IVA_al_10_porciento( uuid )
   METHOD test_create_IVA_al_10_con_recargo_equivalencia( uuid )
   
   METHOD test_create_IVA_al_10_con_15_porciento_descuento( uuid )

   METHOD test_create_IVA_al_21( uuid )
   METHOD test_create_IVA_al_21_con_recargo_equivalencia( uuid )
   
   METHOD test_create_IVA_al_21_con_20_porciento_descuento( uuid )   

   METHOD test_create_IVA_al_21_con_incrememto_precio( uuid ) 

   METHOD test_create_10_porciento_descuento_15_incremento( uuid )

#endif*/

END CLASS

//---------------------------------------------------------------------------//

/*#ifdef __TEST__

METHOD test_create_IVA_al_0_porciento( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_0_con_10_descuento( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA con 10% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "descuento", 10 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_10_porciento_descuento_15_incremento( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA con 10% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "incremento_precio", 15 )
   hset( hBuffer, "descuento", 10 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_10_porciento( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "recargo_equivalencia", 1.4 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_10_con_recargo_equivalencia( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "recargo_equivalencia", 1.4 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_10_con_15_porciento_descuento( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA con 15% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "recargo_equivalencia", 1.4 )
   hset( hBuffer, "descuento", 15 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_21( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "recargo_equivalencia", 5.2 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_21_con_recargo_equivalencia( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "recargo_equivalencia", 5.2 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_21_con_20_porciento_descuento( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA con 20% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "recargo_equivalencia", 5.2 )
   hset( hBuffer, "descuento", 20 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_IVA_al_21_con_incrememto_precio( uuid ) CLASS SQLFacturasVentasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA con 20% descuento" )
   hset( hBuffer, "articulo_unidades", 13.22 )
   hset( hBuffer, "articulo_precio", 0.40438 )
   hset( hBuffer, "incremento_precio", 0.17000 )
   hset( hBuffer, "descuento", 15.889 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "recargo_equivalencia", 5.2 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "ubicacion_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif*/
