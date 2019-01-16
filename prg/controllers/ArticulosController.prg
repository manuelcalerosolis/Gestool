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

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := ArticulosView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := ArticulosValidator():New( self  ), ), ::oValidator )

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

   METHOD beforeClass() 

   METHOD afterClass() 

   METHOD Before()
/*
   METHOD test_append()
   
   METHOD test_dialog_append()

   METHOD test_dialog_empty_nombre()

   METHOD test_dialog_append_con_unidad_de_medicion() 

   METHOD test_dialog_cancel_append() 
*/
   METHOD test_controller_rollback()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestArticulosController

   ::oController           := ArticulosController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestArticulosController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestArticulosController

   SQLArticulosModel():truncateTable()

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
METHOD test_append() CLASS TestArticulosController

   local nId

   nId   := SQLArticulosModel():insertBuffer(   {  'uuid' => win_uuidcreatestring(),;
                                                   'codigo' => '000',;
                                                   'nombre' => 'Test 0' } )

   ::assert:notEquals( nId, 0, "test id articulos distinto de cero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append() CLASS TestArticulosController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 

         view:oGetCodigo:cText( '001' )

         apoloWaitSeconds( 1 )

         view:oGetNombre:cText( 'Test 1' )

         apoloWaitSeconds( 1 )

         view:oBtnAceptar:Click()

         RETURN ( nil )
      
      > )

   ::assert:true( ::oController:Insert(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_empty_nombre() CLASS TestArticulosController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 

         view:oGetCodigo:cText( '001' )

         apoloWaitSeconds( 1 )

         view:oBtnAceptar:Click()

         apoloWaitSeconds( 1 )

         view:oBtnCancelar:Click()

         RETURN ( nil )
      
      > )

   ::assert:false( ::oController:Insert(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_con_unidad_de_medicion() CLASS TestArticulosController

   SQLUnidadesMedicionGruposModel():test_create()

   ::oController:getDialogView():setEvent( 'painted',;
      <| view | 
         
         view:oGetCodigo:cText( '001' )
         
         apoloWaitSeconds( 1 )
         
         view:oGetNombre:cText( 'Test producto venta con caja y palets' )
         
         apoloWaitSeconds( 1 )
         
         ::oController:getUnidadesMedicionGruposController():getSelector():cText( "0" )
         
         apoloWaitSeconds( 1 )
         
         view:oBtnAceptar:Click() 

         RETURN ( nil )

      > )

   ::assert:true( ::oController:Insert(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_cancel_append() CLASS TestArticulosController

   ::oController:getDialogView():setEvent( 'painted',;
      <| view |

         view:oGetCodigo:cText( '001' )

         apoloWaitSeconds( 1 )

         view:oGetNombre:cText( 'Test 1' )

         apoloWaitSeconds( 1 )

         view:oBtnCancelar:Click() 

         RETURN ( nil )
      > )

   ::assert:false( ::oController:Insert(), "test cancelar la insercion de registro" )

RETURN ( nil )
*/
//---------------------------------------------------------------------------//

METHOD test_controller_rollback() CLASS TestArticulosController

   local nId

   ::oController:getDialogView():setEvent( 'painted',;
      <| view |

         apoloWaitSeconds( 1 )

         view:oBtnCancelar:Click() 

         RETURN ( nil )
      > )

   ::oController:setAppendMode()

   ::oController:beginTransactionalMode()

   nId            := ::oController:getModel():insertBlankBuffer()

   ::oController:getModel():insertBlankBuffer()

   ::oController:dialogViewActivate()

   ::oController:rollbackTransactionalMode()

   ::assert:notEquals( ::oController:getModel():getFieldWhere( 'id', { 'id' => nId } ), 0, "test cancelar la insercion de registro" )

RETURN ( nil )

//---------------------------------------------------------------------------//


