#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS PedidosVentasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getPedidosVentasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getPedidosVentasDescuentosController() )

   METHOD isClient()                   INLINE ( .t. )

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Pedido de ventas número" )

   METHOD addExtraButtons()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "pedidos_venta" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPedidosVentasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := PedidosVentasValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := PedidosVentasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := PedidosVentasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PedidosVentasController

   ::Super:New( oController )

   ::cTitle                            := "Pedidos de ventas"

   ::cName                             := "pedidos_ventas"

   ::hImage                            := {  "16" => "gc_document_text_user_16",;
                                             "32" => "gc_document_text_user_32",;
                                             "48" => "gc_document_text_user_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PedidosVentasController

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

METHOD addExtraButtons() CLASS PedidosVentasController

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturae 3.2", "gc_document_text_earth_16", {|| ::getFacturasClientesFacturaeController():Run( ::getBrowseView():getBrowseSelected() ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PedidosVentasValidator FROM OperacionesComercialesValidator

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PedidosVentasValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PedidosVentasValidator

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
