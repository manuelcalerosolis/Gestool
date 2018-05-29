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

   DATA oTagsController

   DATA oArticulosUnidadesMedicionController

   DATA oPrimeraPropiedadController

   DATA oSegundaPropiedadController

   DATA oTraduccionesController

   DATA oImagenesController

   METHOD New()

   METHOD End()

   METHOD insertPreciosWhereArticulo()

   METHOD getPrecioCosto()        

   METHOD getPorcentajeIVA()

   METHOD validColumnArticulosFamiliaBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosFamiliasController:oModel, "articulo_familia_uuid" ) )

   METHOD validColumnArticulosTipoBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosTipoController:oModel, "articulo_tipo_uuid" ) )

   METHOD validColumnArticulosCategoriasBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosCategoriasController:oModel, "articulo_categoria_uuid" ) )

   METHOD validColumnArticulosFabricantesBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oArticulosFabricantesController:oModel, "articulo_fabricante_uuid" ) )

   METHOD validColumnTiposIvaBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oTipoIvaController:oModel, "tipo_iva_uuid" ) )

   METHOD validColumnImpuestosEspecialesBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oImpuestosEspecialesController:oModel, "impuesto_especial_uuid" ) )

   METHOD validPrimeraPropiedadBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oPrimeraPropiedadController:oModel, "primera_propiedad_uuid" ) )

   METHOD validSegundaPropiedadBrowse( oCol, uValue, nKey ) ;
         INLINE ( ::validColumnBrowse( oCol, uValue, nKey, ::oSegundaPropiedadController:oModel, "segunda_propiedad_uuid" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosController

   ::Super:New()

   ::cTitle                            := "Artículos"

   ::cName                             := "articulos"

   ::hImage                            := {  "16" => "gc_object_cube_16",;
                                             "32" => "gc_object_cube_32",;
                                             "48" => "gc_object_cube_48" }

   ::lTransactional                    := .t.

   ::nLevel                            := Auth():Level( ::cName )

   ::oModel                            := SQLArticulosModel():New( self )

   ::oBrowseView                       := ArticulosBrowseView():New( self )

   ::oDialogView                       := ArticulosView():New( self )

   ::oValidator                        := ArticulosValidator():New( self, ::oDialogView )

   ::oRepository                       := ArticulosRepository():New( self )

   ::oCamposExtraValoresController     := CamposExtraValoresController():New( self, 'clientes' )

   ::oTagsController                   := TagsController():New( self )

   ::oArticulosFamiliasController      := ArticulosFamiliasController():New( self )

   ::oArticulosTipoController          := ArticulosTipoController():New( self )

   ::oArticulosCategoriasController    := ArticulosCategoriasController():New( self )

   ::oArticulosFabricantesController   := ArticulosFabricantesController():New( self )

   ::oTipoIvaController                := TipoIvaController():New( self )

   ::oImpuestosEspecialesController    := ImpuestosEspecialesController():New( self )

   ::oArticulosPreciosController       := ArticulosPreciosController():New( self )

   ::oPrimeraPropiedadController             := PropiedadesController():New( self )

   ::oSegundaPropiedadController             := PropiedadesController():New( self )
   
   ::oArticulosUnidadesMedicionController    := ArticulosUnidadesMedicionController():New( self )

   ::oImagenesController                     := ImagenesController():New( self )

   ::oTraduccionesController                 := TraduccionesController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvents( { 'loadedBlankBuffer', 'loadedCurrentBuffer' }, {|| ::insertPreciosWhereArticulo() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oCamposExtraValoresController:End()

   ::oTagsController:End()

   ::oArticulosFamiliasController:End()

   ::oArticulosTipoController:End()

   ::oArticulosCategoriasController:End()

   ::oArticulosFabricantesController:End()

   ::oArticulosPreciosController:End()

   ::oTipoIvaController:End()

   ::oImpuestosEspecialesController:End()

   ::oPrimeraPropiedadController:End()

   ::oSegundaPropiedadController:End()

   ::oArticulosUnidadesMedicionController:End()

   ::oImagenesController:End()

   ::oTraduccionesController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getPrecioCosto() CLASS ArticulosController

   if empty(::oModel)
      RETURN ( 0 )
   end if 

   if empty(::oModel:hBuffer)
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

RETURN ( ::oTipoIvaController:oModel:getPorcentajeWhereCodigo( ::oModel:hBuffer[ "tipo_iva_uuid" ] ) )

//---------------------------------------------------------------------------//

METHOD insertPreciosWhereArticulo() CLASS ArticulosController

   local uuidArticulo   := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidArticulo )
      RETURN ( Self )
   end if 

   SQLArticulosPreciosModel():insertPreciosWhereArticulo( uuidArticulo )   

RETURN ( Self )

//---------------------------------------------------------------------------//
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

