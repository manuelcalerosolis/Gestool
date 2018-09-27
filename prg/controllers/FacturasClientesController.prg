#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

FUNCTION FacturasClientesController1000()

   local n
   local oController    

   for n := 1 to 1000

      oController          := FacturasClientesController():New()

      oController:ActivateNavigatorView()

      MsgWait( "Please, " + str( n ), "This is a test", 5 )

      oController:closeAllWindows()

      MsgWait( "Please, " + str( n ), "This is a test", 5 )

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

CLASS FacturasClientesController FROM SQLNavigatorController

   DATA oSerieDocumentoComponent

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

   METHOD calculateTotals( uuidFactura )  

   // Contrucciones tardias----------------------------------------------------

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := FacturasClientesView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasClientesValidator():New( self ), ), ::oValidator ) 

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := FacturasClientesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasClientesRepository():New( self ), ), ::oRepository )
   
   METHOD getHistoryManager()          INLINE ( if( empty( ::oHistoryManager ), ::oHistoryManager := HistoryManager():New( self ), ), ::oHistoryManager )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesController

   ::Super:New( oController )

   ::cTitle                                              := "Facturas de clientes"

   ::cName                                               := "facturas_clientes"
   
   ::lTransactional                                      := .t.

   ::lInsertable                                         := .t.

   ::hImage                                              := {  "16" => "gc_document_text_user_16",;
                                                               "32" => "gc_document_text_user_32",;
                                                               "48" => "gc_document_text_user_48" }

   ::oModel                                              := SQLFacturasClientesModel():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBuffer',                    {|| ::loadedBuffer() } )
   ::oModel:setEvent( 'loadedBlankBuffer',               {|| ::loadedBlankBuffer() } )

   ::getDireccionTipoDocumentoController():setEvent( 'activatingDialogView',         {|| ::isClientFilled() } ) 
   ::getDireccionTipoDocumentoController():oModel:setEvent( 'gettingSelectSentence', {|| ::getClientUuid() } )

   ::getFacturasClientesLineasController():setEvent( 'appending',        {|| ::isClientFilled() }  )
   ::getFacturasClientesLineasController():setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

   ::getFacturasClientesDescuentosController():setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

   ::getClientesController():getSelector():setEvent( 'settedHelpText',    {|| ::clientesSettedHelpText() } )
   ::getClientesController():getSelector():setEvent( 'cleanedHelpText',   {|| ::clientesCleanedHelpText() } )

   ::oNumeroDocumentoComponent                           := NumeroDocumentoComponent():New( self )

   ::oSerieDocumentoComponent                            := SerieDocumentoComponent():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

   local nSeconds    := seconds() 

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

   if !empty( ::oHistoryManager )
      ::oHistoryManager:End()
      ::oHistoryManager                                  := nil
   end if 

   if !empty( ::oNumeroDocumentoComponent )
      ::oNumeroDocumentoComponent:End()
      ::oNumeroDocumentoComponent                        := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oNumeroDocumentoComponent" )
   nSeconds    := seconds()

   if !empty( ::oSerieDocumentoComponent )
      ::oSerieDocumentoComponent:End()
      ::oSerieDocumentoComponent                         := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oSerieDocumentoComponent" )
   nSeconds    := seconds()

   ::Super:End()

   logwrite( nSeconds - seconds() )
   logwrite( "::Super:End()" )
   nSeconds    := seconds()

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

   hTotal               := ::oRepository:getTotal( uuidFactura )

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

