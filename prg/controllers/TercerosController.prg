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

   METHOD deletedOthersSelection()

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

   ::getModel():setEvent( 'loadedBlankBuffer',              {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',                 {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',            {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                  {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer',   {|| ::setUuidOldersParents() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',          {|| ::getDuplicateOthers() } )
   
   ::getModel():setEvent( 'deletedSelection',               {|| ::deletedOthersSelection()  } )

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

METHOD setUuidOldersParents() CLASS TercerosController

   ::getDireccionesController():getModel():setUuidOlderParent( ::getUuid() )

   ::getDescuentosController():getModel():setUuidOlderParent( ::getUuid() )
                                                             
   ::getContactosController():getModel():setUuidOlderParent( ::getUuid() )

   ::getCuentasBancariasController():getModel():setUuidOlderParent( ::getUuid() )

   ::getIncidenciasController():getModel():setUuidOlderParent( ::getUuid() )

   ::getDocumentosController():getModel():setUuidOlderParent( ::getUuid() )

   ::getClientesEntidadesController():getModel():setUuidOlderParent( ::getUuid() )

   ::getCamposExtraValoresController():getModel():setUuidOlderParent( ::getUuid() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getDuplicateOthers() CLASS TercerosController

   ::getDireccionesController():getModel():duplicateOthers( ::getUuid() )
                                                          
   ::getDescuentosController():getModel():duplicateOthers( ::getUuid() )

   ::getContactosController():getModel():duplicateOthers( ::getUuid() )
   
   ::getCuentasBancariasController():getModel():duplicateOthers( ::getUuid() )

   ::getIncidenciasController():getModel():duplicateOthers( ::getUuid() )

   ::getDocumentosController():getModel():duplicateOthers( ::getUuid() )

   ::getClientesEntidadesController():getModel():duplicateOthers( ::getUuid() )
   
   ::getCamposExtraValoresController():getModel():duplicateOthers( ::getUuid() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deletedOthersSelection() CLASS TercerosController

   ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) 

   ::getDescuentosController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getContactosController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getCuentasBancariasController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getIncidenciasController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getDocumentosController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

   ::getClientesEntidadesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

