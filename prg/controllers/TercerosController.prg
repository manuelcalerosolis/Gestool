#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosController FROM SQLNavigatorController

   DATA cMessage

   DATA oDireccionesController 

   DATA oPaisesController

   DATA oProvinciasController

   DATA oFormasPagoController

   DATA oCuentasRemesasController

   DATA oRutasController

   DATA oTercerosGruposController

   DATA oContactosController

   DATA oIncidenciasController

   DATA oDocumentosController

   DATA oCuentasBancariasController

   DATA oCamposExtraValoresController

   DATA oDescuentosController

   DATA oTercerosEntidadesController

   DATA oClientesTarifasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD validColumnFormasdePagoBrowse( uValue, nKey ) ;       
                                       INLINE ( ::validColumnBrowse( uValue, nKey, ::getFormasPagoController():oModel, "forma_pago_uuid" ) )

   METHOD validColumnRutasBrowse( uValue, nKey ) ;       
                                       INLINE ( ::validColumnBrowse( uValue, nKey, ::getRutasController():oModel, "ruta_uuid" ) )

   METHOD validColumnGruposBrowse( uValue, nKey ) ;       
                                       INLINE ( ::validColumnBrowse( uValue, nKey, ::getTercerosGruposController():oModel, "cliente_grupo_uuid" ) )

   METHOD validColumnCuentasRemesasBrowse( uValue, nKey ) ;      
                                       INLINE ( ::validColumnBrowse( uValue, nKey, ::getCuentasRemesasController():oModel, "cuenta_remesa_uuid" ) )

   METHOD validColumnAgentesBrowse( uValue, nKey ) ;       
                                       INLINE ( ::validColumnBrowse( uValue, nKey, ::getAgentesController():oModel, "agente_uuid" ) )

   METHOD setUuidOldersParents()

   METHOD getDuplicateOthers()

   METHOD deletedOthersSelection()

   METHOD buildRowSetSentence( cType )

   // Construcciones tardias---------------------------------------------------

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := TercerosView():New( self ), ), ::oDialogView )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := TercerosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := TercerosValidator():New( self ), ), ::oValidator )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLTercerosModel():New( self ), ), ::oModel )

   METHOD getSelector()                INLINE ( iif( empty( ::oGetSelector ), ::oGetSelector := TerceroGetSelector():New( self ), ), ::oGetSelector )

   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := TercerosItemRange():New( self,  ), ), ::oRange )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController) CLASS TercerosController

   ::Super:New( oController )

   ::lTransactional                    := .f.

   ::cTitle                            := "Terceros"

   ::cMessage                          := "Tercero"

   ::cName                             := "terceros"

   ::hImage                            := {  "16" => "gc_user_16",;
                                             "32" => "gc_user_32",;
                                             "48" => "gc_user2_48" }

   ::getModel():setEvent( 'loadedBlankBuffer',              {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',                 {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',            {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                  {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer',   {|| ::setUuidOldersParents() } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',          {|| ::getDuplicateOthers() } )
   
   ::getModel():setEvent( 'deletedSelection',               {|| ::deletedOthersSelection() } )

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

    if !empty( ::oModel )
      ::oModel:End()
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

   ::getTercerosEntidadesController():getModel():setUuidOlderParent( ::getUuid() )

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

   ::getTercerosEntidadesController():getModel():duplicateOthers( ::getUuid() )
   
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

   ::getTercerosEntidadesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )
   
   ::getCamposExtraValoresController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSetSentence( cType )

   local cColumnOrder         
   local cColumnOrientation  

   if !empty( ::getBrowseView() )
      cColumnOrder            := ::getBrowseView():getColumnOrderView( cType, ::getName() )
      cColumnOrientation      := ::getBrowseView():getColumnOrientationView( cType, ::getName() )
   end if 

   if empty( ::oController )
      ::getRowSet():Build( ::getModel():getSelectSentence( cColumnOrder, cColumnOrientation ) )
      RETURN ( nil )
   end if

   if ::oController:isClient()
      ::getRowSet():Build( ::getModel():getSelectClient( cColumnOrder, cColumnOrientation ) )
   else
      ::getRowSet():Build( ::getModel():getSelectProveedor( cColumnOrder, cColumnOrientation ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestTercerosController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 
   
   METHOD test_create()                

   METHOD test_dialogo_sin_codigo()     

   METHOD test_dialogo_creacion()       

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestTercerosController

   ::oController  := TercerosController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestTercerosController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestTercerosController

   SQLTercerosModel():truncateTable()

   SQLDireccionesModel():truncateTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create() CLASS TestTercerosController

   local hBuffer

   hBuffer  := ::oController:getModel();
                  :loadBlankBuffer( {  "codigo" => "0",;
                                       "nombre" => "Test de cliente/proveedor",;
                                       "dni"    => "757575757A",;
                                       "tipo"   => "Cliente/Proveedor" } )
   
   ::Assert():notEquals( 0, ::oController:getModel():insertBuffer( hBuffer ), "test creacion terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_codigo() CLASS TestTercerosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[1] ):cText( "Test de cliente/proveedor" ),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[1] ):cText( "75757575A" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test creación de tercero sin codigo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_creacion() CLASS TestTercerosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oFolder:aDialogs[1] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[1] ):cText( "Test de cliente/proveedor" ),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[1] ):cText( "75757575A" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creación de factura sin lineas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
