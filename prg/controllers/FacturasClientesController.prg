#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getTercerosController()         INLINE ( ::getClientesController() )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura de cliente n�mero" )

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

   ::cTitle                            := "Facturas de clientes"

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
<<<<<<< HEAD

METHOD addExtraButtons() CLASS FacturasClientesController

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD editConfig()

RETURN ( ::getConfiguracionesController():Edit() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS FacturasClientesController 

   ::setModelBuffer( "serie", SQLContadoresModel():getDocumentSerie( ::getName() ) )

   ::setModelBuffer( "numero", SQLContadoresModel():getPosibleNext( ::getName(), ::getModelBuffer( "serie" ) ) )

   ::setModelBuffer( "almacen_codigo", Store():getCodigo() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer() CLASS FacturasClientesController 

RETURN ( ::setModelBuffer( "numero", SQLContadoresModel():getPosibleNext( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD updatingBuffer() CLASS FacturasClientesController 

   if ::isAppendOrDuplicateMode()
      ::setModelBuffer( "numero", SQLContadoresModel():getNext( ::getName(), ::getModelBuffer( "serie" ) ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatedBuffer() CLASS FacturasClientesController 

RETURN ( ::getRecibosGeneratorController():generate() )

//---------------------------------------------------------------------------//

METHOD getClientUuid() CLASS FacturasClientesController 

RETURN ( ::getClientesController():oModel:getUuidWhereCodigo( ::getModelBuffer( "cliente_codigo" ) ) )

//---------------------------------------------------------------------------//

METHOD clientesSettedHelpText() CLASS FacturasClientesController

   if ::getHistoryManager():isEqual( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )
      RETURN ( nil )
   end if         

   ::clientSetMetodoPago()

   ::clientSetTarifa()
   
   ::clientSetRuta()

   ::clientSetAgente()

   ::clientSetDescuentos()

   ::clientSetRecargo()

   ::getHistoryManager():setkey( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetMetodoPago() CLASS FacturasClientesController

   local cCodigoMetodoPago

   cCodigoMetodoPago    := space( 20 )

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   cCodigoMetodoPago    := hget( ::getClientesController():getSelector():uFields, "metodo_pago_codigo" )

   if empty( cCodigoMetodoPago )
      cCodigoMetodoPago := Company():getDefaultMetodoPago()
   end if

   ::getMetodosPagosController():getSelector():cText( cCodigoMetodoPago )
   
   ::getMetodosPagosController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetTarifa() CLASS FacturasClientesController

   local cCodigoTarifa

   cCodigoTarifa     := space( 20 )

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   cCodigoTarifa     := hget( ::getClientesController():getSelector():uFields, "tarifa_codigo" )

   if empty( cCodigoTarifa )
      cCodigoTarifa  := Company():getDefaultTarifa()
   end if

   ::getArticulosTarifasController():getSelector():cText( cCodigoTarifa )
   
   ::getArticulosTarifasController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetRuta() CLASS FacturasClientesController

   local cCodigoRuta

   cCodigoRuta       := space( 20 )

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   cCodigoRuta       := hget( ::getClientesController():getSelector():uFields, "ruta_codigo" )

   ::getRutasController():getSelector():cText( cCodigoRuta )
   
   ::getRutasController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetAgente() CLASS FacturasClientesController

   local cCodigoAgente

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   cCodigoAgente     := hget( ::getClientesController():getSelector():uFields, "agente_codigo" )

   ::getAgentesController():getSelector():cText( cCodigoAgente )
   
   ::getAgentesController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetDescuentos() CLASS FacturasClientesController

   ::getFacturasClientesDescuentosController():getModel():deleteWhereParentUuid( ::getModelBuffer( "uuid" ) )

   ::getFacturasClientesDescuentosController():getModel():insertWhereClienteCodigo( ::getModelBuffer( "cliente_codigo" ) )

   ::getFacturasClientesDescuentosController():refreshRowSetAndGoTop()

   ::getFacturasClientesDescuentosController():refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetRecargo() CLASS FacturasClientesController

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   ::getDialogView():oRecargoEquivalencia:setCheck( hget( ::getClientesController():getSelector():uFields, "recargo_equivalencia" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientChangeRecargo() CLASS FacturasClientesController

   ::getModel():updateFieldWhereId( ::getModel():getBufferColumnKey(), "recargo_equivalencia", ::getModelBuffer( "recargo_equivalencia" ) )

   ::calculateTotals()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changedSerie() CLASS FacturasClientesController 

RETURN ( ::getNumeroDocumentoComponent():setValue( SQLContadoresModel():getPosibleNext( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidFactura ) CLASS FacturasClientesController

   local hTotal

   DEFAULT uuidFactura  := ::getUuid()

   hTotal               := ::getRepository():getTotalesDocument( uuidFactura )

   if empty( hTotal )
      RETURN ( nil )
   end if 

   ::getDialogView():oTotalBruto:setText( hget( hTotal, "total_bruto" ) )
   
   ::getDialogView():oTotalBase:setText( hget( hTotal, "total_neto" ) )

   ::getDialogView():oTotalDescuento:setText( hget( hTotal, "total_descuento" ) )

   ::getDialogView():oTotalIva:setText( hget( hTotal, "total_iva" ) )

   ::getDialogView():oTotalRecargo:setText( hget( hTotal, "total_recargo" ) )

   ::getDialogView():oTotalImporte:setText( hget( hTotal, "total_documento" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD hasLines() CLASS FacturasClientesController

RETURN ( ::getFacturasClientesLineasController():getModel():countLinesWhereUuidParent( ::getModelBuffer( 'uuid' ) ) > 0 )

//---------------------------------------------------------------------------//

METHOD hasNotPaid( uuidFactura ) CLASS FacturasClientesController 

   if ::getModel():totalPaid( uuidFactura ) > 0
      msgstop( "No puede eliminar facturas con pagos efectuados" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS FacturasClientesController

   local aItems   := {}

   aadd( aItems,  {  'texto'  => 'Documento impresi�n',;
                     'clave'  => 'documento_impresion',;
                     'valor'  => ::getDocumentPrint(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Copias impresi�n',;
                     'clave'  => 'copias_impresion',;
                     'valor'  => ::getCopyPrint(),;
                     'tipo'   => "N" } )

   aadd( aItems,  {  'texto'  => 'Documento pdf',;
                     'clave'  => 'documento_pdf',;
                     'valor'  => ::getDocumentPdf(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Documento previsulizaci�n',;
                     'clave'  => 'documento_previsulizacion',;
                     'valor'  => ::getDocumentPreview(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Plantilla para mails',;
                     'clave'  => 'plantilla_para_mails',;
                     'valor'  => ::getTemplateMails(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadTemplatesHTML() } )

RETURN ( aItems )

=======
>>>>>>> 001e026ed906d2fab245e753da0a493b71a9f562
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesValidator FROM SQLBaseValidator 

   METHOD getValidators()

   METHOD emptyLines()     

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesValidator

   ::hValidators  := {  "cliente_codigo"     => {  "required"        => "El c�digo del cliente es un dato requerido",;
                                                   "clienteExist"    => "El c�digo del cliente no existe" } ,;  
                        "metodo_pago_codigo" => {  "required"        => "El c�digo del m�todo de pago es un dato requerido",;
                                                   "formaPagoExist"  => "El c�digo del m�todo de pago no existe" } ,;  
                        "almacen_codigo"     => {  "required"        => "El c�digo del almac�n es un dato requerido",;
                                                   "almacenExist"    => "El c�digo del almac�n no existe" } ,;  
                        "tarifa_codigo"      => {  "required"        => "El c�digo de la tarifa es un dato requerido",; 
                                                   "tarifaExist"     => "El c�digo de la tarifa no existe" },;
                        "formulario"         => {  "emptyLines"      => "Las l�neas no pueden estar vacias",;
                                                   "validLine"       => "" } }  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD emptyLines() CLASS FacturasClientesValidator     

RETURN ( ::getController():hasLines() )

//---------------------------------------------------------------------------//

METHOD validLine() CLASS FacturasClientesValidator     

RETURN ( ::getController():getFacturasClientesLineasController():validLine() )

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

END CLASS

//---------------------------------------------------------------------------//

METHOD initModels() CLASS TestFacturasClientesController

   SQLClientesModel():truncateTable()
   SQLDireccionesModel():truncateTable()
   SQLAlmacenesModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLFacturasClientesLineasModel():truncateTable() 
   SQLFacturasClientesDescuentosModel():truncateTable()
   SQLArticulosModel():truncateTable()
   
   SQLArticulosTarifasModel():truncateTable() 

   SQLClientesModel():testCreateContado()
   SQLClientesModel():testCreateTarifaMayorista()

   SQLAlmacenesModel():testCreate()
   SQLMetodoPagoModel():testCreateContado()
   SQLArticulosModel():testCreateArticuloConUnidadeDeMedicionCajasPalets()
   SQLArticulosModel():testCreateArticuloConTarifaMayorista()

   SQLArticulosTarifasModel():insertTarifaBase() 

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

   ::assert:false( oController:Append(), "test creaci�n de factura sin lineas" )

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

   ::assert:true( oController:Append(), "test creaci�n de factura con ventas por cajas" )

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

   ::assert:true( oController:Append(), "test creaci�n de factura con ventas por cajas" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

