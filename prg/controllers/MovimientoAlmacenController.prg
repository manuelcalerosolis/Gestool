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

   METHOD appendLine()

   METHOD changedSerie()  

   METHOD getConfigItems()

   METHOD calculateTotals( uuidDocumento )  

   METHOD getTotalDocument( uuidDocumento ) ;
                                       INLINE ( ::getRepository():getTotalDocument( uuidDocumento ) )

   METHOD getSubject()                 INLINE ( "Movimiento de almac�n" )

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

   ::lInsertable                       := .t.

   ::lConfig                           := .t.

   ::lDocuments                        := .t.

   ::lMail                             := .t.

   ::cTitle                            := "Movimientos de almac�n"

   ::cName                             := "movimiento_almacen"

   ::hImage                            := {  "16" => "gc_consolidacion_16",;
                                             "32" => "gc_consolidacion_32",;
                                             "48" => "gc_consolidacion_48" }

   ::getModel():setEvent( 'loadedBuffer',          {|| ::loadedBuffer() } )
   ::getModel():setEvent( 'loadedBlankBuffer',     {|| ::loadedBlankBuffer() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer', {|| ::loadedDuplicateBuffer() } )
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

   ::setModelBuffer( "serie", ::getContadoresController():getModel():getLastSerie( ::getName() ) )

   ::setModelBuffer( "numero", ::getContadoresController():getModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer() CLASS MovimientoAlmacenController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresController():getModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD insertingBuffer() CLASS MovimientoAlmacenController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresController():getModel():getCounterAndIncrement( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD appendLine() CLASS MovimientoAlmacenController

   if empty( ::getModelBuffer( "almacen_origen_codigo" ) )
      ::getDialogView():showMessage( "El c�digo del almac�n origen es un dato requerido" )   
      RETURN( nil )
   end if 

   if empty( ::getModelBuffer( "almacen_destino_codigo" ) )
      ::getDialogView():showMessage( "El c�digo del almac�n destino es un dato requerido" )
      RETURN( nil )
   end if 

RETURN ( ::Super:appendLine() ) 

//---------------------------------------------------------------------------//

METHOD changedSerie() CLASS MovimientoAlmacenController 

RETURN ( ::getNumeroDocumentoComponent():setValue( ::getContadoresController():getModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidDocumento ) CLASS MovimientoAlmacenController

   DEFAULT uuidDocumento   := ::getUuid()

   ::getDialogView():oTotalImporte:setText( ::getRepository():selectTotalSummaryWhereUuid( uuidDocumento ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS MovimientoAlmacenController

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

   ::hValidators  := {  "almacen_origen_codigo"    => {  "required"        => "El c�digo del almac�n origen es un dato requerido",;
                                                         "almacenExist"    => "El c�digo del almac�n origen no existe" } ,;  
                        "almacen_destino_codigo"   => {  "required"        => "El c�digo del almac�n destino es un dato requerido",;
                                                         "almacenExist"    => "El c�digo del almac�n destino no existe" } ,;  
                        "formulario"               => {  "emptyLines"      => "Las l�neas no pueden estar vacias",;
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

   METHOD afterClass()

   METHOD before()

   METHOD getController()              INLINE   ( if( empty( ::oController ), ::oController := MovimientoAlmacenController():New(), ), ::oController )

   METHOD End()                        INLINE ( if( !empty( ::oController ), ::oController:End(), ) ) 

   METHOD click_nueva_linea( view )    INLINE   (  view:getControl( 501, view:oFolder:aDialogs[1] ):Click(),;
                                                   testWaitSeconds() )

   METHOD set_codigo_almacen_origen( cCodigoAlmacen, view ) ;
                                       INLINE   (  view:getControl( 130, view:oFolder:aDialogs[1] ):cText( cCodigoAlmacen ),;
                                                   testWaitSeconds(),;
                                                   view:getControl( 130, view:oFolder:aDialogs[1] ):lValid(),;
                                                   testWaitSeconds() )

   METHOD set_codigo_almacen_destino( cCodigoAlmacen, view ) ;
                                       INLINE   (  view:getControl( 140, view:oFolder:aDialogs[1] ):cText( cCodigoAlmacen ),;
                                                   testWaitSeconds(),;
                                                   view:getControl( 140, view:oFolder:aDialogs[1] ):lValid(),;
                                                   testWaitSeconds() )

   METHOD set_codigo_articulo_en_linea( cCodigoArticulo ) ;
                                       INLINE   (  eval( ::oController:getLinesController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , cCodigoArticulo, 0 ),;
                                                   testWaitSeconds(),;
                                                   ::refresh_linea_browse_view() )

   METHOD set_codigo_ubicacion_origen_en_linea( cCodigoUbicacion ) ;
                                       INLINE   (  eval( ::oController:getLinesController():getBrowseView():oColumnCodigoUbicacionOrigen:bOnPostEdit, , cCodigoUbicacion, 0 ),;
                                                   testWaitSeconds(),;
                                                   ::refresh_linea_browse_view() )

   METHOD set_codigo_ubicacion_destino_en_linea( cCodigoUbicacion ) ;
                                       INLINE   (  eval( ::oController:getLinesController():getBrowseView():oColumnCodigoUbicacionDestino:bOnPostEdit, , cCodigoUbicacion, 0 ),;
                                                   testWaitSeconds(),;
                                                   ::refresh_linea_browse_view() )

   METHOD set_precio_en_linea( nPrecio ) ;
                                       INLINE   (  eval( ::oController:getLinesController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , nPrecio, 0 ),;
                                                   testWaitSeconds(),;
                                                   ::refresh_linea_browse_view() )

   METHOD refresh_linea_browse_view()  INLINE   (  ::oController:getLinesController():getBrowseView():getRowSet():Refresh(),;
                                                   testWaitSeconds() )
   
   METHOD test_dialogo_sin_almacen()                
   
   METHOD test_dialogo_sin_lineas()   

   METHOD test_dialogo_sin_ubicacion()  

   METHOD test_dialogo_sin_almacen_destino()

   METHOD test_dialogo_con_solo_una_ubicacion()              

   METHOD test_dialogo_con_dos_ubicacion()

   METHOD test_dialogo_con_lote_dos_ubicaciones()   

   METHOD test_dialogo_con_propiedades_dos_ubicaciones()   

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestMovimientoAlmacenController
   
   Company():setDefaultUsarUbicaciones( .t. )
   
   ::getController()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestMovimientoAlmacenController
   
   if !empty( ::oController )
      ::oController:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestMovimientoAlmacenController

   SQLMovimientosAlmacenesModel():truncateTable()

   SQLMovimientosAlmacenesLineasModel():truncateTable()

   ::Super:Before()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_almacen() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         view:getControl( IDOK ):Click()
         
         testWaitSeconds()
      
         view:getControl( IDCANCEL ):Click()

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creaci�n de movimiento de almac�n sin c�digo almac�n" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_almacen_destino() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         view:getControl( IDOK ):Click()
         
         testWaitSeconds()
      
         view:getControl( IDCANCEL ):Click()

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creaci�n de movimiento de almac�n sin almac�n destino" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_lineas() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         ::set_codigo_almacen_destino( "1", view )

         view:getControl( IDOK ):Click()

         testWaitSeconds()

         view:getControl( IDCANCEL ):Click()

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creaci�n movimiento de almac�n sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_ubicacion() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         ::set_codigo_almacen_destino( "1", view )

         ::click_nueva_linea( view )

         ::set_codigo_articulo_en_linea( "1" )

         view:getControl( IDOK ):Click()

         testWaitSeconds()

         view:getControl( IDCANCEL ):Click() 
         
         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creaci�n de movimiento sin ubicacion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_solo_una_ubicacion() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         ::set_codigo_almacen_destino( "1", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "0" )
         
         ::set_codigo_ubicacion_origen_en_linea( "0" )
         
         view:getControl( IDOK ):Click()

         testWaitSeconds()

         view:getControl( IDCANCEL ):Click() 

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creaci�n de movimiento por cajas y con solo una ubicacion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_dos_ubicacion() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         ::set_codigo_almacen_destino( "1", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "0" )
         
         ::set_codigo_ubicacion_origen_en_linea( "0" )

         ::set_codigo_ubicacion_destino_en_linea( "1" )
         
         view:getControl( IDOK ):Click()

         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creaci�n de movimiento con dos ubicaciones" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_lote_dos_ubicaciones() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         ::set_codigo_almacen_destino( "1", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "2" )

         ::set_lote_en_linea( "1234" )
         
         ::set_codigo_ubicacion_origen_en_linea( "0" )

         ::set_codigo_ubicacion_destino_en_linea( "1" )
         
         view:getControl( IDOK ):Click()

         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creaci�n de movimiento con lote y dos ubicaciones" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_con_propiedades_dos_ubicaciones() CLASS TestMovimientoAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen_origen( "0", view )

         ::set_codigo_almacen_destino( "1", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "3" )

         ::set_combinaciones_en_linea( "3", "S, Azul, Denim" )
         
         ::set_codigo_ubicacion_origen_en_linea( "0" )

         ::set_codigo_ubicacion_destino_en_linea( "1" )
         
         view:getControl( IDOK ):Click()

         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creaci�n de movimiento con propiedades y dos ubicaciones" )

RETURN ( nil )

//---------------------------------------------------------------------------//


#endif
