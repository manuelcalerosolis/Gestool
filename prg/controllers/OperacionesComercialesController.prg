﻿#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesController FROM OperacionesController

   DATA oFacturasClientesFacturaeController

   DATA oIvaDetalleView

   DATA oRectificativaDialogView

   DATA oRectificativaValidator

   DATA uuidDocumentoOrigen

   DATA uuidDocumentoDestino

   DATA idDocumentoDestino

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Editing()

   METHOD getTerceroUuid()

   METHOD isTerceroFilled()            INLINE ( !empty( ::getModelBuffer( "tercero_codigo" ) ) )

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

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    VIRTUAL

   METHOD getModel()                   VIRTUAL

   METHOD getValidator()               VIRTUAL

   METHOD getBrowseView()              VIRTUAL

   METHOD getRepository()              VIRTUAL

   METHOD getIvaDetalleView()          INLINE ( if( empty( ::oIvaDetalleView ), ::oIvaDetalleView := IvaDetalleView():New( self ), ), ::oIvaDetalleView )

   METHOD getContadoresModel()         INLINE ( if( empty( ::oContadoresModel ), ::oContadoresModel := SQLContadoresModel():New( self ), ), ::oContadoresModel )

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

   METHOD getRectificativaDialogView();
                                       INLINE ( if( empty( ::oRectificativaDialogView ), ::oRectificativaDialogView := OperacionComercialRectificarView():New( self ), ), ::oRectificativaDialogView )

   METHOD getRectifictivaValidator()   INLINE (if( empty( ::oRectificativaValidator ), ::oRectificativaValidator := OperacionComercialRectificarValidator():New( self ), ), ::oRectificativaValidator )

   METHOD convertDocument()
      METHOD convertHeader()
      METHOD insertheaderRelation()
      METHOD convertLines()
      METHOD insertLinesRelation( uuidLineOringin, uuidLineDestiny )
      METHOD convertDiscounts()
      METHOD insertDiscountsRelation( uuidLineOringin, uuidLineDestiny )

   METHOD cancelEdited()

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

   ::setEvent( 'editing', {|| ::Editing() } )

   ::setEvent( 'cancelEdited',{|| ::cancelEdited() } )

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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Editing( nId ) CLASS OperacionesComercialesController

   local nTotalDocumento
   local nRecibosPagados

   /*cambie los parametros de ::getUuidFromRowSet() a ::uuidDocumentoDestino*/

   nRecibosPagados         := RecibosPagosRepository():selectFunctionTotalPaidWhereFacturaUuid( ::uuidDocumentoDestino )

   nTotalDocumento         := ::getTotalDocument( ::uuidDocumentoDestino )

   if ( nTotalDocumento != 0 .and. nRecibosPagados >= nTotalDocumento )
      msgstop( "La factura esta completamete pagada", "No esta permitida la edici�n" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cancelEdited() CLASS OperacionesComercialesController

   local uuidDocumentoDestino

   if empty( ::getController() )
      RETURN ( nil )
   end if

   uuidDocumentoDestino := ::getModelBuffer("uuid")

   ::getModel():deleteWhereUiid( uuidDocumentoDestino )

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

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS OperacionesComercialesController

   ::super:addExtraButtons()

   ::oNavigatorView:getMenuTreeView():addButton( "Convertir documento", "gc_document_text_earth_16", {|| ::getConversorDocumentosController():Run() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDocument() CLASS OperacionesComercialesController


   if empty( ::getController() )
      RETURN ( nil )
   end if

   if ::getController:className() == ::className()
      msgstop("No puede seleccionar el mismo tipo de documento")
      RETURN ( nil )
   end if

   ::uuidDocumentoOrigen     := ::getController():getRowSet():fieldGet( "uuid" )

   if empty(::uuidDocumentoOrigen)
      RETURN( nil )
   end if

   ::convertHeader()

   ::convertLines()

   ::convertDiscounts()

   ::Edit( ::idDocumentoDestino )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertHeader() CLASS OperacionesComercialesController

   local hBufferDocumentoOrigen

   hBufferDocumentoOrigen  := ::getController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   hdel( hBufferDocumentoOrigen, 'id' )
   hdel( hBufferDocumentoOrigen, 'uuid' )
   hdel( hBufferDocumentoOrigen, 'fecha' )

   ::getModel():insertBlankBuffer( hBufferDocumentoOrigen )

   ::uuidDocumentoDestino    := ::getModelBuffer( "uuid" )

   ::idDocumentoDestino      := ::getModelBuffer( "id" )

   ::insertheaderRelation()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertheaderRelation()

 SQLConversorDocumentosModel():InsertRelationDocument(  ::uuidDocumentoOrigen, ::getController():getModel():cTableName, ::uuidDocumentoDestino ,::getModel():cTableName )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertLines() CLASS OperacionesComercialesController

   local hLine
   local aLinesDocumentoOrigen
   local uuidOriginLine

   aLinesDocumentoOrigen   := ::getController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if aLinesDocumentoOrigen == nil
      RETURN ( nil )
   end if

   for each hLine in aLinesDocumentoOrigen

         uuidOriginLine := hget( hLine, "uuid" )

         hdel( hLine, 'id' )
         hdel( hLine, 'uuid' )
         hset( hLine, 'parent_uuid', ::uuidDocumentoDestino )

         ::getLinesController():getModel():insertBlankBuffer( hLine )

         ::insertLinesRelation( uuidOriginLine, ::getModelBuffer("uuid") )
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertLinesRelation( uuidLineOringin, uuidLineDestiny ) CLASS OperacionesComercialesController

 SQLConversorDocumentosModel():InsertRelationDocument( uuidLineOringin, ::getController():getLinesController():getModel():cTableName, uuidLineDestiny, ::getLinesController():getModel():cTableName )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDiscounts() CLASS OperacionesComercialesController

   local hDiscount
   local aDiscountsDocumentoOrigen
   local uuidOriginDiscount

   aDiscountsDocumentoOrigen   := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscountsDocumentoOrigen )
      RETURN ( nil )
   end if

   for each hDiscount in aDiscountsDocumentoOrigen

         uuidOriginDiscount:= hget(hDiscount, "uuid")
         hdel( hDiscount, 'id' )
         hdel( hDiscount, 'uuid' )
         hset( hDiscount, 'parent_uuid', ::uuidDocumentoDestino )

         ::getDiscountController():getModel():insertBlankBuffer( hDiscount )

         ::insertDiscountsRelation( uuidOriginDiscount, ::getModelBuffer( "uuid" ) )
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertDiscountsRelation( uuidDiscountOringin, uuidDiscountDestiny ) CLASS OperacionesComercialesController

SQLConversorDocumentosModel():InsertRelationDocument( uuidDiscountOringin, ::getController():getDiscountController():getModel():cTableName, uuidDiscountDestiny, ::getDiscountController():getModel():cTableName )

RETURN ( nil )

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

   ::hValidators  := {  "metodo_pago_codigo" => {  "required"        => "El c�digo del m�todo de pago es un dato requerido",;
                                                   "formaPagoExist"  => "El c�digo del m�todo de pago no existe" } ,;
                        "almacen_codigo"     => {  "required"        => "El c�digo del almac�n es un dato requerido",;
                                                   "almacenExist"    => "El c�digo del almac�n no existe" } ,;
                        "tarifa_codigo"      => {  "required"        => "El c�digo de la tarifa es un dato requerido",;
                                                   "tarifaExist"     => "El c�digo de la tarifa no existe" },;
                        "formulario"         => {  "emptyLines"      => "Las l�neas no pueden estar vacias",;
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

#ifdef __TEST__

CLASS TestOperacionesComercialesController FROM TestOperacionesController

   METHOD set_codigo_cliente( cCodigoCliente, view ) ;
                                       INLINE ( view:getControl( 170, view:oFolder:aDialogs[1] ):cText( cCodigoCliente ),;
                                                apoloWaitSeconds( 1 ),;
                                                view:getControl( 170, view:oFolder:aDialogs[1] ):lValid(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD set_codigo_agente( cCodigoAgente, view ) ;
                                       INLINE ( view:getControl( 270, view:oFolder:aDialogs[1] ):cText( cCodigoAgente ),;
                                                apoloWaitSeconds( 1 ),;
                                                view:getControl( 270, view:oFolder:aDialogs[1] ):lValid(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD set_codigo_forma_pago( cCodigoFormaPago, view ) ;
                                       INLINE ( view:getControl( 240, view:oFolder:aDialogs[1] ):cText( cCodigoFormaPago ),;
                                                apoloWaitSeconds( 1 ),;
                                                view:getControl( 240, view:oFolder:aDialogs[1] ):lValid(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD click_nueva_linea( view )    INLINE ( view:getControl( 501, view:oFolder:aDialogs[1] ):Click(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD click_nuevo_descuento( view ) ;
                                       INLINE ( view:getControl( 601, view:oFolder:aDialogs[1] ):Click(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD set_codigo_articulo_en_linea( cCodigoArticulo ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , cCodigoArticulo, 0 ),;
                                                apoloWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_almacen_en_linea( cCodigoAlmacen ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoAlmacen:bOnPostEdit, , cCodigoAlmacen, 0 ),;
                                                apoloWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_ubicacion_en_linea( cCodigoUbicacion ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoUbicacion:bOnPostEdit, , cCodigoUbicacion, 0 ),;
                                                apoloWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_precio_en_linea( nPrecio ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , nPrecio, 0 ),;
                                                apoloWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_descripcion_descuento( cDescuento ) ;
                                       INLINE ( eval( ::oController:getDiscountController():getBrowseView():oColumnNombre:bOnPostEdit, , cDescuento, 0 ),;
                                                apoloWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_porcentaje_descuento( nDescuento ) ;
                                       INLINE ( eval( ::oController:getDiscountController():getBrowseView():oColumnDescuento:bOnPostEdit, , nDescuento, 0 ),;
                                                apoloWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD refresh_linea_browse_view()  INLINE ( ::oController:getLinesController():getBrowseView():getRowSet():Refresh(),;
                                                apoloWaitSeconds( 1 ) )
/*
   METHOD test_calculo_con_descuento()

   METHOD test_calculo_con_incremento()

   METHOD test_con_unidades_de_medicion()

   METHOD test_dialogo_sin_lineas()

   METHOD test_dialogo_ventas_por_cajas()

   METHOD test_dialogo_tarifa_mayorista()

   METHOD test_dialogo_cambiando_almacen()

   METHOD test_dialogo_cambiando_ubicacion()

   METHOD test_dialogo_cambiando_agente()

   METHOD test_dialogo_con_recargo_en_documento()

   METHOD test_dialogo_con_descuento_en_documento()
*/
END CLASS

//---------------------------------------------------------------------------//
/*
METHOD test_calculo_con_descuento() CLASS TestOperacionesComercialesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid )

   SQLFacturasVentasLineasModel():test_create_IVA_al_0_con_10_descuento( uuid )
   SQLFacturasVentasLineasModel():test_create_IVA_al_10_con_15_porciento_descuento( uuid )
   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_20_porciento_descuento( uuid )

   SQLFacturasVentasDescuentosModel():test_create_l0_por_ciento( uuid )
   SQLFacturasVentasDescuentosModel():test_create_20_por_ciento( uuid )
   SQLFacturasVentasDescuentosModel():test_create_30_por_ciento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 112.120000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_calculo_con_incremento() CLASS TestOperacionesComercialesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid )

   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_incrememto_precio( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 7.720000, hget( hTotal, "total_documento" ), "test creacion de factura con incremento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_con_unidades_de_medicion() CLASS TestOperacionesComercialesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura( uuid )

   SQLFacturasVentasLineasModel():test_create_10_porciento_descuento_15_incremento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 103.500000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_lineas() CLASS TestOperacionesComercialesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "0", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         view:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         view:getControl( IDCANCEL ):Click() } )

   ::assert:false( ::oController:Insert(), "test creaci�n de factura sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_ventas_por_cajas() CLASS TestOperacionesComercialesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "0", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 100 ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Insert(), "test creaci�n de factura con ventas por cajas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_tarifa_mayorista() CLASS TestOperacionesComercialesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 100 ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Insert(), "test creaci�n de factura con ventas por cajas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_cambiando_almacen() CLASS TestOperacionesComercialesController

   local cCodigo

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         ::set_codigo_almacen_en_linea( "1" ),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 200 ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Insert(), "test creaci�n de factura con cambio de almac�n" )

   cCodigo  := ::oController:getLinesController():getModel():getFieldWhere( "almacen_codigo", { "parent_uuid" => ::oController:getModelBuffer( "uuid" ) } )

   ::assert:equals( "1", alltrim( cCodigo ), "test comprobacion cambio almacen en linea" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_cambiando_ubicacion() CLASS TestOperacionesComercialesController

   local cCodigo

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         ::set_codigo_almacen_en_linea( "1" ),;
         ::set_codigo_ubicacion_en_linea( "1" ),;
         ::set_precio_en_linea( 200 ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Insert(), "test creaci�n de factura con cambio de almac�n" )

   cCodigo  := ::oController:getLinesController():getModel():getFieldWhere( "almacen_codigo", { "parent_uuid" => ::oController:getModelBuffer( "uuid" ) } )

   ::assert:equals( "1", alltrim( cCodigo ), "test comprobacion cambio almacen en linea" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_cambiando_agente() CLASS TestOperacionesComercialesController

   local cCodigo

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::set_codigo_agente( "1", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         ::set_codigo_almacen_en_linea( "1" ),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 200 ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Insert(), "test creaci�n de factura con cambio de almac�n" )

   cCodigo  := ::oController:getModel():getFieldWhere( "agente_codigo", { "uuid" => ::oController:getModelBuffer( "uuid" ) } )

   ::assert:equals( "1", alltrim( cCodigo ), "test comprobacion cambio agente" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_recargo_en_documento() CLASS TestOperacionesComercialesController

   local uuid
   local hTotal

   uuid        := win_uuidcreatestring()

   SQLFacturasVentasModel():test_create_factura_con_recargo_de_eqivalencia( uuid )

   SQLFacturasVentasLineasModel():test_create_IVA_al_0_con_10_descuento( uuid )
   SQLFacturasVentasLineasModel():test_create_IVA_al_10_con_15_porciento_descuento( uuid )
   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_20_porciento_descuento( uuid )

   SQLFacturasVentasDescuentosModel():test_create_l0_por_ciento( uuid )
   SQLFacturasVentasDescuentosModel():test_create_20_por_ciento( uuid )

   hTotal      := ::oController:getRepository():getTotalesDocument( uuid )

   ::assert:equals( 199.950000, hget( hTotal, "total_documento" ), "test creacion factura con descuento" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_descuento_en_documento() CLASS TestOperacionesComercialesController

   local cCodigo

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_cliente( "1", view ),;
         ::set_codigo_forma_pago( "0", view ),;
         ::set_codigo_agente( "1", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         ::set_codigo_almacen_en_linea( "1" ),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         ::set_precio_en_linea( 200 ),;
         ::click_nuevo_descuento( view ),;
         ::set_descripcion_descuento( "Descuento" ),;
         ::set_porcentaje_descuento( 15 ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Insert(), "test creaci�n de factura con cambio de almac�n" )

   cCodigo  := ::oController:getModel():getFieldWhere( "agente_codigo", { "uuid" => ::oController:getModelBuffer( "uuid" ) } )

   ::assert:equals( "1", alltrim( cCodigo ), "test comprobacion cambio agente" )

RETURN ( nil )
*/
//---------------------------------------------------------------------------//

#endif
