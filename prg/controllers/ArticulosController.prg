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

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ArticulosView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := ArticulosValidator():New( self  ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::Repository ), ::oRepository := ArticulosRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosController

   ::Super:New( oSenderController )

   ::cTitle                                  := "Artículos"

   ::cName                                   := "articulos"

   ::lInsertable                             := .t.

   ::hImage                                  := {  "16" => "gc_object_cube_16",;
                                                   "32" => "gc_object_cube_32",;
                                                   "48" => "gc_object_cube_48" }

   ::lTransactional                          := .t.

   ::nLevel                                  := Auth():Level( ::cName )

   ::oModel                                  := SQLArticulosModel():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvents( { 'loadedBlankBuffer', 'loadedCurrentBuffer' }, {|| ::insertPreciosWhereArticulo() } )

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
  
   ::Super:End()

RETURN ( hb_gcall( .t. ) )

//---------------------------------------------------------------------------//

METHOD getPrecioCosto() CLASS ArticulosController

   if empty( ::oModel )
      RETURN ( 0 )
   end if 

   if empty( ::oModel:hBuffer )
      RETURN ( 0 )
   end if 

RETURN ( ::oModel:hBuffer[ "precio_costo" ] )

//---------------------------------------------------------------------------//

METHOD getPorcentajeIVA() CLASS ArticulosController

   if empty(::oModel)
      RETURN ( 0 )
   end if 

   if empty(::oModel:hBuffer)
      RETURN ( 0 )
   end if 

RETURN ( ::getTipoIvaController():oModel:getPorcentajeWhereCodigo( ::oModel:hBuffer[ "tipo_iva_codigo" ] ) )

//---------------------------------------------------------------------------//

METHOD insertPreciosWhereArticulo() CLASS ArticulosController

   local uuidArticulo   

   if empty( ::oModel )
      RETURN ( nil )
   end if 

   if empty( ::oModel:hBuffer )
      RETURN ( nil )
   end if 

   uuidArticulo      := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidArticulo )
      RETURN ( nil )
   end if 
   
   ::getArticulosPreciosController():oModel:insertPreciosWhereArticulo( uuidArticulo )   

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validatePrecioCosto() CLASS ArticulosController

   local uuidArticulo   := hget( ::oModel:hBuffer, "uuid" )
   local nPrecioCosto   := hget( ::oModel:hBuffer, "precio_costo" )

   ::oModel:updateFieldWhereUuid( uuidArticulo, "precio_costo", nPrecioCosto )

   ::getArticulosPreciosController():getRepository():callUpdatePreciosWhereUuidArticulo( uuidArticulo )
   
   ::getArticulosPreciosController():refreshRowSet()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateTipoIVA() CLASS ArticulosController

   local uuidArticulo   := hget( ::oModel:hBuffer, "uuid" )
   local cCodigoTipoIVA := hget( ::oModel:hBuffer, "tipo_iva_codigo" )

   ::oModel:updateFieldWhereUuid( uuidArticulo, "tipo_iva_codigo", cCodigoTipoIVA )

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