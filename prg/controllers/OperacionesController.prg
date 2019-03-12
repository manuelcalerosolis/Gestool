#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesController FROM SQLNavigatorController

   DATA oHistoryManager

   DATA oContadoresModel
   
   DATA oSerieDocumentoComponent

   DATA oNumeroDocumentoComponent

   METHOD New()                        CONSTRUCTOR

   METHOD End()

   METHOD addExtraButtons()            VIRTUAL

   METHOD editConfig()

   METHOD Editing()                    VIRTUAL

   METHOD loadedBlankBuffer() 

   METHOD loadedDuplicateBuffer() 

   METHOD loadedBuffer()               INLINE ( ::getHistoryManager():Set( ::getModel():hBuffer ) )

   METHOD updateCounter()

   METHOD updatedBuffer()              VIRTUAL

   METHOD changedSerie() 

   METHOD appendLine()    

   METHOD hasLines()                   
   METHOD hasNotLines()                INLINE ( !::hasLines() )

   METHOD getConfigItems()

   // Impresiones--------------------------------------------------------------

   METHOD getDocumentPrint()           INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_impresion', '' ) )

   METHOD getDocumentPdf()             INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_pdf', '' ) )

   METHOD getDocumentPreview()         INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'documento_previsulizacion', '' ) )

   METHOD getCopyPrint()               INLINE ( ::getConfiguracionesController():getModelNumeric( ::getName(), 'copias_impresion', 1 ) )

   METHOD getTemplateMails()           INLINE ( ::getConfiguracionesController():getModelValue( ::getName(), 'plantilla_para_mails', '' ) )
   
   METHOD generateReport( hReport )    INLINE ( ::getReport():Generate( hReport ) )

   METHOD getSubject()                 VIRTUAL

   METHOD getName()                    VIRTUAL

   // Contrucciones tardias----------------------------------------------------

   METHOD getModel()                   VIRTUAL

   METHOD getValidator()               VIRTUAL  

   METHOD getBrowseView()              VIRTUAL

   METHOD getRepository()              VIRTUAL  
   
   METHOD getReport()                  VIRTUAL

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := OperacionesComercialesView():New( self ), ), ::oDialogView )

   METHOD getHistoryManager()          INLINE ( if( empty( ::oHistoryManager ), ::oHistoryManager := HistoryManager():New(), ), ::oHistoryManager )

   METHOD getSerieDocumentoComponent() INLINE ( if( empty( ::oSerieDocumentoComponent ), ::oSerieDocumentoComponent := SerieDocumentoComponent():New( self ), ), ::oSerieDocumentoComponent )

   METHOD getNumeroDocumentoComponent() ;
                                       INLINE ( if( empty( ::oNumeroDocumentoComponent ), ::oNumeroDocumentoComponent := NumeroDocumentoComponent():New( self ), ), ::oNumeroDocumentoComponent )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS OperacionesController

   ::Super:New( oController )
   
   ::setEvents( { 'inserted', 'duplicated' }, {|| ::updateCounter() } )

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingDeleteButton', { || .f. } )
   ::getNavigatorView():getMenuTreeView():setEvent( 'addedPdfButton', {|| ::addExtraButtons() } )

   ::getModel():setEvent( 'loadedBlankBuffer', {|| ::loadedBlankBuffer() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer', {|| ::loadedDuplicateBuffer() } )
   ::getModel():setEvent( 'updatedBuffer', {|| ::updatedBuffer() } )
   ::getModel():setEvents( { 'loadedBuffer', 'insertedBuffer' }, {|| ::loadedBuffer() } )

   ::getSerieDocumentoComponent():setEvents( { 'inserted', 'changedAndExist' }, {|| ::changedSerie() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS OperacionesController

   if !empty( ::oContadoresModel )
      ::oContadoresModel:End()
   end if 

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

METHOD editConfig() CLASS OperacionesController

RETURN ( ::getConfiguracionesController():Edit() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS OperacionesController 

   ::setModelBuffer( "serie", ::getContadoresController():getModel():getLastSerie( ::getName() ) )

   ::setModelBuffer( "numero", ::getContadoresController():getModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer() CLASS OperacionesController 

RETURN ( ::setModelBuffer( "numero", ::getContadoresController():getModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD updateCounter() CLASS OperacionesController 

   local nNumero  

   nNumero  := ::getContadoresController():getModel():getCounterAndIncrement( ::getName(), ::getModelBuffer( "serie" ) )

RETURN ( ::getModel():updateFieldWhereUuid( ::getModelBuffer( "uuid" ), "numero", nNumero ) )

//---------------------------------------------------------------------------//

METHOD changedSerie() CLASS OperacionesController 

RETURN ( ::getNumeroDocumentoComponent():setValue( ::getContadoresController():getModel():getLastCounter( ::getName(), ::getModelBuffer( "serie" ) ) ) )

//---------------------------------------------------------------------------//

METHOD appendLine() CLASS OperacionesController

   if !( ::getLinesController():validLine() )
      RETURN ( nil )
   end if

RETURN ( ::getLinesController():AppendLineal() ) 

//---------------------------------------------------------------------------//

METHOD hasLines() CLASS OperacionesController

RETURN ( ::getLinesController():getModel():countLinesWhereUuidParent( ::getModelBuffer( 'uuid' ) ) > 0 )

//---------------------------------------------------------------------------//

METHOD getConfigItems() CLASS OperacionesController

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
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestOperacionesController FROM TestCase

   DATA oController

   METHOD beforeClass()                VIRTUAL

   METHOD afterClass()

   METHOD Before() 

   METHOD set_lote_en_linea( cLote )   INLINE   (  eval( ::oController:getLinesController():getBrowseView():oColumnLote:bOnPostEdit, , cLote, 0 ),;
                                                   testWaitSeconds(),;
                                                   ::refresh_linea_browse_view() )

   METHOD set_combinaciones_en_linea( cCodigoArticulo, cCombinacionTexto )

END CLASS

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestOperacionesController

   if !empty( ::oController )
      ::oController:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestOperacionesController

   SQLTercerosModel():truncateTable()

   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()
      SQLUbicacionesModel():truncateTable()

   SQLTiposIvaModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLPropiedadesModel():truncateTable()
      SQLPropiedadesLineasModel():truncateTable()

   //SQLCombinacionesModel():truncateTable()
      //SQLCombinacionesPropiedadesModel():truncateTable()

   SQLFacturasVentasModel():truncateTable()
      SQLFacturasVentasLineasModel():truncateTable()
      SQLFacturasVentasDescuentosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLRecibosModel():truncateTable()
      SQLPagosModel():truncateTable()
      SQLRecibosPagosModel():truncateTable()

   SQLAgentesModel():truncateTable()

   //SQLUnidadesMedicionGruposModel():truncateTable()
   //SQLUnidadesMedicionOperacionesModel():truncateTable()

   SQLAlmacenesModel():test_create_almacen_principal()
   SQLAlmacenesModel():test_create_almacen_auxiliar()

   SQLAgentesModel():test_create_agente_principal()
   SQLAgentesModel():test_create_agente_auxiliar()

   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )
   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_auxiliar() )

   SQLTiposIvaModel():test_create_iva_al_4()
   SQLTiposIvaModel():test_create_iva_al_10()
   SQLTiposIvaModel():test_create_iva_al_21()

   SQLMetodoPagoModel():test_create_contado()
   SQLMetodoPagoModel():test_create_reposicion()
   SQLMetodoPagoModel():test_create_con_plazos()

   SQLTercerosModel():test_create_contado()
   SQLTercerosModel():test_create_tarifa_mayorista()
   SQLTercerosModel():test_create_con_plazos()
   SQLTercerosModel():test_create_proveedor()

   //SQLUnidadesMedicionGruposModel():test_create()

   SQLPropiedadesModel():test_create_tallas()
   SQLPropiedadesModel():test_create_colores()
   SQLPropiedadesModel():test_create_texturas()

   //SQLArticulosModel():test_create_con_unidad_de_medicion_cajas_palets()
   SQLArticulosModel():test_create_con_tarifa_mayorista()
   //SQLArticulosModel():test_create_con_lote()
   //SQLArticulosModel():test_create_con_propiedades()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD set_combinaciones_en_linea( cCodigoArticulo, cCombinacionTexto )

   local aArticuloCombinacion := SQLCombinacionesPropiedadesModel():selectPropertyWhereArticuloCombinacion( cCodigoArticulo, cCombinacionTexto )

   if !empty( aArticuloCombinacion )
   
      eval( ::oController:getLinesController():getBrowseView():oColumnPropiedades:bOnPostEdit, , hget( atail( aArticuloCombinacion ), "uuid" ), 0 )

      testWaitSeconds()
   
      ::refresh_linea_browse_view() 

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
