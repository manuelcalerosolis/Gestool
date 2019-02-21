#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesController FROM OperacionesController

   DATA oFacturasClientesFacturaeController

   DATA oConversorPrepareGenerico

   DATA oIvaDetalleView

   DATA oRectificativaDialogView

   DATA oRectificativaValidator

   DATA uuidDocumentoOrigen

   DATA uuidDocumentoDestino

   DATA idDocumentoDestino

   DATA aCreatedDocument               INIT {}

   DATA oContadoresController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getTerceroUuid()

   METHOD isTerceroFilled()            INLINE ( !empty( ::getModelBuffer( "tercero_codigo" ) ) )

   METHOD getOrigenController()        INLINE ( ::oController:getOrigenController() )

   METHOD terceroSettedHelpText()

   METHOD terceroSetMetodoPago()

   METHOD terceroSetTarifa()

   METHOD terceroSetRuta()

   METHOD terceroSetAgente()

   METHOD terceroSetRecargo()

   METHOD changeRecargo( lRecargo )

   METHOD terceroSetDescuentos()

   METHOD getConfigItems()

   METHOD calculateTotals( uuidDocumento )

   METHOD getTotalDocument( uuidDocumento ) ;
                                       INLINE ( ::getRepository():getTotalDocument( uuidDocumento ) )

   METHOD getTotalesDocument( uuidDocumento ) ;
                                       INLINE ( ::getRepository():getTotalesDocument( uuidDocumento ) )

   METHOD getTotalesDocumentGroupByIVA( uuidDocumento ) ;
                                       INLINE ( ::getRepository():getTotalesDocumentGroupByIVA( uuidDocumento ) )

   METHOD getHashSentenceLineas( uuidDocumento ) ;
                                       INLINE ( ::getRepository():getHashSentenceLineas( uuidDocumento ) )

   METHOD hasNotPaid( uuidDocumento )

   METHOD importFactura()

   // Impresiones--------------------------------------------------------------

   METHOD getDocumentPrint()           INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_impresion', '' ) )

   METHOD getDocumentPdf()             INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_pdf', '' ) )

   METHOD getDocumentPreview()         INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_previsulizacion', '' ) )

   METHOD getCopyPrint()               INLINE ( ::getConfiguracionesController():getModelNumeric( ::getName(), 'copias_impresion', 1 ) )

   METHOD getTemplateMails()           INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'plantilla_para_mails', '' ) )

   METHOD generateReport( hReport )    INLINE ( ::getReport():Generate( hReport ) )

   METHOD getSubject()                 VIRTUAL

   METHOD addExtraButtons()

   METHOD runGeneratedocument()

   METHOD Editing()

   METHOD cancelEdited()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    VIRTUAL

   METHOD getModel()                   VIRTUAL

   METHOD getValidator()               VIRTUAL

   METHOD getBrowseView()              VIRTUAL

   METHOD getRepository()              VIRTUAL

   METHOD getIvaDetalleView()          INLINE ( if( empty( ::oIvaDetalleView ), ::oIvaDetalleView := IvaDetalleView():New( self ), ), ::oIvaDetalleView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := OperacionesComercialesView():New( self ), ), ::oDialogView )

   METHOD getHistoryManager()          INLINE ( if( empty( ::oHistoryManager ), ::oHistoryManager := HistoryManager():New(), ), ::oHistoryManager )

   METHOD getReport()                  INLINE ( if( empty( ::oReport ), ::oReport := FacturasVentasReport():New( self ), ), ::oReport )

   METHOD getSerieDocumentoComponent() INLINE ( if( empty( ::oSerieDocumentoComponent ), ::oSerieDocumentoComponent := SerieDocumentoComponent():New( self ), ), ::oSerieDocumentoComponent )

   METHOD getNumeroDocumentoComponent() ;
                                       INLINE ( if( empty( ::oNumeroDocumentoComponent ), ::oNumeroDocumentoComponent := NumeroDocumentoComponent():New( self ), ), ::oNumeroDocumentoComponent )

   METHOD getFacturasClientesFacturaeController() ;
                                       INLINE ( if( empty( ::oFacturasClientesFacturaeController ), ::oFacturasClientesFacturaeController := FacturasClientesFacturaeController():New( self ), ), ::oFacturasClientesFacturaeController )

   METHOD getLinesController()         VIRTUAL

   METHOD getDiscountController()      VIRTUAL

   METHOD getSelector()                INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := OperacionesGetSelector():New( self ), ), ::oGetSelector )

   METHOD getRectificativaDialogView() INLINE ( if( empty( ::oRectificativaDialogView ), ::oRectificativaDialogView := OperacionComercialRectificarView():New( self ), ), ::oRectificativaDialogView )

   METHOD getRectifictivaValidator()   INLINE ( if( empty( ::oRectificativaValidator ), ::oRectificativaValidator := OperacionComercialRectificarValidator():New( self ), ), ::oRectificativaValidator )

   METHOD getConversorPreapreGenericoController() ;
                                       INLINE ( if( empty( ::oConversorPrepareGenerico ), ::oConversorPrepareGenerico := ConversorPrepareGenericoController():New( self ), ), ::oConversorPrepareGenerico )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS OperacionesComercialesController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::lInsertable                       := .t.

   ::lConfig                           := .t.

   ::lDocuments                        := .t.

   ::lCanceled                         := .t.

   ::lMail                             := .t.

   ::lOthers                           := .t.

   ::setEvent( 'editing', {|nId| ::Editing( nId ) } )

   ::setEvent( 'cancelEdited', {|| ::cancelEdited() } )

   ::getTercerosController():getSelector():setEvent( 'settedHelpText', {|| ::terceroSettedHelpText() } )

   ::getLinesController():setEvent( 'appending', {|| ::isTerceroFilled() } )
   ::getLinesController():setEvent( 'deletedSelection', {|| ::calculateTotals() } )

   ::getDiscountController():setEvent( 'deletedSelection', {|| ::calculateTotals() } )

   ::getDireccionTipoDocumentoController():setEvent( 'activatingDialogView', {|| ::isTerceroFilled() } )
   ::getDireccionTipoDocumentoController():getModel():setEvent( 'gettingSelectSentence', {|| ::getTerceroUuid() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS OperacionesComercialesController

   if !empty( ::oFacturasClientesFacturaeController )
      ::oFacturasClientesFacturaeController:End()
   end if

   if !empty( ::oConversorPrepareGenerico )
      ::oConversorPrepareGenerico:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Editing( nId ) CLASS OperacionesComercialesController

   if !empty( ::getFieldFromRowSet( "canceled_at" ) )
      errorAlert( "El documento est?cancelado." )
      msgstop( "El documento est?cancelado.", "No esta permitida la edici?" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cancelEdited() CLASS OperacionesComercialesController

   local uuidDocumentoDestino

   if empty( ::getController() )
      RETURN ( nil )
   end if

   if empty( ::getController():getController() )
      RETURN ( nil )
   end if

   uuidDocumentoDestino    := ::getModelBuffer( "uuid" )

   SQLConversorDocumentosModel():deleteWhereDestinoUuid( uuidDocumentoDestino )

   ::getModel():deleteWhereUuid( uuidDocumentoDestino )

   ::getLinesController():getModel():deleteWhereParentUuid( uuidDocumentoDestino )

   ::getDiscountController():getModel():deleteWhereParentUuid( uuidDocumentoDestino )

   ::commitTransactionalMode()

RETURN( nil )

//---------------------------------------------------------------------------//

METHOD getTerceroUuid() CLASS OperacionesComercialesController 

RETURN ( ::getTercerosController():getModel():getUuidWhereCodigo( ::getModelBuffer( "tercero_codigo" ) ) )

//---------------------------------------------------------------------------//

METHOD terceroSettedHelpText() CLASS OperacionesComercialesController

   if ::getHistoryManager():isEqual( "tercero_codigo", ::getModelBuffer( "tercero_codigo" ) )
      RETURN ( nil )
   end if

   ::terceroSetMetodoPago()

   ::terceroSetTarifa()

   ::terceroSetRuta()

   ::terceroSetAgente()

   ::terceroSetDescuentos()

   ::terceroSetRecargo()

   ::getHistoryManager():setkey( "tercero_codigo", ::getModelBuffer( "tercero_codigo" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD terceroSetMetodoPago() CLASS OperacionesComercialesController

   local cCodigoMetodoPago

   cCodigoMetodoPago    := space( 20 )

   if empty( ::getTercerosController():getSelector():uFields )
      RETURN ( nil )
   end if

   cCodigoMetodoPago    := hget( ::getTercerosController():getSelector():uFields, "metodo_pago_codigo" )

   if empty( cCodigoMetodoPago )
      cCodigoMetodoPago := Company():getDefaultMetodoPago()
   end if

   ::getMetodosPagosController():getSelector():cText( cCodigoMetodoPago )

   ::getMetodosPagosController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD terceroSetTarifa() CLASS OperacionesComercialesController

   local cCodigoTarifa

   cCodigoTarifa        := space( 20 )

   if empty( ::getTercerosController():getSelector():uFields )
      RETURN ( nil )
   end if

   cCodigoTarifa        := hget( ::getTercerosController():getSelector():uFields, "tarifa_codigo" )

   if empty( cCodigoTarifa )
      cCodigoTarifa     := Company():getDefaultTarifa()
   end if

   ::getArticulosTarifasController():getSelector():cText( cCodigoTarifa )

   ::getArticulosTarifasController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD terceroSetRuta() CLASS OperacionesComercialesController

   local cCodigoRuta

   cCodigoRuta          := space( 20 )

   if empty( ::getTercerosController():getSelector():uFields )
      RETURN ( nil )
   end if

   cCodigoRuta          := hget( ::getTercerosController():getSelector():uFields, "ruta_codigo" )

   ::getRutasController():getSelector():cText( cCodigoRuta )

   ::getRutasController():getSelector():lValid() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD terceroSetAgente() CLASS OperacionesComercialesController

   local cCodigoAgente

   if empty( ::getTercerosController():getSelector():uFields )
      RETURN ( nil )
   end if

   cCodigoAgente     := hget( ::getTercerosController():getSelector():uFields, "agente_codigo" )

   ::getAgentesController():getSelector():cText( cCodigoAgente )

   ::getAgentesController():getSelector():lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD terceroSetDescuentos() CLASS OperacionesComercialesController

   ::getDiscountController():getModel():deleteWhereParentUuid( ::getModelBuffer( "uuid" ) )

   ::getDiscountController():getModel():insertWhereTerceroCodigo( ::getModelBuffer( "tercero_codigo" ) )

   ::getDiscountController():refreshRowSetAndGoTop()

   ::getDiscountController():refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD terceroSetRecargo() CLASS OperacionesComercialesController

   if empty( ::getTercerosController():getSelector():uFields )
      RETURN ( nil )
   end if

   ::getDialogView():oRecargoEquivalencia:setCheck( hget( ::getTercerosController():getSelector():uFields, "recargo_equivalencia" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeRecargo() CLASS OperacionesComercialesController

   ::getModel():updateFieldWhereId( ::getModel():getBufferColumnKey(), "recargo_equivalencia", ::getModelBuffer( "recargo_equivalencia" ) )

RETURN ( ::calculateTotals() )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidDocumento ) CLASS OperacionesComercialesController

   local hTotal

   DEFAULT uuidDocumento   := ::getUuid()

   hTotal                  := ::getRepository():getTotalesDocument( uuidDocumento )

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

METHOD hasNotPaid( uuidDocumento ) CLASS OperacionesComercialesController

   if ::getModel():totalPaid( uuidDocumento ) > 0
      msgstop( "No puede eliminar facturas con pagos efectuados" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD importFactura() CLASS OperacionesComercialesController

   if ::getRectificativaDialogView():InitActivate() == IDOK

      // Importar factura

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS OperacionesComercialesController

   local aItems   := {}

   aadd( aItems,  {  'texto'  => 'Documento impresi?',;
                     'clave'  => 'documento_impresion',;
                     'valor'  => ::getDocumentPrint(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Copias impresi?',;
                     'clave'  => 'copias_impresion',;
                     'valor'  => ::getCopyPrint(),;
                     'tipo'   => "N" } )

   aadd( aItems,  {  'texto'  => 'Documento pdf',;
                     'clave'  => 'documento_pdf',;
                     'valor'  => ::getDocumentPdf(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Documento previsulizaci?',;
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

METHOD addExtraButtons() CLASS OperacionesComercialesController

   ::super:addExtraButtons()

   ::oNavigatorView:getMenuTreeView():addButton( "Convertir documento", "gc_convertir_documento_16", {|| ::RunGeneratedocument() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runGeneratedocument() CLASS OperacionesComercialesController

   local oConversorPrepareGenericoController   := ConversorPrepareGenericoController():New( self )

   oConversorPrepareGenericoController:Run()

   oConversorPrepareGenericoController:End()

RETURN ( nil )

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

RETURN ( ::getController():getLinesController():validLine() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestOperacionesComercialesController FROM TestOperacionesController

   METHOD set_codigo_tercero( cCodigoCliente, view ) ;
                                       INLINE ( view:getControl( 170, view:oFolder:aDialogs[1] ):cText( cCodigoCliente ),;
                                                testWaitSeconds(),;
                                                view:getControl( 170, view:oFolder:aDialogs[1] ):lValid(),;
                                                testWaitSeconds() )

   METHOD set_codigo_agente( cCodigoAgente, view ) ;
                                       INLINE ( view:getControl( 270, view:oFolder:aDialogs[1] ):cText( cCodigoAgente ),;
                                                testWaitSeconds(),;
                                                view:getControl( 270, view:oFolder:aDialogs[1] ):lValid(),;
                                                testWaitSeconds() )

   METHOD set_codigo_forma_pago( cCodigoFormaPago, view ) ;
                                       INLINE ( view:getControl( 240, view:oFolder:aDialogs[1] ):cText( cCodigoFormaPago ),;
                                                testWaitSeconds(),;
                                                view:getControl( 240, view:oFolder:aDialogs[1] ):lValid(),;
                                                testWaitSeconds() )

   METHOD click_nueva_linea( view )    INLINE ( view:getControl( 501, view:oFolder:aDialogs[1] ):Click(),;
                                                testWaitSeconds() )

   METHOD click_nuevo_descuento( view ) ;
                                       INLINE ( view:getControl( 601, view:oFolder:aDialogs[1] ):Click(),;
                                                testWaitSeconds() )

   METHOD set_codigo_articulo_en_linea( cCodigoArticulo ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , cCodigoArticulo, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_almacen_en_linea( cCodigoAlmacen ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoAlmacen:bOnPostEdit, , cCodigoAlmacen, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_ubicacion_en_linea( cCodigoUbicacion ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoUbicacion:bOnPostEdit, , cCodigoUbicacion, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_precio_en_linea( nPrecio ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , nPrecio, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_descripcion_descuento( cDescuento ) ;
                                       INLINE ( eval( ::oController:getDiscountController():getBrowseView():oColumnNombre:bOnPostEdit, , cDescuento, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD set_porcentaje_descuento( nDescuento ) ;
                                       INLINE ( eval( ::oController:getDiscountController():getBrowseView():oColumnDescuento:bOnPostEdit, , nDescuento, 0 ),;
                                                testWaitSeconds(),;
                                                ::refresh_linea_browse_view() )

   METHOD refresh_linea_browse_view()  INLINE ( ::oController:getLinesController():getBrowseView():getRowSet():Refresh(),;
                                                testWaitSeconds() )
   
END CLASS

//---------------------------------------------------------------------------//

#endif
