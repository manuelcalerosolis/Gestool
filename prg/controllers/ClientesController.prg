#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   METHOD New()

   METHOD End()

   METHOD validColumnAgentesBrowse( uValue, nKey )             INLINE ( ::validColumnBrowse( uValue, nKey, ::getAgentesController():oModel, "agente_uuid" ) )

   METHOD validColumnFormasdePagoBrowse( uValue, nKey )        INLINE ( ::validColumnBrowse( uValue, nKey, ::getFormasPagoController():oModel, "forma_pago_uuid" ) )

   METHOD validColumnRutasBrowse( uValue, nKey )               INLINE ( ::validColumnBrowse( uValue, nKey, ::getRutasController():oModel, "ruta_uuid" ) )

   METHOD validColumnGruposBrowse( uValue, nKey )              INLINE ( ::validColumnBrowse( uValue, nKey, ::getClientesGruposController():oModel, "cliente_grupo_uuid" ) )

   METHOD validColumnCuentasRemesasBrowse( uValue, nKey )      INLINE ( ::validColumnBrowse( uValue, nKey, ::getCuentasRemesasController():oModel, "cuenta_remesa_uuid" ) )

   // Construcciones tardias---------------------------------------------------

   METHOD getDialogView()                                      INLINE ( if( empty( ::oDialogView ), ::oDialogView := ClientesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                                       INLINE ( if( empty(  ::oValidator ), ::oValidator := ClientesValidator():New( self, ::getDialogView() ), ), ::oValidator )

   METHOD getBrowseView()                                      INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := ClientesBrowseView():New( self ), ), ::oBrowseView )
   
   METHOD getSelector()                                        INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := ClientGetSelector():New( self ), ), ::oGetSelector )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ClientesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Clientes"

   ::cName                          := "clientes_sql"

   ::hImage                         := {  "16" => "gc_user_16",;
                                          "32" => "gc_user_32",;
                                          "48" => "gc_user2_48" }

   ::oModel                         := SQLClientesModel():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesController

   ::oModel:End()

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
 
   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
