#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertPreciosWhereArticulo()

   METHOD getPrecioCosto()        

   METHOD getPorcentajeIVA()

   METHOD validatePrecioCosto()
   
   METHOD validateTipoIVA()

   METHOD validColumnArticulosFamiliaBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getArticulosFamiliasController():oModel, "familia_codigo" ) )

   METHOD validColumnArticulosTipoBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getArticulosTipoController():oModel, "tipo_codigo" ) )

   METHOD validColumnArticulosCategoriasBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getArticulosCategoriasController():oModel, "categoria_codigo" ) )

   METHOD validColumnArticulosFabricantesBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getArticulosFabricantesController():oModel, "fabricante_codigo" ) )

   METHOD validColumnArticulosTemporadasBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getArticulosTemporadasController():oModel, "temporada_codigo" ) )

   METHOD validColumnTiposIvaBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getTipoIvaController():oModel, "tipo_iva_codigo" ) )

   METHOD validColumnImpuestosEspecialesBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getImpuestosEspecialesController():oModel, "impuesto_especial_codigo" ) )

   METHOD validColumnUnidadesMedicionGruposBrowse( oCol, uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::getUnidadesMedicionGruposController():oModel, "unidades_medicion_grupos_codigo" ) )

   METHOD setUuidOldersParents()
   
   METHOD getDuplicateOthers()
   
   METHOD deletedOthersSelection()
   
   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ArticulosView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := ArticulosValidator():New( self  ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::Repository ), ::oRepository := ArticulosRepository():New( self ), ), ::oRepository )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLArticulosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosController

   ::Super:New( oController )

   ::cTitle                            := "Artículos"

   ::cName                             := "articulos"
   
   ::lTransactional                    := .t.

   ::lInsertable                       := .t.

   ::hImage                            := {  "16" => "gc_object_cube_16",;
                                             "32" => "gc_object_cube_32",;
                                             "48" => "gc_object_cube_48" }

   ::nLevel                            := Auth():Level( ::cName )

   ::getModel():setEvents( { 'loadedBlankBuffer', 'loadedCurrentBuffer' }, {|| ::insertPreciosWhereArticulo() } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer',   {|| ::setUuidOldersParents() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',          {|| ::getDuplicateOthers() } )
   
   ::getModel():setEvent( 'deletedSelection',               {|| ::deletedOthersSelection()  } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosController

   if !empty( ::oModel )
      ::oModel:End() 
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD setUuidOldersParents() CLASS ArticulosController

   ::getCombinacionesController():getModel():setUuidOlderParent( ::getUuid() )

   ::getImagenesController():getModel():setUuidOlderParent( ::getUuid() )

   ::getTraduccionesController():getModel():setUuidOlderParent( ::getUuid() )

   ::getUnidadesMedicionOperacionesController():getModel():setUuidOlderParent( ::getUuid() )

   ::getCamposExtraValoresController():getModel():setUuidOlderParent( ::getUuid() )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getDuplicateOthers() CLASS ArticulosController

   ::getCombinacionesController():getModel():duplicateOthers( ::getUuid() )

   ::getImagenesController():getModel():duplicateOthers( ::getUuid() )
   
   ::getTraduccionesController():getModel():duplicateOthers( ::getUuid() )

   ::getUnidadesMedicionOperacionesController():getModel():duplicateOthers( ::getUuid() )

   ::getCamposExtraValoresController():getModel():duplicateOthers( ::getUuid() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deletedOthersSelection() CLASS ArticulosController

   ::getCombinacionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )
   
   ::getImagenesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )
   
   ::getTraduccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getUnidadesMedicionOperacionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getCamposExtraValoresController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getPrecioCosto() CLASS ArticulosController

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

RETURN ( ::getModel():hBuffer[ "precio_costo" ] )

//---------------------------------------------------------------------------//

METHOD getPorcentajeIVA() CLASS ArticulosController

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

RETURN ( ::getTipoIvaController():oModel:getPorcentajeWhereCodigo( ::getModel():hBuffer[ "tipo_iva_codigo" ] ) )

//---------------------------------------------------------------------------//

METHOD insertPreciosWhereArticulo() CLASS ArticulosController

   local uuidArticulo   

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

   uuidArticulo      := ::getModelBuffer( "uuid" )

   if empty( uuidArticulo )
      RETURN ( nil )
   end if 
   
   ::getArticulosPreciosController():getModel():insertPreciosWhereArticulo( uuidArticulo )   

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validatePrecioCosto() CLASS ArticulosController

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

   ::getModel():updateFieldWhereUuid( ::getModelBuffer( "uuid" ), "precio_costo", ::getModelBuffer( "precio_costo" ) )

   ::getArticulosPreciosController():getRepository():callUpdatePreciosWhereUuidArticulo( ::getModelBuffer( "uuid" ) )
   
   ::getArticulosPreciosController():refreshRowSet()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateTipoIVA() CLASS ArticulosController

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

   ::getModel():updateFieldWhereUuid( ::getModelBuffer( "uuid" ), "tipo_iva_codigo", ::getModelBuffer( "tipo_iva_codigo" ) )

   ::getArticulosPreciosController():getRepository():callUpdatePreciosWhereUuidArticulo( ::getModelBuffer( "uuid" ) )
   
   ::getArticulosPreciosController():refreshRowSet()

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TestArticulosController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "articulos" }

   METHOD getController()              INLINE ( if( empty( ::oController ), ::oController := ArticulosController():New(), ), ::oController )

   METHOD End()                        INLINE ( if( !empty( ::oController ), ::oController:End(), ) ) 

   METHOD Before()

   METHOD test_append()
   
   METHOD test_dialog_append()

   METHOD test_dialog_empty_nombre()

   METHOD test_dialog_append_con_unidad_de_medicion() 

   METHOD test_dialog_cancel_append() 

   METHOD test_controller_rollback()

   METHOD test_dialog_append_con_caracteristicas() 

