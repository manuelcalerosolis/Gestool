#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosController FROM SQLNavigatorController

   DATA cMessage

   DATA isClient                      

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

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

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD DireccionesControllerLoadCurrentBuffer()

   METHOD DireccionesControllerUpdateBuffer()

   METHOD DireccionesControllerDeleteBuffer()

   METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   METHOD DireccionesControllerLoadedDuplicateBuffer()

   METHOD validColumnFormasdePagoBrowse( uValue, nKey )        INLINE ( ::validColumnBrowse( uValue, nKey, ::getFormasPagoController():oModel, "forma_pago_uuid" ) )

   METHOD validColumnRutasBrowse( uValue, nKey )               INLINE ( ::validColumnBrowse( uValue, nKey, ::getRutasController():oModel, "ruta_uuid" ) )

   METHOD validColumnGruposBrowse( uValue, nKey )              INLINE ( ::validColumnBrowse( uValue, nKey, ::getClientesGruposController():oModel, "cliente_grupo_uuid" ) )

   METHOD validColumnCuentasRemesasBrowse( uValue, nKey )      INLINE ( ::validColumnBrowse( uValue, nKey, ::getCuentasRemesasController():oModel, "cuenta_remesa_uuid" ) )

   //Construcciones tardias----------------------------------------------------

   METHOD getDialogView()                                      INLINE ( if( empty( ::oDialogView ), ::oDialogView := TercerosView():New( self ), ), ::oDialogView )

   METHOD getBrowseView()                                      INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := TercerosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getValidator()                                       INLINE( if( empty( ::oValidator ), ::oValidator := TercerosValidator():New( self ), ), ::oValidator )

   METHOD getSelector()                                        INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := ClientGetSelector():New( self ), ), ::oGetSelector )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController) CLASS TercerosController

   ::Super:New( oController )

   ::lTransactional     := .t.

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TercerosController

   if !empty(::oDialogView)
      ::oDialogView:End()
   end if 

   if !empty(::oValidator)
      ::oValidator:End()
   end if 

   if !empty(::oBrowseView)
      ::oBrowseView:End()
   end if 

   if !empty(::oGetSelector)
      ::oGetSelector:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadCurrentBuffer()

   local idDireccion     
   local uuid           := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuid )
      ::getDireccionesController():oModel:insertBuffer()
   end if 

   idDireccion          := ::getDireccionesController():oModel:getIdWhereParentUuid( uuid )

   if empty( idDireccion )
      ::getDireccionesController():oModel:loadBlankBuffer()
      idDireccion       := ::getDireccionesController():oModel:insertBuffer()
   end if 

   ::getDireccionesController():oModel:loadCurrentBuffer( idDireccion )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerUpdateBuffer()

   local idDireccion     
   local uuid           := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::getDireccionesController():oModel:getIdWhereParentUuid( uuid )
   if empty( idDireccion )
      ::getDireccionesController():oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::getDireccionesController():oModel:updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerDeleteBuffer()

   local aUuid          := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuid )
      RETURN ( nil )
   end if

   ::getDireccionesController():oModel:deleteWhereParentUuid( aUuid )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   local uuid
   local idDireccion     

   uuid                 := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::getDireccionesController():oModel:getIdWhereParentUuid( uuid )
   if empty( idDireccion )
      ::getDireccionesController():oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::getDireccionesController():oModel:loadDuplicateBuffer( idDireccion )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateBuffer()

   local uuid           := hget( ::oModel:hBuffer, "uuid" )

   hset( ::getDireccionesController():oModel:hBuffer, "parent_uuid", uuid )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

