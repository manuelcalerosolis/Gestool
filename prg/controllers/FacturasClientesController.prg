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

   DATA oArticulosTarifasController

   DATA oClientesController

   DATA oArticulosController

   DATA oSerieDocumentoComponent

   DATA oNumeroDocumentoComponent

   DATA oFormasPagoController

   DATA oRutasController

   DATA oAgentesController

   DATA oAlmacenesController

   DATA oContadoresModel

   DATA oClientesTarifasController

   DATA oFacturasClientesDescuentosController

   DATA oDireccionTipoDocumentoController

   DATA oFacturasClientesLineasController

   DATA oCombinacionesController

   DATA oCamposExtraValoresController

   DATA oIncidenciasController

   DATA oHistoryManager

   DATA oTotalConDescuento             INIT 0

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD loadedBlankBuffer() 

   METHOD loadedBuffer()               INLINE ( ::oHistoryManager:Set( ::oModel:hBuffer ) )

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

   ::oDialogView                                         := FacturasClientesView():New( self )

   ::oValidator                                          := FacturasClientesValidator():New( self, ::oDialogView )

   ::oBrowseView                                         := FacturasClientesBrowseView():New( self )

   ::oRepository                                         := FacturasClientesRepository():New( self )

   ::oClientesController                                 := ClientesController():New( self )
   ::oClientesController:setView( ::oDialogView )

   ::oArticulosController                                := ArticulosController():New( self )

   ::oArticulosTarifasController                         := ArticulosTarifasController():New( self )
   ::oArticulosTarifasController:setView( ::oDialogView )

   ::oFormasPagoController                               := FormasPagosController():New( self )   
   ::oFormasPagoController:setView( ::oDialogView )

   ::oRutasController                                    := RutasController():New( self )
   ::oRutasController:setView( ::oDialogView )

   ::oAgentesController                                  := AgentesController():New( self )
   ::oAgentesController:setView( ::oDialogView )

   ::oAlmacenesController                                := AlmacenesController():New( self )
   ::oAlmacenesController:setView( ::oDialogView )

   ::oClientesTarifasController                          := ClientesTarifasController():New( self )

   ::oFacturasClientesLineasController                   := FacturasClientesLineasController():New( self )
   
   ::oFacturasClientesDescuentosController               := FacturasClientesDescuentosController():New( self )

   ::oDireccionTipoDocumentoController                   := DireccionTipoDocumentoController():New( self )

   ::oCamposExtraValoresController                       := CamposExtraValoresController():New( self )

   ::oCombinacionesController                            := CombinacionesController():New( self )

   ::oCamposExtraValoresController                       := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oIncidenciasController                              := IncidenciasController():New( self )

   ::oHistoryManager                                     := HistoryManager():New()

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBuffer',                    {|| ::loadedBuffer() } )
   ::oModel:setEvent( 'loadedBlankBuffer',               {|| ::loadedBlankBuffer() } )

   ::oDireccionTipoDocumentoController:setEvent( 'activatingDialogView',         {|| ::isClientFilled() } ) 
   ::oDireccionTipoDocumentoController:oModel:setEvent( 'gettingSelectSentence', {|| ::getClientUuid() } )

   ::oFacturasClientesLineasController:setEvent( 'appending',        {|| ::isClientFilled() }  )
   ::oFacturasClientesLineasController:setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

   ::oFacturasClientesDescuentosController:setEvent( 'deletedSelection', {|| ::calculateTotals() } ) 

   ::oClientesController:oGetSelector:setEvent( 'settedHelpText',    {|| ::clientesSettedHelpText() } )
   ::oClientesController:oGetSelector:setEvent( 'cleanedHelpText',   {|| ::clientesCleanedHelpText() } )

   ::oNumeroDocumentoComponent                           := NumeroDocumentoComponent():New( self )

   ::oSerieDocumentoComponent                            := SerieDocumentoComponent():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

   local nSeconds

   nSeconds    := seconds()

   if !empty( ::oModel )
      ::oModel:End()
      ::oModel                                           := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "model" )
   nSeconds    := seconds()

   if !empty( ::oDialogView )
      ::oDialogView:End()
      ::oDialogView                                      := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oDialogView" )
   nSeconds    := seconds()

   if !empty( ::oValidator )
      ::oValidator:End()
      ::oValidator                                       := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oValidator" )
   nSeconds    := seconds()

   if !empty( ::oRepository )
      ::oRepository:End()
      ::oRepository                                      := nil
   end if

   logwrite( nSeconds - seconds() )
   logwrite( "oRepository" )
   nSeconds    := seconds()

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
      ::oBrowseView                                      := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oBrowseView" )
   nSeconds    := seconds()

   if !empty( ::oClientesController )
      ::oClientesController:End()
      ::oClientesController                              := nil
   end if

   logwrite( nSeconds - seconds() )
   logwrite( "oClientesController" )
   nSeconds    := seconds()

   if !empty( ::oArticulosController )
      ::oArticulosController:End()
      ::oArticulosController                             := nil
   end if

   logwrite( nSeconds - seconds() )
   logwrite( "oArticulosController" )
   nSeconds    := seconds()

   if !empty( ::oArticulosTarifasController )
      ::oArticulosTarifasController:End()
      ::oArticulosTarifasController                      := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oArticulosTarifasController" )
   nSeconds    := seconds()

   if !empty( ::oFormasPagoController )
      ::oFormasPagoController:End()
      ::oFormasPagoController                            := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oFormasPagoController" )
   nSeconds    := seconds()

   if !empty( ::oRutasController )
      ::oRutasController:End()
      ::oRutasController                                 := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oRutasController" )
   nSeconds    := seconds()

   if !empty( ::oAgentesController )
      ::oAgentesController:End()
      ::oAgentesController                               := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oAgentesController" )
   nSeconds    := seconds()
 
   if !empty( ::oAlmacenesController )
      ::oAlmacenesController:End()
      ::oAlmacenesController                             := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oAlmacenesController" )
   nSeconds    := seconds()

   if !empty( ::oClientesTarifasController )
      ::oClientesTarifasController:End()
      ::oClientesTarifasController                       := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oClientesTarifasController" )
   nSeconds    := seconds()

   if !empty( ::oFacturasClientesDescuentosController )
      ::oFacturasClientesDescuentosController:End()
      ::oFacturasClientesDescuentosController            := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oFacturasClientesDescuentosController" )
   nSeconds    := seconds()

   if !empty( ::oDireccionTipoDocumentoController )
      ::oDireccionTipoDocumentoController:End()
      ::oDireccionTipoDocumentoController                := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oDireccionTipoDocumentoController" )
   nSeconds    := seconds()

   if !empty( ::oCamposExtraValoresController )
      ::oCamposExtraValoresController:End()
      ::oCamposExtraValoresController                    := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oCamposExtraValoresController" )
   nSeconds    := seconds()
   
   if !empty( ::oIncidenciasController )
      ::oIncidenciasController:End()
      ::oIncidenciasController                           := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oIncidenciasController" )
   nSeconds    := seconds()

   if !empty( ::oFacturasClientesLineasController )
      ::oFacturasClientesLineasController:End()
      ::oFacturasClientesLineasController                := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oIncidenciasController" )
   nSeconds    := seconds()

   if !empty( ::oHistoryManager )
      ::oHistoryManager:End()
      ::oHistoryManager                                  := nil
   end if 

   logwrite( nSeconds - seconds() )
   logwrite( "oIncidenciasController" )
   nSeconds    := seconds()

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

