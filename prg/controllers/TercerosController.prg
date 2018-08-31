#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

   DATA oAgentesController

   DATA oFormasPagoController

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

   DATA oClientesTarifasController

   METHOD New()

   METHOD End()

   METHOD DireccionesControllerLoadCurrentBuffer()

   METHOD DireccionesControllerUpdateBuffer()

   METHOD DireccionesControllerDeleteBuffer()

   METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   METHOD DireccionesControllerLoadedDuplicateBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController) CLASS TercerosController

   ::Super:New( oSenderController )

   ::lTransactional              := .t.

   ::oBrowseView                 := TercerosBrowseView():New( self )

   ::oRepository                 := TercerosRepository():New( self )

   ::oGetSelector                := GetSelector():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TercerosController

   ::oBrowseView:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::Super:End()

   ::oBrowseView     := nil

   ::oRepository     := nil

   ::oGetSelector    := nil

   self              := nil

RETURN ( nil )

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