END CLASS

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestArticulosController

   SQLArticulosModel():truncateTable()

   SQLPropiedadesModel():truncateTable()
   SQLPropiedadesLineasModel():truncateTable()

   SQLCombinacionesModel():truncateTable()
   SQLCombinacionesPropiedadesModel():truncateTable()

   SQLPropiedadesModel():test_create_tallas()
   SQLPropiedadesModel():test_create_colores()
   SQLPropiedadesModel():test_create_texturas()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_append() CLASS TestArticulosController

   local nId

   nId   := SQLArticulosModel():insertBuffer(   {  'uuid' => win_uuidcreatestring(),;
                                                   'codigo' => '000',;
                                                   'nombre' => 'Test 0' } )

   ::Assert():notEquals( nId, 0, "test id articulos distinto de cero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append() CLASS TestArticulosController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 

         view:oGetCodigo:cText( '3' )

         testWaitSeconds()

         view:oGetNombre:cText( 'Test 1' )

         testWaitSeconds()

         view:oBtnAceptar:Click()

         RETURN ( nil )
      
      > )

   ::Assert():true( ::getController():Insert(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_empty_nombre() CLASS TestArticulosController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 

         view:oGetCodigo:cText( '3' )

         testWaitSeconds()

         view:oBtnAceptar:Click()

         testWaitSeconds()

         view:oBtnCancelar:Click()

         RETURN ( nil )
      
      > )

   ::Assert():false( ::getController():Insert(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_con_unidad_de_medicion() CLASS TestArticulosController

   SQLUnidadesMedicionGruposModel():test_create()

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         
         view:oGetCodigo:cText( '3' )
         
         testWaitSeconds()
         
         view:oGetNombre:cText( 'Test producto venta con caja y palets' )
         
         testWaitSeconds()
         
         ::getController():getUnidadesMedicionGruposController():getSelector():cText( "0" )
         
         testWaitSeconds()
         
         view:oBtnAceptar:Click() 

         RETURN ( nil )

      > )

   ::Assert():true( ::getController():Insert(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_cancel_append() CLASS TestArticulosController

   ::getController():getDialogView():setEvent( 'painted',;
      <| view |

         view:oGetCodigo:cText( '3' )

         testWaitSeconds()

         view:oGetNombre:cText( 'Test 1' )

         testWaitSeconds()

         view:oBtnCancelar:Click() 

         RETURN ( nil )
      > )

   ::Assert():false( ::getController():Insert(), "test cancelar la insercion de registro" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_controller_rollback() CLASS TestArticulosController

   local nId

   ::getController():getDialogView():setEvent( 'painted',;
      <| view |

         testWaitSeconds()

         view:oBtnCancelar:Click() 

         RETURN ( nil )
      > )

   ::getController():setAppendMode()

   ::getController():beginTransactionalMode()

   ::getController():getModel():insertBlankBuffer()

   ::getController():dialogViewActivate()

   ::getController():rollbackTransactionalMode()

   ::Assert():notEquals( ::getController():getModel():getFieldWhere( 'id', { 'id' => nId } ), 0, "test cancelar la insercion de registro" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_con_caracteristicas() CLASS TestArticulosController

   SQLUnidadesMedicionGruposModel():test_create()

   ::getController():getCombinacionesController():getDialogView():setEvent( 'painted',;
      <| view | 
         
         testWaitSeconds()

         aeval( view:oExplorerBar:aPanels, {|a| aeval( a:aControls, {|o| o:Click() } ) } )

         testWaitSeconds()

         view:oButtonGenerate:Click()

         testWaitSeconds()

         view:oButtonAceptar:Click()

         RETURN ( nil )
      > )

   ::getController():getDialogView():setEvent( 'painted',;
      <| view | 
         
         view:oGetCodigo:cText( '3' )
         
         testWaitSeconds()
         
         view:oGetNombre:cText( 'Test producto con caracteristicas' )
         
         testWaitSeconds()
         
         ::getController():getCombinacionesController():runViewGenerate()
         
         testWaitSeconds()
         
         view:oBtnAceptar:Click() 

         RETURN ( nil )

      > )

   ::Assert():true( ::getController():Insert(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

