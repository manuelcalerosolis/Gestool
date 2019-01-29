#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenController FROM OperacionesController

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

   METHOD getSubject()                 INLINE ( "Consolidación de almacén" )

   // Contrucciones tardias----------------------------------------------------

   METHOD getName()                    INLINE ( "consolidacion_almacen" )

   METHOD getLinesController()         INLINE ( ::getConsolidacionAlmacenLineasController() )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ConsolidacionAlmacenView():New( self ), ), ::oDialogView )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConsolidacionesAlmacenesModel():New( self ), ), ::oModel )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := ConsolidacionAlmacenValidator():New( self ), ), ::oValidator )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := ConsolidacionAlmacenBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := ConsolidacionesAlmacenesRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConsolidacionAlmacenController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::lInsertable                       := .t.

   ::lConfig                           := .t.

   ::lDocuments                        := .t.

   ::lMail                             := .t.

   ::cTitle                            := "Consolidaciones de almacén"

   ::cName                             := "consolidacion_almacen"

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

METHOD End() CLASS ConsolidacionAlmacenController

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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD editConfig() CLASS ConsolidacionAlmacenController

RETURN ( ::getConfiguracionesController():Edit() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ConsolidacionAlmacenController 

   ::setModelBuffer( "serie", ::getContadoresModel():getLastSerie( ::getName() ) )

   ::setModelBuffer( "numero", ::getContadoresModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer() CLASS ConsolidacionAlmacenController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD insertingBuffer() CLASS ConsolidacionAlmacenController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresModel():getCounterAndIncrement( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD appendLine() CLASS ConsolidacionAlmacenController

   if empty( ::getModelBuffer( "almacen_codigo" ) )
      ::getDialogView():showMessage( "El código del almacén es un dato requerido" )
      RETURN( nil )
   end if 

RETURN ( ::Super:appendLine() ) 

//---------------------------------------------------------------------------//

METHOD changedSerie() CLASS ConsolidacionAlmacenController 

RETURN ( ::getNumeroDocumentoComponent():setValue( ::getContadoresModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD calculateTotals( uuidDocumento ) CLASS ConsolidacionAlmacenController

   DEFAULT uuidDocumento   := ::getUuid()

   ::getDialogView():oTotalImporte:setText( ::getRepository():selectTotalSummaryWhereUuid( uuidDocumento ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS ConsolidacionAlmacenController

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

CLASS ConsolidacionAlmacenValidator FROM SQLBaseValidator 

   METHOD getValidators()

   METHOD emptyLines()     

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ConsolidacionAlmacenValidator

   ::hValidators  := {  "almacen_codigo"  => {  "required"        => "El código del almacén es un dato requerido",;
                                                "almacenExist"    => "El código del almacén no existe" } ,;  
                        "formulario"      => {  "emptyLines"      => "Las líneas no pueden estar vacias",;
                                                "validLine"       => "" } }  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD emptyLines() CLASS ConsolidacionAlmacenValidator     

RETURN ( ::getController():hasLines() )

//---------------------------------------------------------------------------//

METHOD validLine() CLASS ConsolidacionAlmacenValidator     

RETURN ( ::getController():getLinesController():validLine() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConsolidacionAlmacenController FROM TestOperacionesController

   DATA aCategories                    INIT { "all", "consolidaciones_almacenes" }

   METHOD getController()              INLINE ( if( empty( ::oController ), ::oController := ConsolidacionAlmacenController():New(), ), ::oController ) 
   METHOD Before()

   METHOD beforeClass()

   METHOD click_nueva_linea( view )    INLINE ( view:getControl( 501, view:oFolder:aDialogs[1] ):Click(),;
                                                testWaitSeconds( 1 ) )

   METHOD set_codigo_almacen( cCodigoAlmacen, view ) ;
                                       INLINE ( view:getControl( 130, view:oFolder:aDialogs[1] ):cText( cCodigoAlmacen ),;
                                                testWaitSeconds( 1 ),;
                                                view:getControl( 130, view:oFolder:aDialogs[1] ):lValid(),;
                                                testWaitSeconds( 1 ) )

   METHOD set_codigo_articulo_en_linea( cCodigoArticulo ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoArticulo:bOnPostEdit, , cCodigoArticulo, 0 ),;
                                                testWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_codigo_ubicacion_en_linea( cCodigoUbicacion ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnCodigoUbicacion:bOnPostEdit, , cCodigoUbicacion, 0 ),;
                                                testWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD set_precio_en_linea( nPrecio ) ;
                                       INLINE ( eval( ::oController:getLinesController():getBrowseView():oColumnArticuloPrecio:bOnPostEdit, , nPrecio, 0 ),;
                                                testWaitSeconds( 1 ),;
                                                ::refresh_linea_browse_view() )

   METHOD refresh_linea_browse_view()  INLINE ( ::oController:getLinesController():getBrowseView():getRowSet():Refresh(),;
                                                testWaitSeconds( 1 ) )
   
   METHOD test_dialogo_sin_almacen()                
   
   METHOD test_dialogo_sin_lineas()   

   METHOD test_dialogo_sin_ubicacion()  

   METHOD test_dialogo_articulo_por_cajas_con_ubicacion()              

   METHOD test_dialogo_articulo_con_lote()

   METHOD test_dialogo_articulo_con_caraceristicas() 

   METHOD getController()              INLINE ( if( empty( ::oController ), ::oController := ConsolidacionAlmacenController():New(), ), ::oController ) 

   METHOD End()                        INLINE ( if( !empty( ::oController ), ::oController:End(), ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestConsolidacionAlmacenController
   
   Company():setDefaultUsarUbicaciones( .t. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestConsolidacionAlmacenController

   SQLConsolidacionesAlmacenesModel():truncateTable()

   SQLConsolidacionesAlmacenesLineasModel():truncateTable()

   ::Super:Before()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_almacen() CLASS TestConsolidacionAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         view:getControl( IDOK ):Click()
      
         testWaitSeconds( 1 )
      
         view:getControl( IDCANCEL ):Click()

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creación de consolidación sin código almacén" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_lineas() CLASS TestConsolidacionAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen( "0", view )
         
         view:getControl( IDOK ):Click()
         
         testWaitSeconds( 1 )

         view:getControl( IDCANCEL ):Click()

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creación de consolidación sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_ubicacion() CLASS TestConsolidacionAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen( "0", view )

         ::click_nueva_linea( view )

         ::set_codigo_articulo_en_linea( "1" )

         view:getControl( IDOK ):Click()

         testWaitSeconds( 1 )

         view:getControl( IDCANCEL ):Click() 

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test creación de consolidación sin ubicacion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_articulo_por_cajas_con_ubicacion() CLASS TestConsolidacionAlmacenController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen( "0", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "0" )
         
         ::set_codigo_ubicacion_en_linea( "0" )
         
         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   ::Assert():true( ::getController():Insert(), "test creación de consolidación por cajas y con ubicacion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_articulo_con_lote() CLASS TestConsolidacionAlmacenController

   local lInsert

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen( "0", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "2" )

         ::set_lote_en_linea( "1234" )
         
         ::set_codigo_ubicacion_en_linea( "0" )
         
         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   lInsert     := ::getController():Insert()

   if !empty( ::assert )
      ::Assert():true( lInsert, "test creación de consolidación por cajas y con ubicacion" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_articulo_con_caraceristicas() CLASS TestConsolidacionAlmacenController

   local lInsert

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         ::set_codigo_almacen( "0", view )
         
         ::click_nueva_linea( view )
         
         ::set_codigo_articulo_en_linea( "3" )

         ::set_lote_en_linea( "1234" )
         
         ::set_codigo_ubicacion_en_linea( "0" )
         
         view:getControl( IDOK ):Click()
         
         RETURN ( nil )
      > )

   lInsert     := ::getController():Insert()

   if !empty( ::assert )
      ::Assert():true( lInsert, "test creación de consolidación por cajas y con ubicacion" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
