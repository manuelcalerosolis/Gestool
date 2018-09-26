#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosController FROM SQLNavigatorController

   DATA oArticulosTipoController

   DATA oArticulosCategoriasController

   DATA oArticulosFamiliasController

   DATA oArticulosFabricantesController

   DATA oArticulosPreciosController

   DATA oTipoIvaController

   DATA oImpuestosEspecialesController

   DATA oCamposExtraValoresController

   DATA oArticulosUnidadesMedicionController

   DATA oUnidadesMedicionGruposController

   DATA oTraduccionesController

   DATA oArticulosTemporadasController

   DATA oCombinacionesController

   METHOD New()

   METHOD End()

   METHOD insertPreciosWhereArticulo()

   METHOD getPrecioCosto()        

   METHOD getPorcentajeIVA()

   METHOD validatePrecioCosto()
   
   METHOD validateTipoIVA()

   METHOD validColumnArticulosFamiliaBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosFamiliasController:oModel, "articulo_familia_codigo" ) )

   METHOD validColumnArticulosTipoBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosTipoController:oModel, "articulo_tipo_codigo" ) )

   METHOD validColumnArticulosCategoriasBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosCategoriasController:oModel, "articulo_categoria_codigo" ) )

   METHOD validColumnArticulosFabricantesBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosFabricantesController:oModel, "articulo_fabricante_codigo" ) )

   METHOD validColumnArticulosTemporadasBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosTemporadasController:oModel, "articulo_temporada_codigo" ) )

   METHOD validColumnTiposIvaBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oTipoIvaController:oModel, "tipo_iva_codigo" ) )

   METHOD validColumnImpuestosEspecialesBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oImpuestosEspecialesController:oModel, "impuesto_especial_codigo" ) )

   METHOD validColumnUnidadesMedicionGruposBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oUnidadesMedicionGruposController:oModel, "unidades_medicion_grupos_codigo" ) )

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

   ::hImage                                  := {  "16" => "gc_object_cube_16",;
                                                   "32" => "gc_object_cube_32",;
                                                   "48" => "gc_object_cube_48" }

   ::lTransactional                          := .t.

   ::nLevel                                  := Auth():Level( ::cName )

   ::oModel                                  := SQLArticulosModel():New( self )

   /*::oCamposExtraValoresController           := CamposExtraValoresController():New( self, ::cName )*/

   ::oArticulosFamiliasController            := ArticulosFamiliasController():New( self )
   ::oArticulosFamiliasController:setView( ::oDialogView )

   ::oTraduccionesController                 := TraduccionesController():New( self )

   ::oArticulosTipoController                := ArticulosTipoController():New( self )
   ::oArticulosTipoController:setView( ::oDialogView )

   ::oArticulosCategoriasController          := ArticulosCategoriasController():New( self )
   ::oArticulosCategoriasController:setView( ::oDialogView )

   ::oArticulosFabricantesController         := ArticulosFabricantesController():New( self )
   ::oArticulosFabricantesController:setView( ::oDialogView )

   ::oArticulosPreciosController             := ArticulosPreciosController():New( self )
   ::oArticulosPreciosController:setView( ::oDialogView )

   ::oArticulosUnidadesMedicionController    := ArticulosUnidadesMedicionController():New( self )
   ::oArticulosUnidadesMedicionController:setView( ::oDialogView )

   ::oTipoIvaController                      := TipoIvaController():New( self )
   ::oTipoIvaController:setView( ::oDialogView )

   ::oImpuestosEspecialesController          := ImpuestosEspecialesController():New( self )
   ::oImpuestosEspecialesController:setView( ::oDialogView )

   ::oArticulosTemporadasController          := ArticulosTemporadasController():New( self )
   ::oArticulosTemporadasController:setView( ::oDialogView )

   ::oUnidadesMedicionGruposController       := UnidadesMedicionGruposController():New( self )
   ::oUnidadesMedicionGruposController:setView( ::oDialogView )

   ::oCombinacionesController                := CombinacionesController():New( self )

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

   if !empty( ::oCamposExtraValoresController )
      ::oCamposExtraValoresController:End()
   end if 
   
   if !empty( ::oArticulosFamiliasController )
      ::oArticulosFamiliasController:End()
   end if 
   
   if !empty( ::oTraduccionesController )
      ::oTraduccionesController:End()
   end if 

   if !empty( ::oArticulosTipoController )
      ::oArticulosTipoController:End()
   end if 

   if !empty( ::oArticulosCategoriasController )
      ::oArticulosCategoriasController:End()
   end if 

   if !empty( ::oArticulosFabricantesController )
      ::oArticulosFabricantesController:End()
   end if 

   if !empty( ::oTipoIvaController )
      ::oTipoIvaController:End()
   end if 

   if !empty( ::oImpuestosEspecialesController )
      ::oImpuestosEspecialesController:End()
   end if 

   if !empty( ::oArticulosPreciosController )
      ::oArticulosPreciosController:End()
   end if 

   if !empty( ::oArticulosUnidadesMedicionController )
      ::oArticulosUnidadesMedicionController:End()
   end if 

   if !empty( ::oArticulosTemporadasController )
      ::oArticulosTemporadasController:End()
   end if 

   if !empty( ::oUnidadesMedicionGruposController )
      ::oUnidadesMedicionGruposController:End()
   end if 

   if !empty( ::oCombinacionesController )
      ::oCombinacionesController:End()
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

RETURN ( ::oTipoIvaController:oModel:getPorcentajeWhereCodigo( ::oModel:hBuffer[ "tipo_iva_codigo" ] ) )

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

   ::oArticulosPreciosController:oModel:insertPreciosWhereArticulo( uuidArticulo )   

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validatePrecioCosto() CLASS ArticulosController

   local uuidArticulo   := hget( ::oModel:hBuffer, "uuid" )
   local nPrecioCosto   := hget( ::oModel:hBuffer, "precio_costo" )

   ::oModel:updateFieldWhereUuid( uuidArticulo, "precio_costo", nPrecioCosto )

   ::oArticulosPreciosController:oRepository:callUpdatePreciosWhereUuidArticulo( uuidArticulo )
   
   ::oArticulosPreciosController:refreshRowSet()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateTipoIVA() CLASS ArticulosController

   local uuidArticulo   := hget( ::oModel:hBuffer, "uuid" )
   local cCodigoTipoIVA := hget( ::oModel:hBuffer, "tipo_iva_codigo" )

   ::oModel:updateFieldWhereUuid( uuidArticulo, "tipo_iva_codigo", cCodigoTipoIVA )

   ::oArticulosPreciosController:oRepository:callUpdatePreciosWhereUuidArticulo( uuidArticulo )
   
   ::oArticulosPreciosController:refreshRowSet()

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