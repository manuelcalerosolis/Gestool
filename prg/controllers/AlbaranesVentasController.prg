#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS AlbaranesVentasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getAlbaranesVentasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getAlbaranesVentasDescuentosController() )

   METHOD isClient()                   INLINE ( .t. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Albarán de ventas número" )

   METHOD addExtraButtons()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "albaranes_venta" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLAlbaranesVentasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := AlbaranesVentasValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := AlbaranesVentasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := AlbaranesVentasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesVentasController

   ::Super:New( oController )

   ::cTitle                            := "Albaranes de ventas"

   ::cName                             := "albaranes_ventas"

   ::hImage                            := {  "16" => "gc_document_text_user_16",;
                                             "32" => "gc_document_text_user_32",;
                                             "48" => "gc_document_text_user_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AlbaranesVentasController

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

METHOD addExtraButtons() CLASS AlbaranesVentasController

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlbaranesVentasValidator FROM OperacionesComercialesValidator

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesVentasValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AlbaranesVentasValidator

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
