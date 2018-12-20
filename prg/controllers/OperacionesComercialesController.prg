#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesController FROM SQLNavigatorController

   DATA oHistoryManager

   DATA oContadoresModel
   
   DATA oSerieDocumentoComponent

   DATA oNumeroDocumentoComponent

   DATA oFacturasClientesFacturaeController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD addExtraButtons()               VIRTUAL

   METHOD editConfig()

   METHOD loadedBlankBuffer() 

   METHOD loadedDuplicateBuffer() 

   METHOD loadedBuffer()                  INLINE ( ::getHistoryManager():Set( ::getModel():hBuffer ) )

   METHOD updatingBuffer()

   METHOD updatedBuffer()

   METHOD getClientUuid() 

   METHOD isClientFilled()                INLINE ( !empty( ::getModelBuffer( "cliente_codigo" ) ) )

   METHOD clientesSettedHelpText()

   METHOD clientSetMetodoPago()   

   METHOD clientSetTarifa()

   METHOD clientSetRuta()

   METHOD clientSetAgente()

   METHOD clientSetRecargo()

   METHOD clientChangeRecargo( lRecargo )

   METHOD changedSerie()  

   METHOD clientSetDescuentos()

   METHOD hasLines()
   METHOD hasNotLines()                   INLINE ( !::hasLines() )

   METHOD getConfigItems()

   METHOD calculateTotals( uuidFactura )  

   METHOD getTotalesDocument( uuidFactura ) ;
                                          INLINE ( ::getRepository():getTotalesDocument( uuidFactura ) )
   
   METHOD getTotalesDocumentGroupByIVA( uuidFactura ) ;
                                          INLINE ( ::getRepository():getTotalesDocumentGroupByIVA( uuidFactura ) )

   METHOD getHashSentenceLineas( uuidFactura ) ;
                                          INLINE ( ::getRepository():getHashSentenceLineas( uuidFactura ) )

   METHOD hasNotPaid( uuidFactura )

   // Impresiones--------------------------------------------------------------

   METHOD getDocumentPrint()              INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_impresion', '' ) )

   METHOD getDocumentPdf()                INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_pdf', '' ) )

   METHOD getDocumentPreview()            INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_previsulizacion', '' ) )

   METHOD getCopyPrint()                  INLINE ( ::getConfiguracionesController():getModelNumeric( ::getName(), 'copias_impresion', 1 ) )

   METHOD getTemplateMails()              INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'plantilla_para_mails', '' ) )
   
   METHOD generateReport( hReport )       INLINE ( ::getReport():Generate( hReport ) )

   METHOD getSubject()                    VIRTUAL

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                       VIRTUAL
   
   METHOD getContadoresModel()            INLINE ( if( empty( ::oContadoresModel ), ::oContadoresModel := SQLContadoresModel():New( self ), ), ::oContadoresModel )

   METHOD getDialogView()                 INLINE ( if( empty( ::oDialogView ), ::oDialogView := OperacionesComercialesView():New( self ), ), ::oDialogView )

   METHOD getModel()                      VIRTUAL

   METHOD getValidator()                  VIRTUAL  

   METHOD getBrowseView()                 VIRTUAL

   METHOD getRepository()                 VIRTUAL  
   
   METHOD getHistoryManager()             INLINE ( if( empty( ::oHistoryManager ), ::oHistoryManager := HistoryManager():New(), ), ::oHistoryManager )
   
   METHOD getReport()                     INLINE ( if( empty( ::oReport ), ::oReport := FacturasClientesReport():New( self ), ), ::oReport )

   METHOD getSerieDocumentoComponent()    INLINE ( if( empty( ::oSerieDocumentoComponent ), ::oSerieDocumentoComponent := SerieDocumentoComponent():New( self ), ), ::oSerieDocumentoComponent )

   METHOD getNumeroDocumentoComponent() ;
                                          INLINE ( if( empty( ::oNumeroDocumentoComponent ), ::oNumeroDocumentoComponent := NumeroDocumentoComponent():New( self ), ), ::oNumeroDocumentoComponent )

   METHOD getFacturasClientesFacturaeController() ;
                                          INLINE ( if( empty( ::oFacturasClientesFacturaeController ), ::oFacturasClientesFacturaeController := FacturasClientesFacturaeController():New( self ), ), ::oFacturasClientesFacturaeController )

   METHOD getTercerosController()         VIRTUAL

   METHOD getTercerosLineasController()   VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS OperacionesComercialesController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::lInsertable                       := .t.

   ::lConfig                           := .t.

   ::lDocuments                        := .t.

   ::lMail                             := .t.

   ::lOthers                           := .t.

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingDeleteButton', { || .f. } )
   ::getNavigatorView():getMenuTreeView():setEvent( 'addedPdfButton', {|| ::addExtraButtons() } )

   ::getModel():setEvent( 'loadedBuffer',          {|| ::loadedBuffer() } )
   ::getModel():setEvent( 'loadedBlankBuffer',     {|| ::loadedBlankBuffer() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer', {|| ::loadedDuplicateBuffer() } )
   ::getModel():setEvent( 'updatedBuffer',         {|| ::updatedBuffer() } )
   ::getModel():setEvent( 'updatingBuffer',        {|| ::updatingBuffer() } )

   ::getDireccionTipoDocumentoController():setEvent( 'activatingDialogView',              {|| ::isClientFilled() } ) 
   ::getDireccionTipoDocumentoController():getModel():setEvent( 'gettingSelectSentence',  {|| ::getClientUuid() } )

   ::getTercerosLineasController():setEvent( 'appending',          {|| ::isClientFilled() } )
   ::getTercerosLineasController():setEvent( 'deletedSelection',   {|| ::calculateTotals() } ) 

   ::getFacturasClientesDescuentosController():setEvent( 'deletedSelection',  {|| ::calculateTotals() } ) 

   ::getTercerosController():getSelector():setEvent( 'settedHelpText', {|| ::clientesSettedHelpText() } )

   ::getSerieDocumentoComponent():setEvents( { 'inserted', 'changedAndExist' }, {|| ::changedSerie() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS OperacionesComercialesController

   if !empty( ::oContadoresModel )
      ::oContadoresModel:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oHistoryManager )
      ::oHistoryManager:End()
   end if 

   if !empty( ::oReport )
      ::oReport:End()
   end if 

   if !empty( ::oConfiguracionesModel )
      ::oConfiguracionesModel:End()
   end if 

   if !empty( ::oNumeroDocumentoComponent )
      ::oNumeroDocumentoComponent:End()
   end if 

   if !empty( ::oSerieDocumentoComponent )
      ::oSerieDocumentoComponent:End()
   end if 

   if !empty( ::oFacturasClientesFacturaeController )
      ::oFacturasClientesFacturaeController:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD editConfig() CLASS OperacionesComercialesController

RETURN ( ::getConfiguracionesController():Edit() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS OperacionesComercialesController 

   ::setModelBuffer( "serie", ::getContadoresModel():getDocumentSerie( ::getName() ) )

   ::setModelBuffer( "numero", ::getModel():maxNumberWhereSerie( ::getModelBuffer( "serie" ) ) )

   ::setModelBuffer( "almacen_codigo", Store():getCodigo() )

   // msgalert( ::getModelBuffer( "serie" ), "serie" )

   // msgalert( ::getModelBuffer( "numero" ), "numero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer() CLASS OperacionesComercialesController 

   // RETURN ( ::setModelBuffer( "numero", ::getModel():maxNumberWhereSerie( ::getModelBuffer( "serie" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatingBuffer() CLASS OperacionesComercialesController 

   if ::isAppendOrDuplicateMode()
      ::setModelBuffer( "numero", ::getModel():maxNumberWhereSerie( ::getModelBuffer( "serie" ) ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatedBuffer() CLASS OperacionesComercialesController 

RETURN ( ::getRecibosGeneratorController():generate() )

//---------------------------------------------------------------------------//

METHOD getClientUuid() CLASS OperacionesComercialesController 

RETURN ( ::getClientesController():getModel():getUuidWhereCodigo( ::getModelBuffer( "cliente_codigo" ) ) )

//---------------------------------------------------------------------------//

METHOD clientesSettedHelpText() CLASS OperacionesComercialesController

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

METHOD clientSetMetodoPago() CLASS OperacionesComercialesController

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

METHOD clientSetTarifa() CLASS OperacionesComercialesController

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

METHOD clientSetRuta() CLASS OperacionesComercialesController

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

METHOD clientSetAgente() CLASS OperacionesComercialesController

   local cCodigoAgente 

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   cCodigoAgente     := hget( ::getClientesController():getSelector():uFields, "agente_codigo" )

   ::getAgentesController():getSelector():cText( cCodigoAgente )
   
   ::getAgentesController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetDescuentos() CLASS OperacionesComercialesController

   ::getFacturasClientesDescuentosController():getModel():deleteWhereParentUuid( ::getModelBuffer( "uuid" ) )

   ::getFacturasClientesDescuentosController():getModel():insertWhereClienteCodigo( ::getModelBuffer( "cliente_codigo" ) )

   ::getFacturasClientesDescuentosController():refreshRowSetAndGoTop()

   ::getFacturasClientesDescuentosController():refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetRecargo() CLASS OperacionesComercialesController

   if empty( ::getClientesController():getSelector():uFields )
      RETURN ( nil )
   end if 

   ::getDialogView():oRecargoEquivalencia:setCheck( hget( ::getClientesController():getSelector():uFields, "recargo_equivalencia" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientChangeRecargo() CLASS OperacionesComercialesController

   ::getModel():updateFieldWhereId( ::getModel():getBufferColumnKey(), "recargo_equivalencia", ::getModelBuffer( "recargo_equivalencia" ) )

   ::calculateTotals()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changedSerie() CLASS OperacionesComercialesController 

   ::getNumeroDocumentoComponent():setValue( ::getModel():maxNumberWhereSerie( ::getModelBuffer( "serie" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidFactura ) CLASS OperacionesComercialesController

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

METHOD hasLines() CLASS OperacionesComercialesController

RETURN ( ::getTercerosLineasController():getModel():countLinesWhereUuidParent( ::getModelBuffer( 'uuid' ) ) > 0 )

//---------------------------------------------------------------------------//

METHOD hasNotPaid( uuidFactura ) CLASS OperacionesComercialesController 

   if ::getModel():totalPaid( uuidFactura ) > 0
      msgstop( "No puede eliminar facturas con pagos efectuados" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS OperacionesComercialesController

   local aItems   := {}

   aadd( aItems,  {  'texto'  => 'Documento impresión',;
                     'clave'  => 'documento_impresion',;
                     'valor'  => ::getDocumentPrint(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Copias impresión',;
                     'clave'  => 'copias_impresion',;
                     'valor'  => ::getCopyPrint(),;
                     'tipo'   => "N" } )

   aadd( aItems,  {  'texto'  => 'Documento pdf',;
                     'clave'  => 'documento_pdf',;
                     'valor'  => ::getDocumentPdf(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Documento previsulización',;
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

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionesComercialesValidator FROM SQLBaseValidator 

   METHOD getValidators()

   METHOD emptyLines()     

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS OperacionesComercialesValidator

   ::hValidators  := {  "metodo_pago_codigo" => {  "required"        => "El código del método de pago es un dato requerido",;
                                                   "formaPagoExist"  => "El código del método de pago no existe" } ,;  
                        "almacen_codigo"     => {  "required"        => "El código del almacén es un dato requerido",;
                                                   "almacenExist"    => "El código del almacén no existe" } ,;  
                        "tarifa_codigo"      => {  "required"        => "El código de la tarifa es un dato requerido",; 
                                                   "tarifaExist"     => "El código de la tarifa no existe" },;
                        "formulario"         => {  "emptyLines"      => "Las líneas no pueden estar vacias",;
                                                   "validLine"       => "" } }  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD emptyLines() CLASS OperacionesComercialesValidator     

RETURN ( ::getController():hasLines() )

//---------------------------------------------------------------------------//

METHOD validLine() CLASS OperacionesComercialesValidator     

RETURN ( ::getController():getTercerosLineasController():validLine() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