RETURN ( ::oClientesController:oModel:getUuidWhereCodigo( ::getModelBuffer( "cliente_codigo" ) ) )

//---------------------------------------------------------------------------//

METHOD clientesSettedHelpText() CLASS FacturasClientesController

   if ::oHistoryManager:isEqual( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )
      RETURN ( nil )
   end if          

   ::clientSetTarifa()

   ::clientSetDescuentos()

   ::clientSetRecargo()

   ::oHistoryManager:setkey( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientesCleanedHelpText()  

   ::oArticulosTarifasController:oGetSelector:cText( space( 20 ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetTarifa() CLASS FacturasClientesController

   local cCodigoTarifa

   if empty( ::oClientesController:oGetSelector:uFields )
      RETURN ( nil )
   end if 

   cCodigoTarifa     := hget( ::oClientesController:oGetSelector:uFields, "tarifa_codigo" )

   if empty( cCodigoTarifa )
      cCodigoTarifa  := Company():getDefaultTarifa()
   end if

   ::oArticulosTarifasController:oGetSelector:cText( cCodigoTarifa )
   
   ::oArticulosTarifasController:oGetSelector:lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetDescuentos() CLASS FacturasClientesController

   ::oFacturasClientesDescuentosController:oModel:deleteWhereParentUuid( ::getModelBuffer( "uuid" ) )

   ::oFacturasClientesDescuentosController:oModel:insertWhereClienteCodigo( ::getModelBuffer( "cliente_codigo" ) )

   ::oFacturasClientesDescuentosController:refreshRowSetAndGoTop()

   ::oFacturasClientesDescuentosController:refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetRecargo() CLASS FacturasClientesController

   if empty( ::oClientesController:oGetSelector:uFields )
      RETURN ( nil )
   end if 

   ::oDialogView:oRecargoEquivalencia:SetCheck( hget( ::oClientesController:oGetSelector:uFields, "recargo_equivalencia" ) )

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

   ::oDialogView:oTotalBruto:setText( hget( hTotal, "totalBruto" ) )
   
   ::oDialogView:oTotalBase:setText( hget( hTotal, "totalNeto" ) )

   ::oDialogView:oTotalDescuento:setText( hget( hTotal, "totalDescuento" ) )

   ::oDialogView:oTotalIva:setText( hget( hTotal, "totalIVA" ) )

   ::oDialogView:oTotalRecargo:setText( hget( hTotal, "totalRecargo" ) )

   ::oDialogView:oTotalImporte:setText( hget( hTotal, "totalDocumento" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isLines() CLASS FacturasClientesController

   local nLineas  

   nLineas  := ::oFacturasClientesLineasController:oModel:countLinesWhereUuidParent( ::getModelBuffer( 'uuid' ) )

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

   ::hValidators  := {  "cliente_codigo"     => {  "required"        => "El c�digo del cliente es un dato requerido",;
                                                   "clienteExist"    => "El c�digo del cliente no existe" } ,;  
                        "forma_pago_codigo"  => {  "required"        => "El c�digo de la forma de pago es un dato requerido",;
                                                   "formaPagoExist"  => "El c�digo de la forma de pago no existe" } ,;  
                        "almacen_codigo"     => {  "required"        => "El c�digo del almac�n es un dato requerido",;
                                                   "almacenExist"    => "El c�digo del almac�n no existe" } ,;  
                        "tarifa_codigo"      => {  "required"        => "El c�digo de la tarifa es un dato requerido",; 
                                                   "tarifaExist"     => "El c�digo de la tarifa no existe" } }  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

