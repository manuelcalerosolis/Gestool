#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

FUNCTION FacturasClientesController1000()

   local n
   local oController    

   for n := 1 to 10
      
      FacturasClientesController()


      oController          := FacturasClientesController():New()

      oController:ActivateNavigatorView()

      // MsgWait( "Please, " + str( n ), "This is a test", 5 )

      // oController:closeAllWindows()

      // MsgWait( "Please, " + str( n ), "This is a test", 1 )

      oController:End()

   next 

RETURN ( nil )

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

   METHOD loadedBuffer()               INLINE ( ::getHistoryManager():Set( ::oModel:hBuffer ) )

   METHOD getClientUuid() 

   METHOD isClientFilled()             INLINE ( !empty( ::getModelBuffer( "cliente_codigo" ) ) )

   METHOD clientesSettedHelpText()

   METHOD clientesCleanedHelpText()    

   METHOD clientSetTarifa()

   METHOD clientSetRecargo()

   METHOD clientChangeRecargo( lRecargo )

   METHOD clientSetDescuentos()

   METHOD isLines()
   METHOD isNotLines()                 INLINE ( !::isLines() )

   METHOD getConfigItems()

   METHOD calculateTotals( uuidFactura )  

   // Impresiones--------------------------------------------------------------

   METHOD getDocumentoImpresion()      INLINE ( ::getConfiguracionesController():getModelValue( ::cName, 'documento_impresion', '' ) )

   METHOD getDocumentoPdf()            INLINE ( ::getConfiguracionesController():getModelValue( ::cName, 'documento_pdf', '' ) )

   METHOD getCopiasImpresion()         INLINE ( ::getConfiguracionesController():getModelNumeric( ::cName, 'copias_impresion', 1 ) )

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

   ::lMail                             := .t.

   ::lOthers                           := .t.

   ::hImage                            := {  "16" => "gc_document_text_user_16",;
                                             "32" => "gc_document_text_user_32",;
                                             "48" => "gc_document_text_user_48" }

   ::oNumeroDocumentoComponent         := NumeroDocumentoComponent():New( self )

   ::oSerieDocumentoComponent          := SerieDocumentoComponent():New( self )

   ::loadDocuments()

   ::getModel():setEvent( 'loadedBuffer',        {|| ::loadedBuffer() } )
   ::getModel():setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } )

   ::getDireccionTipoDocumentoController():setEvent( 'activatingDialogView',              {|| ::isClientFilled() } ) 
   ::getDireccionTipoDocumentoController():getModel():setEvent( 'gettingSelectSentence',  {|| ::getClientUuid() } )

   ::getFacturasClientesLineasController():setEvent( 'appending',        {|| ::isClientFilled() }  )
   ::getFacturasClientesLineasController():setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

   ::getClientesController():getSelector():setEvent( 'settedHelpText',    {|| ::clientesSettedHelpText() } )
   ::getClientesController():getSelector():setEvent( 'cleanedHelpText',   {|| ::clientesCleanedHelpText() } )

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS FacturasClientesController 

   hset( ::oModel:hBuffer, "serie",    SQLContadoresModel():getDocumentSerie( ::cName ) )
   
   hset( ::oModel:hBuffer, "numero",   SQLContadoresModel():getDocumentCounter( ::cName ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getClientUuid() CLASS FacturasClientesController 

RETURN ( ::getClientesController():oModel:getUuidWhereCodigo( ::getModelBuffer( "cliente_codigo" ) ) )

//---------------------------------------------------------------------------//

METHOD clientesSettedHelpText() CLASS FacturasClientesController

   if ::getHistoryManager():isEqual( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )
      RETURN ( nil )
   end if         

   ::clientSetTarifa()

   ::clientSetDescuentos()

   ::clientSetRecargo()

   ::getHistoryManager():setkey( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientesCleanedHelpText()  

   ::getArticulosTarifasController():getSelector():cText( space( 20 ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetTarifa() CLASS FacturasClientesController

   local cCodigoTarifa

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

METHOD clientSetDescuentos() CLASS FacturasClientesController

   ::getFacturasClientesDescuentosController():oModel:deleteWhereParentUuid( ::getModelBuffer( "uuid" ) )

   ::getFacturasClientesDescuentosController():oModel:insertWhereClienteCodigo( ::getModelBuffer( "cliente_codigo" ) )

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

   ::oModel:updateFieldWhereId( ::oModel:getBufferColumnKey(), "recargo_equivalencia", ::oModel:hBuffer[ "recargo_equivalencia" ] )

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

   local nLineas  

   nLineas  := ::getFacturasClientesLineasController():oModel:countLinesWhereUuidParent( ::getModelBuffer( 'uuid' ) )

RETURN ( nLineas > 0 )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS FacturasClientesController

   local aItems   := {}

   aadd( aItems,  {  'texto'  => 'Documento impresión',;
                     'clave'  => 'documento_impresion',;
                     'valor'  => ::getDocumentoImpresion(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::aDocuments } )

   aadd( aItems,  {  'texto'  => 'Documento pdf',;
                     'clave'  => 'documento_pdf',;
                     'valor'  => ::getDocumentoPdf(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::aDocuments } )

   aadd( aItems,  {  'texto'  => 'Copias',;
                     'clave'  => 'copias_impresion',;
                     'valor'  => ::getCopiasImpresion(),;
                     'tipo'   => "N" } )

RETURN ( aItems )

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
                        "forma_pago_codigo"  => {  "required"        => "El código de la forma de pago es un dato requerido",;
                                                   "formaPagoExist"  => "El código de la forma de pago no existe" } ,;  
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

