#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasVentasSimplificadasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getFacturasVentasSimplificadasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getFacturasVentasSimplificadasDescuentosController() )

   METHOD isClient()                   INLINE ( .t. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Factura simplificada de venta número" )

   METHOD addExtraButtons()

   METHOD Inserted() 

   METHOD Edited()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( ::getModel():cTableName )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasVentasSimplificadasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := FacturasVentasSimplicadasValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasVentasSimplificadasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasSimplificadasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas simplificadas de ventas"

   ::cName                             := "facturas_simplificadas_ventas"

   ::hImage                            := {  "16" => "gc_ticket_16",;
                                             "32" => "gc_ticket_32",;
                                             "48" => "gc_ticket_48" }

   ::setEvent( 'inserted', {|| ::Inserted() } )

   ::setEvent( 'edited',   {|| ::Edited() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasVentasSimplificadasController

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

METHOD Inserted() CLASS FacturasVentasSimplificadasController

RETURN ( ::getRecibosGeneratorController():generate() )

//---------------------------------------------------------------------------//

METHOD Edited() CLASS FacturasVentasSimplificadasController 

RETURN ( ::getRecibosGeneratorController():update() )

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS FacturasVentasSimplificadasController

   ::super:addExtraButtons()

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasVentasSimplicadasValidator FROM OperacionesComercialesValidator

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasSimplicadasValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasVentasSimplicadasValidator

   hset( ::Super:getValidators(),   "tercero_codigo", {  "required"        => "El código del cliente es un dato requerido",;
                                                         "clienteExist"    => "El código del cliente no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*#ifdef __TEST__

CLASS TestFacturasVentasController FROM TestOperacionesComercialesController

   DATA aCategories                    INIT { "all", "facturas_ventas" }

   METHOD beforeClass()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestFacturasVentasController
   
   Company():setDefaultUsarUbicaciones( .t. )
   
   ::oController  := FacturasVentasController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif*/

//---------------------------------------------------------------------------//
