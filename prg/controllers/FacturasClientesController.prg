#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesController FROM SQLNavigatorController

   DATA oSerieDocumentoComponent

   DATA oHistoryManager

   DATA oNumeroDocumentoComponent

   DATA oContadoresModel

   DATA oTotalConDescuento             INIT 0

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD loadedBlankBuffer() 

   METHOD loadedBuffer()               INLINE ( ::getHistoryManager():Set( ::getModel():hBuffer ) )

   METHOD updatingBuffer()

   METHOD updatedBuffer()

   METHOD getClientUuid() 

   METHOD isClientFilled()             INLINE ( !empty( ::getModelBuffer( "cliente_codigo" ) ) )

   METHOD clientesSettedHelpText()

   METHOD clientSetMetodoPago()   

   METHOD clientSetTarifa()

   METHOD clientSetRuta()

   METHOD clientSetAgente()

   METHOD clientSetRecargo()

   METHOD clientChangeRecargo( lRecargo )

   METHOD clientSetDescuentos()

   METHOD isLines()
   METHOD isNotLines()                 INLINE ( !::isLines() )

   METHOD getConfigItems()

   METHOD calculateTotals( uuidFactura )  

   // Impresiones--------------------------------------------------------------

   METHOD getDocumentPrint()           INLINE ( ::getConfiguracionesController():getModelValue( ::cName, 'documento_impresion', '' ) )

   METHOD getDocumentPdf()             INLINE ( ::getConfiguracionesController():getModelValue( ::cName, 'documento_pdf', '' ) )

   METHOD getDocumentPreview()         INLINE ( ::getConfiguracionesController():getModelValue( ::cName, 'documento_previsulizacion', '' ) )

   METHOD getCopyPrint()               INLINE ( ::getConfiguracionesController():getModelNumeric( ::cName, 'copias_impresion', 1 ) )

   METHOD getTemplateMails()           INLINE ( ::getConfiguracionesController():getModelValue( ::cName, 'plantilla_para_mails', '' ) )
   
   METHOD generateReport( hReport )    INLINE ( ::getReport():Generate( hReport ) )

   METHOD getSubject()                 INLINE ( "Factura de cliente número" )

   // Contrucciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasClientesModel():New( self ), ), ::oModel )

   METHOD getContadoresModel()         INLINE ( if( empty( ::oContadoresModel ), ::oContadoresModel := SQLContadoresModel():New( self ), ), ::oContadoresModel )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := FacturasClientesView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasClientesValidator():New( self ), ), ::oValidator ) 

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := FacturasClientesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasClientesRepository():New( self ), ), ::oRepository )
   
   METHOD getHistoryManager()          INLINE ( if( empty( ::oHistoryManager ), ::oHistoryManager := HistoryManager():New(), ), ::oHistoryManager )
   
   METHOD getReport()                  INLINE ( if( empty( ::oReport ), ::oReport := FacturasClientesReport():New( self ), ), ::oReport )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesController

   ::Super:New( oController )

   ::cTitle                            := "Facturas de clientes"

   ::cName                             := "facturas_clientes"
   
   ::lTransactional                    := .t.

   ::lInsertable                       := .t.

   ::lConfig                           := .t.

   ::lDocuments                        := .t.

   ::lMail                             := .t.

   ::lOthers                           := .t.

   ::hImage                            := {  "16" => "gc_document_text_user_16",;
                                             "32" => "gc_document_text_user_32",;
                                             "48" => "gc_document_text_user_48" }

   ::oSerieDocumentoComponent          := SerieDocumentoComponent():New( self )

   ::oNumeroDocumentoComponent         := NumeroDocumentoComponent():New( self )

   ::getModel():setEvent( 'loadedBuffer',       {|| ::loadedBuffer() } )
   ::getModel():setEvent( 'loadedBlankBuffer',  {|| ::loadedBlankBuffer() } )
   ::getModel():setEvent( 'updatingBuffer',     {|| ::updatingBuffer() } )
   ::getModel():setEvent( 'updatedBuffer',      {|| ::updatedBuffer() } )

   ::getDireccionTipoDocumentoController():setEvent( 'activatingDialogView',              {|| ::isClientFilled() } ) 
   ::getDireccionTipoDocumentoController():getModel():setEvent( 'gettingSelectSentence',  {|| ::getClientUuid() } )

   ::getFacturasClientesLineasController():setEvent( 'appending',        {|| ::isClientFilled() }  )
   ::getFacturasClientesLineasController():setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

   ::getClientesController():getSelector():setEvent( 'settedHelpText',    {|| ::clientesSettedHelpText() } )

   ::getFacturasClientesDescuentosController():setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oContadoresModel )
      ::oContadoresModel:End()
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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS FacturasClientesController 

   ::setModelBuffer( "serie", SQLContadoresModel():getDocumentSerie( ::cName ) )

   ::setModelBuffer( "numero", SQLContadoresModel():getPosibleNext( ::cName, ::getModelBuffer( "serie" ) ) )

   ::setModelBuffer( "almacen_codigo", Store():getCodigo() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatingBuffer() CLASS FacturasClientesController 

   msgalert( ::getModelBuffer( "serie" ), "serie" )
   msgalert( ::getModel():hBuffer[ "serie" ], "con get" )

   if ::isAppendMode()
      ::setModelBuffer( "numero", SQLContadoresModel():getNext( ::cName, ::getModelBuffer( "serie" ) ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatedBuffer() CLASS FacturasClientesController 

   ::getRecibosGeneratorController():getMetodoPago()

RETURN ( nil )

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

   ::getDialogView():oRecargoEquivalencia:SetCheck( hget( ::getClientesController():getSelector():uFields, "recargo_equivalencia" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientChangeRecargo() CLASS FacturasClientesController

   ::getModel():updateFieldWhereId( ::getModel():getBufferColumnKey(), "recargo_equivalencia", ::getModel():hBuffer[ "recargo_equivalencia" ] )

   ::calculateTotals()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidFactura ) CLASS FacturasClientesController

   local hTotal

   DEFAULT uuidFactura  := ::getUuid()

   hTotal               := ::getRepository():getTotal( uuidFactura )

   if empty( hTotal )
      RETURN ( nil )
   end if 

   ::getDialogView():oTotalBruto:setText( hget( hTotal, "totalBruto" ) )
   
   ::getDialogView():oTotalBase:setText( hget( hTotal, "totalNeto" ) )

   ::getDialogView():oTotalDescuento:setText( hget( hTotal, "totalDescuento" ) )

   ::getDialogView():oTotalIva:setText( hget( hTotal, "totalIVA" ) )

   ::getDialogView():oTotalRecargo:setText( hget( hTotal, "totalRecargo" ) )

   ::getDialogView():oTotalImporte:setText( hget( hTotal, "totalDocumento" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isLines() CLASS FacturasClientesController

RETURN ( ::getFacturasClientesLineasController():getModel():countLinesWhereUuidParent( ::getModelBuffer( 'uuid' ) ) > 0 )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS FacturasClientesController

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

CLASS FacturasClientesValidator FROM SQLBaseValidator 

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesValidator

   ::hValidators  := {  "cliente_codigo"     => {  "required"        => "El código del cliente es un dato requerido",;
                                                   "clienteExist"    => "El código del cliente no existe" } ,;  
                        "metodo_pago_codigo" => {  "required"        => "El código del método de pago es un dato requerido",;
                                                   "formaPagoExist"  => "El código del método de pago no existe" } ,;  
                        "almacen_codigo"     => {  "required"        => "El código del almacén es un dato requerido",;
                                                   "almacenExist"    => "El código del almacén no existe" } ,;  
                        "tarifa_codigo"      => {  "required"        => "El código de la tarifa es un dato requerido",; 
                                                   "tarifaExist"     => "El código de la tarifa no existe" } }  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

