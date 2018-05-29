#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

   DATA oAgentesController

   DATA oFormasdePagoController

   DATA oCuentasRemesasController

   DATA oRutasController

   DATA oClientesGruposController

   DATA oContactosController

   DATA oIncidenciasController

   DATA oDocumentosController

   DATA oCuentasBancariasController

   DATA oCamposExtraValoresController

   DATA oDescuentosController

   DATA oClientesEntidadesController

   METHOD New()

   METHOD End()

   METHOD DireccionesControllerLoadCurrentBuffer()

   METHOD DireccionesControllerUpdateBuffer()

   METHOD DireccionesControllerDeleteBuffer()

   METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   METHOD DireccionesControllerLoadedDuplicateBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TercerosController

   ::Super:New()

   ::oBrowseView                 := TercerosBrowseView():New( self )

   ::oRepository                 := TercerosRepository():New( self )

   ::lTransactional              := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TercerosController

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadCurrentBuffer()

   local idDireccion     
   local uuid        := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuid )
      ::oDireccionesController:oModel:insertBuffer()
   end if 

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuid )

   if empty( idDireccion )
      ::oDireccionesController:oModel:loadBlankBuffer()
      idDireccion       := ::oDireccionesController:oModel:insertBuffer()
   end if 

   ::oDireccionesController:oModel:loadCurrentBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerUpdateBuffer()

   local idDireccion     
   local uuid     := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuid )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oDireccionesController:oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerDeleteBuffer()

   local aUuid    := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuid )
      RETURN ( self )
   end if

   ::oDireccionesController:oModel:deleteWhereParentUuid( aUuid )

   RETURN ( self )
//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   local uuid
   local idDireccion     

   uuid           := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuid )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oDireccionesController:oModel:loadDuplicateBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateBuffer()

   local uuid     := hget( ::oModel:hBuffer, "uuid" )

   hset( ::oDireccionesController:oModel:hBuffer, "parent_uuid", uuid )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLTercerosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//