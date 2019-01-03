#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getTercerosLineasController()      INLINE ( ::getFacturasClientesLineasController() )

   METHOD getTercerosDescuentosController()  INLINE ( ::getFacturasClientesDescuentosController() )

   METHOD isClient()                         INLINE ( .t. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura de cliente número" )

   METHOD addExtraButtons()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "facturas_clientes" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasClientesModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasClientesValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := FacturasClientesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasClientesRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesController

   ::Super:New( oController )

   ::cTitle                            := "Facturas de ventas"

   ::cName                             := "facturas_clientes"

   ::hImage                            := {  "16" => "gc_document_text_user_16",;
                                             "32" => "gc_document_text_user_32",;
                                             "48" => "gc_document_text_user_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

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

METHOD addExtraButtons() CLASS FacturasClientesController

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesValidator FROM OperacionesComercialesValidator

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesValidator

   hset( ::Super:getValidators(), "tercero_codigo",   {  "required"        => "El código del cliente es un dato requerido",;
                                                         "clienteExist"    => "El código del cliente no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestFacturasClientesController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "facturas_clientes" }

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 
   
   METHOD test_calculo_con_descuento()                

   METHOD test_calculo_con_incremento()               

   METHOD test_con_unidades_de_medicion()             

   METHOD test_dialogo_sin_lineas()                   

   METHOD test_dialogo_ventas_por_cajas()             

   METHOD test_dialogo_tarifa_mayorista()             

   METHOD test_dialogo_con_un_solo_pago()
   
   METHOD test_dialogo_con_varios_pagos()                    

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestFacturasClientesController

   ::oController  := FacturasClientesController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestFacturasClientesController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestFacturasClientesController

   SQLTercerosModel():truncateTable()
   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLFacturasClientesModel():truncateTable()
   SQLFacturasClientesLineasModel():truncateTable()
   SQLFacturasClientesDescuentosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLRecibosModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()

   SQLTercerosModel():test_create_contado()
   SQLTercerosModel():test_create_tarifa_mayorista()
   SQLTercerosModel():test_create_con_plazos()

   SQLAlmacenesModel():test_create_almacen_principal()
   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )

   SQLMetodoPagoModel():test_create_contado()
   SQLMetodoPagoModel():test_create_reposicion()
   SQLMetodoPagoModel():test_create_con_plazos()

   SQLArticulosModel():test_create_articulo_con_unidad_de_medicion_cajas_palets()
   SQLArticulosModel():test_create_articulo_con_tarifa_mayorista()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_calculo_con_descuento() CLASS TestFacturasClientesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():test_create_factura( uuid )

   SQLFacturasClientesLineasModel():test_create_IVA_al_0_con_10_descuento( uuid )
   SQLFacturasClientesLineasModel():test_create_IVA_al_10_con_15_porciento_descuento( uuid )
   SQLFacturasClientesLineasModel():test_create_IVA_al_21_con_20_porciento_descuento( uuid )

   SQLFacturasClientesDescuentosModel():test_create_l0_por_ciento( uuid )
   SQLFacturasClientesDescuentosModel():test_create_20_por_ciento( uuid )
   SQLFacturasClientesDescuentosModel():test_create_30_por_ciento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 112.120000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_calculo_con_incremento() CLASS TestFacturasClientesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():test_create_factura( uuid )

   SQLFacturasClientesLineasModel():test_create_IVA_al_21_con_incrememto_precio( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 7.720000, hget( hTotal, "total_documento" ), "test creacion de factura con incremento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_con_unidades_de_medicion() CLASS TestFacturasClientesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():test_create_factura( uuid )

   SQLFacturasClientesLineasModel():test_create_10_porciento_descuento_15_incremento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 103.500000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_lineas() CLASS TestFacturasClientesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::assert:false( ::oController:Append(), "test creación de factura sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_ventas_por_cajas() CLASS TestFacturasClientesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 501, self:oFolder:aDialogs[1] ):Click(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "0", 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 100, 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Append(), "test creación de factura con ventas por cajas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_tarifa_mayorista() CLASS TestFacturasClientesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 501, self:oFolder:aDialogs[1] ):Click(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "1", 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 100, 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Append(), "test creación de factura con ventas por cajas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_un_solo_pago() CLASS TestFacturasClientesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 501, self:oFolder:aDialogs[1] ):Click(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "1", 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 100, 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Append(), "test creación de factura con un recibo pagado" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_varios_pagos() CLASS TestFacturasClientesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):cText( "2" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 170, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 240, self:oFolder:aDialogs[1] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 501, self:oFolder:aDialogs[1] ):Click(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "1", 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getFacturasClientesLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 300, 0 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Append(), "test creación de factura con varios recibos pagados" )

   ::assert:equals( 3, RecibosRepository():getCountWhereFacturaUuid( ::oController:getModelBuffer( "uuid" ) ), "test comprobacion numeros de recibos" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
