#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS AlbaranesVentasController FROM OperacionesComercialesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getLinesController()         INLINE ( ::getAlbaranesVentasLineasController() )

   METHOD getDiscountController()      INLINE ( ::getAlbaranesVentasDescuentosController() )

   METHOD isClient()                   INLINE ( .t. )

   METHOD runGenerateFacturaVentas()

   // Impresiones--------------------------------------------------------------

   METHOD getSubject()                 INLINE ( "Albarán de ventas número" )

   METHOD addExtraButtons()

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( ::getModel():cTableName )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLAlbaranesVentasModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := AlbaranesVentasValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := AlbaranesVentasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesVentasController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::cTitle                            := "Albaranes de ventas"

   ::cName                             := "albaranes_ventas"

   ::hImage                            := {  "16" => "gc_albaran_cliente_16",;
                                             "32" => "gc_albaran_cliente_32",;
                                             "48" => "gc_albaran_cliente_48" }

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

   ::super:addExtraButtons()
   
   ::oNavigatorView:getMenuTreeView():addButton( "Generar facturas", "gc_document_gear_16", {|| ::runGenerateFacturaVentas() } )  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runGenerateFacturaVentas() CLASS AlbaranesVentasController

   local oConversorPrepareAlbaranVentasController

   oConversorPrepareAlbaranVentasController  := ConversorPrepareAlbaranVentasController():New( self, ::getFacturasVentasController() )

   oConversorPrepareAlbaranVentasController:Run()

   oConversorPrepareAlbaranVentasController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
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

CLASS AlbaranesVentasConversorController FROM AlbaranesVentasController

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesPreviewBrowseView():New( self ), ), ::oBrowseView )

   METHOD getModel()                  INLINE ( if( empty( ::oModel ), ::oModel := SQLAlbaranesVentasConversorModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestAlbaranesVentasController FROM TestOperacionesComercialesController

   DATA aCategories                    INIT { "all", "albaranes_ventas" }

   METHOD beforeClass()

   METHOD Before()

   METHOD test_dialogo_con_una_linea()

   METHOD test_dialogo_con_articulo_lote()

   METHOD test_dialogo_con_articulo_propiedades() 

   METHOD getController()              INLINE ( if( empty( ::oController ), ::oController := AlbaranesVentasController():New(), ), ::oController ) 

   METHOD End()                        INLINE ( if( !empty( ::oController ), ::oController:End(), ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestAlbaranesVentasController

   Company():setDefaultUsarUbicaciones( .t. )

   ::getController()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestAlbaranesVentasController

   getSQLDatabase():quitForeingKeyChecks() 

   SQLAlbaranesVentasLineasModel():truncateTable()

   SQLAlbaranesVentasDescuentosModel():truncateTable()
   
   SQLAlbaranesVentasModel():truncateTable()

   SQLHistoryModel():truncateTable()

   getSQLDatabase():setForeingKeyChecks() 

RETURN ( ::Super:Before() )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_una_linea() CLASS TestAlbaranesVentasController

   ::getController():getDialogView():setEvent( 'painted',;
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

   ::Assert():true( ::getController():Insert(), "test creación de albaran de compra con una linea" )

   ::Assert():equals( 1, SQLHistoryModel():countHistory( "Creación" ), "Genera un registro en historial con operacion Creación" )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_articulo_lote() CLASS TestAlbaranesVentasController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
      
         ::set_codigo_tercero( "1", view )
      
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
   
   ::Assert():equals( 1, SQLHistoryModel():countHistory( "Creación" ), "Genera un registro en historial con operacion Creación" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_articulo_propiedades() CLASS TestAlbaranesVentasController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
      
         ::set_codigo_tercero( "1", view )
      
         ::set_codigo_forma_pago( "0", view )
      
         ::click_nueva_linea( view )

         ::set_codigo_articulo_en_linea( "3" )

         ::set_combinaciones_en_linea( "3", "S, Azul, Denim" )

         ::set_codigo_ubicacion_en_linea( "0" )

         ::set_precio_en_linea( 300 )

         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creación de albaran de venta con combinaciones" )
   ::Assert():equals( 1, SQLHistoryModel():countHistory( "Creación" ), "Genera un registro en historial con operacion Creación" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

