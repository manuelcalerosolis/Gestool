#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasVentasRectificativasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getFacturasVentasRectificativasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getFacturasVentasRectificativasDescuentosController() )

   METHOD getFacturasController()      INLINE ( ::getFacturasVentasController() )

   METHOD isClient()                   INLINE ( .t. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura rectificativa de venta n�mero" )

   METHOD addExtraButtons()

   METHOD Inserted() 

   METHOD Edited()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( ::getModel():cTableName )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasVentasRectificativasModel():New( self ), ), ::oModel )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := OperacionesComercialesRectificativasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasVentasRectificativasValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasVentasRectificativasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasRectificativasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas de ventas rectificativas"

   ::cName                             := "facturas_ventas_rectificativas"

   ::hImage                            := {  "16" => "gc_rectificativa_cliente_16",;
                                             "32" => "gc_rectificativa_cliente_32",;
                                             "48" => "gc_rectificativa_cliente_48" }

   ::setEvent( 'inserted', {|| ::Inserted() } )
   
   ::setEvent( 'edited',   {|| ::Edited() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasVentasRectificativasController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Inserted() CLASS FacturasVentasRectificativasController

RETURN ( ::getRecibosGeneratorController():generateNegative() )

//---------------------------------------------------------------------------//

METHOD Edited() CLASS FacturasVentasRectificativasController 

RETURN ( ::getRecibosGeneratorController():updateNegative() )

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS FacturasVentasRectificativasController

   ::super:addExtraButtons()

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasVentasRectificativasValidator FROM OperacionesComercialesValidator

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasRectificativasValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasVentasRectificativasValidator

   hset( ::Super:getValidators(), "tercero_codigo",   {  "required"        => "El c�digo del cliente es un dato requerido",;
                                                         "clienteExist"    => "El c�digo del cliente no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*#ifdef __TEST__

CLASS TestFacturasVentasController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "facturas_ventas" }

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 

   METHOD set_codigo_tercero( cCodigoCliente, view ) ;
                                       INLINE ( view:getControl( 170, view:oFolder:aDialogs[1] ):cText( cCodigoCliente ),;
                                                testWaitSeconds(),;
                                                view:getControl( 170, view:oFolder:aDialogs[1] ):lValid(),;
                                                testWaitSeconds() )

   METHOD set_codigo_forma_pago( cCodigoFormaPago, view ) ;
                                       INLINE ( view:getControl( 240, view:oFolder:aDialogs[1] ):cText( "0" ),;
                                                testWaitSeconds(),;
                                                view:getControl( 240, view:oFolder:aDialogs[1] ):lValid(),;
                                                testWaitSeconds() )

   METHOD click_nueva_linea( view )    INLINE ( view:getControl( 501, view:oFolder:aDialogs[1] ):Click(),;
                                                testWaitSeconds() )

   METHOD set_codigo_articulo_en_linea() ;
                                       INLINE ( eval( ::oController:getFacturasVentasLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "0", 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_almacen_en_linea( cCodigoAlmacen ) ;
                                       INLINE ( eval( ::oController:getFacturasVentasLineasController():getBrowseView():oColumnCodigoAlmacen:bOnPostEdit, , cCodigoAlmacen, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_ubicacion_en_linea( cCodigoUbicacion ) ;
                                       INLINE ( eval( ::oController:getFacturasVentasLineasController():getBrowseView():oColumnCodigoUbicacion:bOnPostEdit, , cCodigoUbicacion, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_precio_en_linea( nPrecio ) ;
                                       INLINE ( eval( ::oController:getFacturasVentasLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , nPrecio, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD refresh_linea_browse_view()  INLINE ( ::oController:getFacturasVentasLineasController():getBrowseView():getRowSet():Refresh(),;
                                                testWaitSeconds() )
   
   METHOD test_calculo_con_descuento()                

   METHOD test_calculo_con_incremento()               

   METHOD test_con_unidades_de_medicion()             

   METHOD test_dialogo_sin_lineas()                   

   METHOD test_dialogo_ventas_por_cajas()             

   METHOD test_dialogo_tarifa_mayorista()             

   METHOD test_dialogo_con_un_solo_pago()
   
   METHOD test_dialogo_con_varios_pagos()  

   METHOD test_dialogo_con_cambio_de_almacen() 

   METHOD test_dialogo_con_cambio_de_ubicacion() 

   METHOD test_dialogo_con_cambio_de_agente() 

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestFacturasVentasController
   
   Company():setDefaultUsarUbicaciones( .t. )
   
   ::oController  := FacturasVentasController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestFacturasVentasController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestFacturasVentasController

   SQLTercerosModel():truncateTable()
   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLFacturasVentasModel():truncateTable()
   SQLFacturasVentasLineasModel():truncateTable()
   SQLFacturasVentasDescuentosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLRecibosModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()

   SQLTercerosModel():test_create_contado()
   SQLTercerosModel():test_create_tarifa_mayorista()
   SQLTercerosModel():test_create_con_plazos()

   SQLAlmacenesModel():test_create_almacen_principal()
   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )

   SQLAlmacenesModel():test_create_almacen_auxiliar()
   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_auxiliar() )

   SQLMetodoPagoModel():test_create_contado()
   SQLMetodoPagoModel():test_create_reposicion()
   SQLMetodoPagoModel():test_create_con_plazos()

   SQLArticulosModel():test_create_con_unidad_de_medicion_cajas_palets()
   SQLArticulosModel():test_create_con_tarifa_mayorista()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_calculo_con_descuento() CLASS TestFacturasVentasController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid )

   SQLFacturasVentasLineasModel():test_create_IVA_al_0_con_10_descuento( uuid )
   SQLFacturasVentasLineasModel():test_create_IVA_al_10_con_15_porciento_descuento( uuid )
   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_20_porciento_descuento( uuid )

   SQLFacturasVentasDescuentosModel():test_create_l0_por_ciento( uuid )
   SQLFacturasVentasDescuentosModel():test_create_20_por_ciento( uuid )
   SQLFacturasVentasDescuentosModel():test_create_30_por_ciento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::Assert():equals( 112.120000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_calculo_con_incremento() CLASS TestFacturasVentasController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid )

   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_incrememto_precio( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::Assert():equals( 7.720000, hget( hTotal, "total_documento" ), "test creacion de factura con incremento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_con_unidades_de_medicion() CLASS TestFacturasVentasController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid )

   SQLFacturasVentasLineasModel():test_create_10_porciento_descuento_15_incremento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::Assert():equals( 103.500000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_lineas() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_tercero( "0", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         view:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         view:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test creaci�n de factura sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_ventas_por_cajas() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_tercero( "0", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea(),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 100 ),;         
         view:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creaci�n de factura con ventas por cajas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_tarifa_mayorista() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_tercero( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea(),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 100 ),;         
         view:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creaci�n de factura con ventas por cajas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_un_solo_pago() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_tercero( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea(),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 200 ),;         
         view:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creaci�n de factura con un recibo pagado" )
   
   ::Assert():equals( 1, RecibosRepository():getCountWhereDocumentUuid( ::oController:getModelBuffer( "uuid" ) ), "test comprobacion numeros de recibos" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_varios_pagos() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_tercero( "2", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea(),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 300 ),;         
         view:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creaci�n de factura con varios recibos pagados" )

   ::Assert():equals( 3, RecibosRepository():getCountWhereDocumentUuid( ::oController:getModelBuffer( "uuid" ) ), "test comprobacion numeros de recibos" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_cambio_de_almacen() CLASS TestFacturasVentasController

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_cambio_de_ubicacion() CLASS TestFacturasVentasController

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_cambio_de_agente() CLASS TestFacturasVentasController

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif*/

