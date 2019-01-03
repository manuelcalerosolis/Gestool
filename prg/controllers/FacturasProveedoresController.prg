#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasProveedoresController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getTercerosLineasController();
                                       INLINE ( ::getFacturasProveedoresLineasController() )

   METHOD getTercerosDescuentosController();
                                       INLINE ( ::getFacturasProveedoresDescuentosController() )

   METHOD isClient()                   INLINE ( .f. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura de proveedor n�mero" )

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "facturas_proveedor" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasProveedoresModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasProveedorValidator():New( self ), ), ::oValidator ) 

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := FacturasProveedoresBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasProveedoresRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasProveedoresController

   ::Super:New( oController )

   ::cTitle                            := "Facturas de compras"

   ::cName                             := "facturas_proveedores" 

   ::hImage                            := {  "16" => "gc_document_text_businessman_16",;
                                             "32" => "gc_document_text_businessman_32",;
                                             "48" => "gc_document_text_businessman_48" }

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasProveedoresController

   if !empty( ::oModel )
      ::oModel:End()
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasProveedorValidator FROM OperacionesComercialesValidator 

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasProveedorValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasProveedorValidator

   hset( ::Super:getValidators(), "tercero_codigo",   {  "required"        => "El c�digo del proveedor es un dato requerido",;
                                                         "proveedorExist"  => "El c�digo del proveedor no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestFacturasProveedoresController FROM TestCase

   METHOD initModels()

   METHOD testCalculoFacturaConDescuento()

   METHOD testCalculoFacturaConIncremento()

   METHOD testFacturaConUnidadesDeMedicion()

   METHOD testDialogoWithNoLines() 

   METHOD testDialogoVentasPorCajas() 

END CLASS

//---------------------------------------------------------------------------//

METHOD initModels() CLASS TestFacturasProveedoresController

   SQLTercerosModel():truncateTable()
   SQLAlmacenesModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLFacturasClientesLineasModel():truncateTable() 
   SQLFacturasClientesDescuentosModel():truncateTable()
   SQLArticulosModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable()

   SQLTercerosModel():testCreateContado()
   SQLAlmacenesModel():testCreate()
   SQLMetodoPagoModel():test_create_contado()
   SQLArticulosModel():test_create_articulo_con_unidad_de_medicion_cajas_palets()

   SQLArticulosTarifasModel():insertArticulosTarifasBase() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCalculoFacturaConDescuento() CLASS TestFacturasProveedoresController

   local uuid  
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():test_create_factura( uuid ) 

   SQLFacturasClientesLineasModel():test_create_IVA_al_0_con_10_descuento( uuid ) 
   SQLFacturasClientesLineasModel():testCreateIVAal10Con15PorcientoDescuento( uuid ) 
   SQLFacturasClientesLineasModel():testCreateIVAal21Con20PorcientoDescuento( uuid ) 

   SQLFacturasClientesDescuentosModel():test_create_l0_por_ciento( uuid )   
   SQLFacturasClientesDescuentosModel():test_create_20_por_ciento( uuid )   
   SQLFacturasClientesDescuentosModel():test_create_30_por_ciento( uuid )   

   oController := FacturasClientesController():New() 

   hTotal      := oController:getRepository():getTotalesDocument( uuid ) 

   ::assert:equals( 112.120000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCalculoFacturaConIncremento() CLASS TestFacturasProveedoresController

   local uuid  
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():test_create_factura( uuid ) 

   SQLFacturasClientesLineasModel():testCreateIVAal21ConIncrememtoPrecio( uuid ) 

   oController := FacturasClientesController():New() 

   hTotal      := oController:getRepository():getTotalesDocument( uuid ) 

   ::assert:equals( 7.720000, hget( hTotal, "total_documento" ), "test creacion de factura con incremento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testFacturaConUnidadesDeMedicion() CLASS TestFacturasProveedoresController

   local uuid  
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():test_create_factura( uuid ) 

   SQLFacturasClientesLineasModel():testCreate10PorCientoDescuento15Incremento( uuid ) 

   oController := FacturasClientesController():New() 

   hTotal      := oController:getRepository():getTotalesDocument( uuid ) 

   ::assert:equals( 103.500000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoWithNoLines() CLASS TestFacturasProveedoresController

   local oController

   ::initModels()

   oController             := FacturasClientesController():New()

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

   ::assert:false( oController:Append(), "test creaci�n de factura sin lineas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoVentasPorCajas() CLASS TestFacturasProveedoresController

   local oController

   ::initModels()

   oController             := FacturasClientesController():New()

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
         eval( oController:getFacturasClientesLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "0", 0 ),;
         apoloWaitSeconds( 1 ),;
         oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( oController:getFacturasClientesLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 100, 0 ),;
         apoloWaitSeconds( 1 ),;
         oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( oController:Append(), "test creaci�n de factura con ventas por cajas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//


#endif

