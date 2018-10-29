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

   METHOD validColumnFormasdePagoBrowse( uValue, nKey )        INLINE ( ::validColumnBrowse( uValue, nKey, ::getFormasPagoController():oModel, "forma_pago_uuid" ) )

   METHOD validColumnRutasBrowse( uValue, nKey )               INLINE ( ::validColumnBrowse( uValue, nKey, ::getRutasController():oModel, "ruta_uuid" ) )

   METHOD validColumnGruposBrowse( uValue, nKey )              INLINE ( ::validColumnBrowse( uValue, nKey, ::getClientesGruposController():oModel, "cliente_grupo_uuid" ) )

   METHOD validColumnCuentasRemesasBrowse( uValue, nKey )      INLINE ( ::validColumnBrowse( uValue, nKey, ::getCuentasRemesasController():oModel, "cuenta_remesa_uuid" ) )

   METHOD setUuidOldersParents()

   METHOD getDuplicateOthers()

   //Construcciones tardias----------------------------------------------------

   METHOD getDialogView()                                      INLINE ( if( empty( ::oDialogView ), ::oDialogView := TercerosView():New( self ), ), ::oDialogView )

   METHOD getBrowseView()                                      INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := TercerosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getValidator()                                       INLINE( if( empty( ::oValidator ), ::oValidator := TercerosValidator():New( self ), ), ::oValidator )

   METHOD getSelector()                                        INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := ClientGetSelector():New( self ), ), ::oGetSelector )

   METHOD getModel()                                           VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController) CLASS TercerosController

   ::Super:New( oController )

   ::lTransactional     := .f.

   ::getModel():setEvent( 'loadedBlankBuffer',           {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',              {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',         {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',               {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer',    {|| ::setUuidOldersParents() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',           {|| ::getDuplicateOthers() } )
   
   ::oModel:setEvent( 'deletedSelection',                {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ), ::getDescuentosController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )  } )

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

METHOD setUuidOldersParents()

   ::getDireccionesController():setUuidOlderParent( ::getUuid() )

   ::getDescuentosController():setUuidOlderParent( ::getUuid() )
                                                             
   ::getContactosController():setUuidOlderParent( ::getUuid() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getDuplicateOthers()

   ::getDireccionesController():duplicateOthers( ::getUuid() )
                                                          
   ::getDescuentosController():duplicateOthers( ::getUuid() )

   ::getContactosController():duplicateOthers( ::getUuid() )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

