#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasVentasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getFacturasVentasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getFacturasVentasDescuentosController() )

   METHOD isClient()                   INLINE ( .t. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura de venta número" )

   METHOD addExtraButtons()

   METHOD Inserted()

   METHOD Editing( nId )

   METHOD Edited()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "facturas_ventas" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasVentasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasVentasValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasVentasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas de ventas"

   ::cName                             := "facturas_ventas"

   ::hImage                            := {  "16" => "gc_document_text_user_16",;
                                             "32" => "gc_document_text_user_32",;
                                             "48" => "gc_document_text_user_48" }

   ::setEvent( 'inserted', {|| ::Inserted() } )

   ::setEvent( 'editing', {|nId| ::Editing( nId ) } )

   ::setEvent( 'edited', {|| ::Edited() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasVentasController

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

METHOD Inserted() CLASS FacturasVentasController

RETURN ( ::getRecibosGeneratorController():generate() )

//---------------------------------------------------------------------------//

METHOD Edited() CLASS FacturasVentasController 

RETURN ( ::getRecibosGeneratorController():update() )

//---------------------------------------------------------------------------//

METHOD Editing( nId ) CLASS FacturasVentasController

   local uuid
   local nTotalDocumento
   local nRecibosPagados

   uuid                    := ::getUuidFromRowSet()

   if empty( uuid )
      uuid                 := ::getModel():getUuidWhereColumn( nId, "id" )
   end if 

   if empty( uuid )
      RETURN ( .f. )
   end if 

   nRecibosPagados         := RecibosPagosRepository():selectFunctionTotalPaidWhereFacturaUuid( uuid )

   nTotalDocumento         := ::getTotalDocument( uuid )

   if ( nTotalDocumento != 0 .and. nRecibosPagados >= nTotalDocumento )
      msgstop( "La factura esta completamete pagada", "No esta permitida la edición" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS FacturasVentasController

   ::super:addExtraButtons()

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasVentasConversorController FROM FacturasVentasController

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesPreviewBrowseView():New( self ), ), ::oBrowseView )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasVentasValidator FROM OperacionesComercialesValidator

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasVentasValidator

   hset( ::Super:getValidators(),   "tercero_codigo", {  "required"        => "El código del cliente es un dato requerido",;
                                                         "clienteExist"    => "El código del cliente no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestFacturasVentasController FROM TestOperacionesComercialesController

   DATA aCategories                    INIT { "all", "facturas_ventas" }

   METHOD beforeClass()

   METHOD test_dialogo_con_un_solo_pago()

   METHOD test_dialogo_con_varios_pagos()

   // METHOD test_dialogo_con_cambio_de_importe()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestFacturasVentasController
   
   Company():setDefaultUsarUbicaciones( .t. )
   
   ::oController  := FacturasVentasController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_un_solo_pago() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 
         
         ::set_codigo_tercero( "1", view )

         ::set_codigo_forma_pago( "0", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "1" )
         
         ::set_codigo_ubicacion_en_linea( "0" )
         
         ::set_precio_en_linea( 200 )         
         
         view:getControl( IDOK ):Click()          
         
         RETURN ( nil )
      > )

   ::Assert():true( ::oController:Insert(), "test creación de factura con un recibo pagado" )
   
   ::Assert():equals( 1, RecibosRepository():getCountWhereDocumentUuid( ::oController:getModelBuffer( "uuid" ) ), "test comprobacion numeros de recibos" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_varios_pagos() CLASS TestFacturasVentasController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 
      
         ::set_codigo_tercero( "2", view )
      
         ::set_codigo_forma_pago( "0", view )
      
         ::click_nueva_linea( view )

         ::set_codigo_articulo_en_linea( "1" )

         ::set_codigo_ubicacion_en_linea( "0" )

         ::set_precio_en_linea( 300 )

         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   ::Assert():true( ::oController:Insert(), "test creación de factura con varios recibos pagados" )

   ::Assert():equals( 3, RecibosRepository():getCountWhereDocumentUuid( ::oController:getModelBuffer( "uuid" ) ), "test comprobacion numeros de recibos" )

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
METHOD test_dialogo_con_cambio_de_importe() CLASS TestFacturasVentasController

   local id  

   ::test_dialogo_con_varios_pagos()

   id          := ::oController:getModelBuffer( "id" )

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 

         ::set_precio_en_linea( 400 )

         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   ::Assert():true( ::oController:Edit( id ), "test modificacion de factura con nuevo importe" )

   // ::Assert():equals( 3, RecibosRepository():getCountWhereDocumentUuid( ::oController:getModelBuffer( "uuid" ) ), "test comprobacion numeros de recibos" )

RETURN ( nil )
*/
#endif

//---------------------------------------------------------------------------//
