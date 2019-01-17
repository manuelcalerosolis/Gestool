#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasComprasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController();
                                       INLINE ( ::getFacturasComprasLineasController() )

   METHOD getDiscountController();
                                       INLINE ( ::getFacturasComprasDescuentosController() )

   METHOD isClient()                   INLINE ( .f. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura de compras número" )

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "facturas_compra" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasComprasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasCompraValidator():New( self ), ), ::oValidator ) 

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasComprasRepository():New( self ), ), ::oRepository )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasComprasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas de compras"

   ::cName                             := "facturas_compra" 

   ::hImage                            := {  "16" => "gc_document_text_businessman_16",;
                                             "32" => "gc_document_text_businessman_32",;
                                             "48" => "gc_document_text_businessman_48" }

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasComprasController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasCompraValidator FROM OperacionesComercialesValidator 

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasCompraValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasCompraValidator

   hset( ::Super:getValidators(), "tercero_codigo",   {  "required"        => "El código del proveedor es un dato requerido",;
                                                         "proveedorExist"  => "El código del proveedor no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestFacturasComprasController FROM TestCase

   METHOD initModels()

   METHOD testCalculoFacturaConDescuento()

   METHOD testCalculoFacturaConIncremento()

   METHOD testFacturaConUnidadesDeMedicion()

   METHOD testDialogoWithNoLines() 

   METHOD testDialogoVentasPorCajas() 

END CLASS

//---------------------------------------------------------------------------//

METHOD initModels() CLASS TestFacturasComprasController

   SQLTercerosModel():truncateTable()
   SQLAlmacenesModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLFacturasVentasModel():truncateTable() 
   SQLFacturasVentasLineasModel():truncateTable() 
   SQLFacturasVentasDescuentosModel():truncateTable()
   SQLArticulosModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable()

   SQLTercerosModel():test_create_contado()
   SQLAlmacenesModel():test_create()
   SQLMetodoPagoModel():test_create_contado()
   
   SQLArticulosModel():test_create_con_unidad_de_medicion_cajas_palets()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCalculoFacturaConDescuento() CLASS TestFacturasComprasController

   local uuid  
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid ) 

   SQLFacturasVentasLineasModel():test_create_IVA_al_0_con_10_descuento( uuid ) 
   SQLFacturasVentasLineasModel():test_create_IVA_al_10_con_15_porciento_descuento( uuid ) 
   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_20_porciento_descuento( uuid ) 

   SQLFacturasVentasDescuentosModel():test_create_l0_por_ciento( uuid )   
   SQLFacturasVentasDescuentosModel():test_create_20_por_ciento( uuid )   
   SQLFacturasVentasDescuentosModel():test_create_30_por_ciento( uuid )   

   oController := FacturasVentasController():New() 

   hTotal      := oController:getRepository():getTotalesDocument( uuid ) 

   ::assert:equals( 112.120000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCalculoFacturaConIncremento() CLASS TestFacturasComprasController

   local uuid  
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid ) 

   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_incrememto_precio( uuid ) 

   oController := FacturasVentasController():New() 

   hTotal      := oController:getRepository():getTotalesDocument( uuid ) 

   ::assert:equals( 7.720000, hget( hTotal, "total_documento" ), "test creacion de factura con incremento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testFacturaConUnidadesDeMedicion() CLASS TestFacturasComprasController

   local uuid  
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid ) 

   SQLFacturasVentasLineasModel():test_create_10_porciento_descuento_15_incremento( uuid ) 

   oController := FacturasVentasController():New() 

   hTotal      := oController:getRepository():getTotalesDocument( uuid ) 

   ::assert:equals( 103.500000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoWithNoLines() CLASS TestFacturasComprasController

   local oController

   ::initModels()

   oController             := FacturasVentasController():New()

   oController:getDialogView():setEvent( 'painted',;
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

   ::assert:false( oController:Append(), "test creación de factura sin lineas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoVentasPorCajas() CLASS TestFacturasComprasController

   local oController

   ::initModels()

   oController             := FacturasVentasController():New()

   oController:getDialogView():setEvent( 'painted',;
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
         eval( oController:getFacturasVentasLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "0", 0 ),;
         apoloWaitSeconds( 1 ),;
         oController:getFacturasVentasLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( oController:getFacturasVentasLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 100, 0 ),;
         apoloWaitSeconds( 1 ),;
         oController:getFacturasVentasLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( oController:Append(), "test creación de factura con ventas por cajas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//


#endif

