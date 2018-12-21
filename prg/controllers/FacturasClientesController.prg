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

   METHOD initModels()

   METHOD testCalculoFacturaConDescuento()

   METHOD testCalculoFacturaConIncremento()

   METHOD testFacturaConUnidadesDeMedicion()

   METHOD testDialogoWithNoLines()

   METHOD testDialogoVentasPorCajas()

   METHOD testDialogoTarifaMayorista()

   METHOD testDialogoConUnSoloPago( uuid )         VIRTUAL

   METHOD testDialogoConReciboPagado( uuid )       VIRTUAL

   METHOD testDialogoConPlazosCambioImporte( uuid ) VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD initModels() CLASS TestFacturasClientesController

   SQLTercerosModel():truncateTable()
   SQLDireccionesModel():truncateTable()
   SQLAlmacenesModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLFacturasClientesModel():truncateTable()
   SQLFacturasClientesLineasModel():truncateTable()
   SQLFacturasClientesDescuentosModel():truncateTable()
   SQLArticulosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLTercerosModel():testCreateContado()
   SQLTercerosModel():testCreateTarifaMayorista()

   SQLAlmacenesModel():testCreate()
   SQLMetodoPagoModel():testCreateContado()
   SQLArticulosModel():testCreateArticuloConUnidadeDeMedicionCajasPalets()
   SQLArticulosModel():testCreateArticuloConTarifaMayorista()

   SQLArticulosTarifasModel():testCreateTarifaBase()
   SQLArticulosTarifasModel():testCreateTarifaMayorista()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCalculoFacturaConDescuento() CLASS TestFacturasClientesController

   local uuid
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():testCreateFactura( uuid )

   SQLFacturasClientesLineasModel():testCreateIVAal0Con10PorcientoDescuento( uuid )
   SQLFacturasClientesLineasModel():testCreateIVAal10Con15PorcientoDescuento( uuid )
   SQLFacturasClientesLineasModel():testCreateIVAal21Con20PorcientoDescuento( uuid )

   SQLFacturasClientesDescuentosModel():testCreatel0PorCiento( uuid )
   SQLFacturasClientesDescuentosModel():testCreate20PorCiento( uuid )
   SQLFacturasClientesDescuentosModel():testCreate30PorCiento( uuid )

   oController := FacturasClientesController():New()

   hTotal      := oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 112.120000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCalculoFacturaConIncremento() CLASS TestFacturasClientesController

   local uuid
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():testCreateFactura( uuid )

   SQLFacturasClientesLineasModel():testCreateIVAal21ConIncrememtoPrecio( uuid )

   oController := FacturasClientesController():New()

   hTotal      := oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 7.720000, hget( hTotal, "total_documento" ), "test creacion de factura con incremento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testFacturaConUnidadesDeMedicion() CLASS TestFacturasClientesController

   local uuid
   local hTotal
   local oController

   ::initModels()

   uuid        := win_uuidcreatestring()

   SQLFacturasClientesModel():testCreateFactura( uuid )

   SQLFacturasClientesLineasModel():testCreate10PorCientoDescuento15Incremento( uuid )

   oController := FacturasClientesController():New()

   hTotal      := oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 103.500000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoWithNoLines() CLASS TestFacturasClientesController

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

   ::assert:false( oController:Append(), "test creación de factura sin lineas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoVentasPorCajas() CLASS TestFacturasClientesController

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

   ::assert:true( oController:Append(), "test creación de factura con ventas por cajas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoTarifaMayorista() CLASS TestFacturasClientesController

   local oController

   ::initModels()

   oController             := FacturasClientesController():New()

   oController:getDialogView():setEvent( 'painted',;
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
         eval( oController:getFacturasClientesLineasController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , "1", 0 ),;
         apoloWaitSeconds( 1 ),;
         oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         eval( oController:getFacturasClientesLineasController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , 100, 0 ),;
         apoloWaitSeconds( 1 ),;
         oController:getFacturasClientesLineasController():getBrowseView():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( oController:Append(), "test creación de factura con ventas por cajas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
