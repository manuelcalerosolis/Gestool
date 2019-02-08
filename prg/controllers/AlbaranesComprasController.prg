#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesComprasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getAlbaranesComprasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getAlbaranesComprasDescuentosController() )

   METHOD isClient()                   INLINE ( .f. )

   METHOD addExtraButtons()

   METHOD RunGenerateFacturaCompras()

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Albarán de compras número" )

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "albaran_compra" )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLAlbaranesComprasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := AlbaranesCompraValidator():New( self ), ), ::oValidator ) 

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := AlbaranesComprasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesComprasController

   ::Super:New( oController )

   ::cTitle                            := "Albaranes de compras"

   ::cName                             := "albaranes_compra" 

   ::hImage                            := {  "16" => "gc_albaran_proveedor_16",;
                                             "32" => "gc_albaran_proveedor_32",;
                                             "48" => "gc_albaran_proveedor_48" }

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS AlbaranesComprasController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS AlbaranesComprasController

   ::super:addExtraButtons()

   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturas", "gc_document_text_businessman_16", {|| ::RunGenerateFacturaCompras() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD RunGenerateFacturaCompras() CLASS AlbaranesComprasController

   local oConversorPrepareController   := ConversorPrepareController():New( self, ::getFacturasComprasController(), ::getUuids() )

   oConversorPrepareController:Run()

   oConversorPrepareController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlbaranesCompraValidator FROM OperacionesComercialesValidator 

   METHOD New( oController )

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesCompraValidator

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AlbaranesCompraValidator

   hset( ::Super:getValidators(), "tercero_codigo",   {  "required"        => "El código del proveedor es un dato requerido",;
                                                         "proveedorExist"  => "El código del proveedor no existe" } )

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestAlbaranesComprasController FROM TestOperacionesComercialesController

   DATA aCategories                    INIT { "all", "albaranes_compras" }

   METHOD beforeClass()

   METHOD Before()

   METHOD test_dialogo_con_una_linea()

   METHOD test_dialogo_con_articulo_lote()

   METHOD test_dialogo_articulo_con_propiedades() 

   METHOD getController()              INLINE ( if( empty( ::oController ), ::oController := AlbaranesComprasController():New(), ), ::oController ) 

   METHOD End()                        INLINE ( if( !empty( ::oController ), ::oController:End(), ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestAlbaranesComprasController

   Company():setDefaultUsarUbicaciones( .t. )

   ::getController()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestAlbaranesComprasController

   SQLAlbaranesComprasModel():truncateTable()

   SQLAlbaranesComprasLineasModel():truncateTable()
   
   SQLAlbaranesComprasDescuentosModel():truncateTable()

RETURN ( ::Super:Before() )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_una_linea() CLASS TestAlbaranesComprasController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         
         ::set_codigo_tercero( "3", view )

         ::set_codigo_forma_pago( "0", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "1" )
         
         ::set_codigo_ubicacion_en_linea( "0" )
         
         ::set_precio_en_linea( 200 )         
         
         view:getControl( IDOK ):Click()          
         
         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creación de albaran de compra con una linea" )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_articulo_lote() CLASS TestAlbaranesComprasController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
      
         ::set_codigo_tercero( "3", view )
      
         ::set_codigo_forma_pago( "0", view )
      
         ::click_nueva_linea( view )

         ::set_codigo_articulo_en_linea( "2" )

         ::set_lote_en_linea( "1234" )

         ::set_codigo_ubicacion_en_linea( "0" )

         ::set_precio_en_linea( 300 )

         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creación de albaran de compra con artículo con lote" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_articulo_con_propiedades() CLASS TestAlbaranesComprasController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
      
         ::set_codigo_tercero( "3", view )
      
         ::set_codigo_forma_pago( "0", view )
      
         ::click_nueva_linea( view )

         ::set_codigo_articulo_en_linea( "3" )

         ::set_combinaciones_en_linea( "3", "S, Azul, Denim" )

         ::set_codigo_ubicacion_en_linea( "0" )

         ::set_precio_en_linea( 300 )

         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creación de albaran de compra con combinaciones" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

