#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientoAlmacenController FROM OperacionesController

   DATA oAlmacenOrigenController

   DATA oAlmacenDestinoController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD editConfig()

   METHOD loadedDuplicateBuffer() 

   METHOD loadedBuffer()               INLINE ( ::getHistoryManager():Set( ::getModel():hBuffer ) )

   METHOD loadedBlankBuffer()

   METHOD insertingBuffer()

   METHOD updatedBuffer()

   METHOD appendLine()

   METHOD changedSerie()  

   METHOD getConfigItems()

   METHOD calculateTotals( uuidDocumento )  

   METHOD getTotalDocument( uuidDocumento ) ;
                                       INLINE ( ::getRepository():getTotalDocument( uuidDocumento ) )

   METHOD getSubject()                 INLINE ( "Movimiento de almacén" )

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "movimiento_almacen" )

   METHOD getLinesController()         INLINE ( ::getMovimientoAlmacenLineasController() )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := MovimientoAlmacenView():New( self ), ), ::oDialogView )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLMovimientosAlmacenesModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := MovimientoAlmacenValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := MovimientoAlmacenBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := MovimientosAlmacenesRepository():New( self ), ), ::oRepository )

   METHOD getAlmacenOrigenController() INLINE ( if( empty( ::oAlmacenOrigenController ), ::oAlmacenOrigenController := AlmacenesController():New( self ), ), ::oAlmacenOrigenController )

   METHOD getAlmacenDestinoController();
                                       INLINE ( if( empty( ::oAlmacenDestinoController ), ::oAlmacenDestinoController := AlmacenesController():New( self ), ), ::oAlmacenDestinoController )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MovimientoAlmacenController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::lConfig                           := .t.

   ::lDocuments                        := .t.

   ::lMail                             := .t.

   ::cTitle                            := "Movimientos de almacén"

   ::cName                             := "movimiento_almacen"

   ::hImage                            := {  "16" => "gc_consolidacion_16",;
                                             "32" => "gc_consolidacion_32",;
                                             "48" => "gc_consolidacion_48" }

   ::getModel():setEvent( 'loadedBuffer',          {|| ::loadedBuffer() } )
   ::getModel():setEvent( 'loadedBlankBuffer',     {|| ::loadedBlankBuffer() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer', {|| ::loadedDuplicateBuffer() } )
   ::getModel():setEvent( 'updatedBuffer',         {|| ::updatedBuffer() } )
   ::getModel():setEvent( 'insertingBuffer',       {|| ::insertingBuffer() } )

   ::getLinesController():setEvent( 'deletedSelection',   {|| ::calculateTotals() } ) 

   ::getSerieDocumentoComponent():setEvents( { 'inserted', 'changedAndExist' }, {|| ::changedSerie() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MovimientoAlmacenController

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oHistoryManager )
      ::oHistoryManager:End()
   end if 

   if !empty( ::oReport )
      ::oReport:End()
   end if 

   if !empty( ::oConfiguracionesModel )
      ::oConfiguracionesModel:End()
   end if 

   if !empty( ::oNumeroDocumentoComponent )
      ::oNumeroDocumentoComponent:End()
   end if 

   if !empty( ::oSerieDocumentoComponent )
      ::oSerieDocumentoComponent:End()
   end if 

   if !empty( ::oAlmacenOrigenController )
      ::oAlmacenOrigenController:End()
   end if 

   if !empty( ::oAlmacenDestinoController )
      ::oAlmacenDestinoController:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD editConfig() CLASS MovimientoAlmacenController

RETURN ( ::getConfiguracionesController():Edit() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS MovimientoAlmacenController 

   ::setModelBuffer( "serie", ::getContadoresModel():getLastSerie( ::getName() ) )

   ::setModelBuffer( "numero", ::getContadoresModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer() CLASS MovimientoAlmacenController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD insertingBuffer() CLASS MovimientoAlmacenController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresModel():getCounterAndIncrement( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD updatedBuffer() CLASS MovimientoAlmacenController 

RETURN ( ::getRecibosGeneratorController():update() )

//---------------------------------------------------------------------------//

METHOD appendLine() CLASS MovimientoAlmacenController

   if empty( ::getModelBuffer( "almacen_origen_codigo" ) )
      msgStop( "El código del almacén origen es un dato requerido" )
      RETURN( nil )
   end if 

   if empty( ::getModelBuffer( "almacen_destino_codigo" ) )
      msgStop( "El código del almacén destino es un dato requerido" )
      RETURN( nil )
   end if 

RETURN ( ::Super:appendLine() ) 

//---------------------------------------------------------------------------//

METHOD changedSerie() CLASS MovimientoAlmacenController 

RETURN ( ::getNumeroDocumentoComponent():setValue( ::getContadoresModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidDocumento ) CLASS MovimientoAlmacenController

   DEFAULT uuidDocumento   := ::getUuid()

   ::getDialogView():oTotalImporte:setText( ::getRepository():selectTotalSummaryWhereUuid( uuidDocumento ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS MovimientoAlmacenController

   local aItems   := {}

   aadd( aItems,  {  'texto'  => 'Documento impresión',;
                     'clave'  => 'documento_impresion',;
                     'valor'  => ::getDocumentPrint(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Copias impresión',;
                     'clave'  => 'copias_impresion',;
                     'valor'  => ::getCopyPrint(),;
                     'tipo'   => "N" } )

   aadd( aItems,  {  'texto'  => 'Documento pdf',;
                     'clave'  => 'documento_pdf',;
                     'valor'  => ::getDocumentPdf(),;
                     'tipo'   => "B",;
                     'lista'  =>  ::loadDocuments() } )

   aadd( aItems,  {  'texto'  => 'Documento previsulización',;
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MovimientoAlmacenValidator FROM SQLBaseValidator 

   METHOD getValidators()

   METHOD emptyLines()     

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS MovimientoAlmacenValidator

   ::hValidators  := {  "almacen_origen_codigo"    => {  "required"        => "El código del almacén origen es un dato requerido",;
                                                         "almacenExist"    => "El código del almacén origen no existe" } ,;  
                        "almacen_destino_codigo"   => {  "required"        => "El código del almacén destino es un dato requerido",;
                                                         "almacenExist"    => "El código del almacén destino no existe" } ,;  
                        "formulario"               => {  "emptyLines"      => "Las líneas no pueden estar vacias",;
                                                         "validLine"       => "" } }  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD emptyLines() CLASS MovimientoAlmacenValidator     

RETURN ( ::getController():hasLines() )

//---------------------------------------------------------------------------//

METHOD validLine() CLASS MovimientoAlmacenValidator     

RETURN ( ::getController():getLinesController():validLine() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestMovimientoAlmacenController FROM TestOperacionesController

   DATA aCategories                    INIT { "all", "movimientos_almacenes" }

   METHOD beforeClass()

   METHOD click_nueva_linea( view )    INLINE ( view:getControl( 501, view:oFolder:aDialogs[1] ):Click(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD set_codigo_almacen( cCodigoAlmacen, view ) ;
                                       INLINE ( view:getControl( 130, view:oFolder:aDialogs[1] ):cText( cCodigoAlmacen ),;
                                                apoloWaitSeconds( 1 ),;
                                                view:getControl( 130, view:oFolder:aDialogs[1] ):lValid(),;
                                                apoloWaitSeconds( 1 ) )

   METHOD set_codigo_articulo_en_linea( cCodigoArticulo ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , cCodigoArticulo, 0 ),;
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

   METHOD refresh_linea_browse_view()  INLINE ( ::oController:getLinesController():getBrowseView():getRowSet():Refresh(),;
                                                apoloWaitSeconds( 1 ) )
   
   METHOD test_dialogo_sin_almacen()                
   
   METHOD test_dialogo_sin_lineas()   

   METHOD test_dialogo_sin_ubicacion()  

   METHOD test_dialogo_articulo_por_cajas_con_ubicacion()              

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestMovimientoAlmacenController
   
   Company():setDefaultUsarUbicaciones( .t. )
   
   ::oController  := MovimientoAlmacenController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_almacen() CLASS TestMovimientoAlmacenController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 
      
      view:getControl( IDOK ):Click()
      
      apoloWaitSeconds( 1 )
   
      view:getControl( IDCANCEL ):Click()

      RETURN ( nil )
      > )

   ::assert:false( ::oController:Append(), "test creación de consolidación sin código almacén" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_lineas() CLASS TestMovimientoAlmacenController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 

      ::set_codigo_almacen( "0", view )

      view:getControl( IDOK ):Click()

      apoloWaitSeconds( 1 )

      view:getControl( IDCANCEL ):Click()

      RETURN ( nil )
      > )

   ::assert:false( ::oController:Append(), "test creación de consolidación sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_ubicacion() CLASS TestMovimientoAlmacenController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_almacen( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "1" ),;
         view:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         view:getControl( IDCANCEL ):Click() } )

   ::assert:false( ::oController:Append(), "test creación de consolidación sin ubicacion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_articulo_por_cajas_con_ubicacion() CLASS TestMovimientoAlmacenController

   ::oController:getDialogView():setEvent( 'painted',;
      {| view | ;
         ::set_codigo_almacen( "0", view ),;
         ::click_nueva_linea( view ),;
         ::set_codigo_articulo_en_linea( "0" ),;
         ::set_codigo_ubicacion_en_linea( "0" ),;
         view:getControl( IDOK ):Click() } )

   ::assert:true( ::oController:Append(), "test creación de consolidación por cajas y con ubicacion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
