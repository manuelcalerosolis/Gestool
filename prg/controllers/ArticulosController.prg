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

   ::lInsertable                       := .t.

   ::hImage                            := {  "16" => "gc_object_cube_16",;
                                             "32" => "gc_object_cube_32",;
                                             "48" => "gc_object_cube_48" }

   ::lTransactional                    := .t.

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

   local uuidArticulo   
   local nPrecioCosto   

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

   uuidArticulo      := ::getModelBuffer( "uuid" )
   nPrecioCosto      := ::getModelBuffer( "precio_costo" )

   ::getModel():updateFieldWhereUuid( uuidArticulo, "precio_costo", nPrecioCosto )

   ::getArticulosPreciosController():getRepository():callUpdatePreciosWhereUuidArticulo( uuidArticulo )
   
   ::getArticulosPreciosController():refreshRowSet()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateTipoIVA() CLASS ArticulosController

   local uuidArticulo   
   local cCodigoTipoIVA 

   if ::isEmptyModelBuffer()
      RETURN ( 0 )
   end if 

   uuidArticulo      := ::getModelBuffer( "uuid" )
   cCodigoTipoIVA    := ::getModelBuffer( "tipo_iva_codigo" )

   ::getModel():updateFieldWhereUuid( uuidArticulo, "tipo_iva_codigo", cCodigoTipoIVA )

   ::getArticulosPreciosController():getRepository():callUpdatePreciosWhereUuidArticulo( uuidArticulo )
   
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