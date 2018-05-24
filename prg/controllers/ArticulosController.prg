#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosController FROM SQLNavigatorController

   DATA oArticulosTipoController

   DATA oArticulosCategoriasController

   DATA oArticulosFamiliaController

   DATA oArticulosFabricantesController

   DATA oArticulosPreciosController

   DATA oIvaTipoController

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

   ::oArticulosFamiliaController       := ArticulosFamiliaController():New( self )

   ::oArticulosTipoController          := ArticulosTipoController():New( self )

   ::oArticulosCategoriasController    := ArticulosCategoriasController():New( self )

   ::oArticulosFabricantesController   := ArticulosFabricantesController():New( self )

   ::oArticulosPreciosController       := ArticulosPreciosController():New( self )

   ::oIvaTipoController                := IvaTipoController():New( self )

   ::oImpuestosEspecialesController    := ImpuestosEspecialesController():New( self )

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

   ::oArticulosFamiliaController:End()

   ::oArticulosTipoController:End()

   ::oArticulosCategoriasController:End()

   ::oArticulosFabricantesController:End()

   ::oArticulosPreciosController:End()

   ::oIvaTipoController:End()

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

RETURN ( ::oIvaTipoController:oModel:getPorcentajeWhereCodigo( ::oModel:hBuffer[ "iva_tipo_uuid" ] ) )

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

