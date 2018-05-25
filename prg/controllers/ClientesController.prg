#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   METHOD New()

   METHOD End()

   METHOD validColumnAgentesBrowse( uValue, nKey )             INLINE ( ::validColumnBrowse( uValue, nKey, ::oAgentesController:oModel, "agente_uuid" ) )

   METHOD validColumnFormasdePagoBrowse( uValue, nKey )        INLINE ( ::validColumnBrowse( uValue, nKey, ::oFormasdePagoController:oModel, "forma_pago_uuid" ) )

   METHOD validColumnRutasBrowse( uValue, nKey )               INLINE ( ::validColumnBrowse( uValue, nKey, ::oRutasController:oModel, "ruta_uuid" ) )

   METHOD validColumnGruposBrowse( uValue, nKey )              INLINE ( ::validColumnBrowse( uValue, nKey, ::oClientesGruposController:oModel, "cliente_grupo_uuid" ) )

   METHOD validColumnCuentasRemesasBrowse( uValue, nKey )      INLINE ( ::validColumnBrowse( uValue, nKey, ::oCuentasRemesasController:oModel, "cuenta_remesa_uuid" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ClientesController

   ::Super:New()

   ::cTitle                         := "Clientes"

   ::cName                          := "clientes_sql"

   ::hImage                         := {  "16" => "gc_user_16",;
                                          "32" => "gc_user_32",;
                                          "48" => "gc_user2_48" }

   ::oModel                         := SQLClientesModel():New( self )

   ::oDialogView                    := ClientesView():New( self )

   ::oValidator                     := ClientesValidator():New( self, ::oDialogView )

   ::oBrowseView                    := ClientesBrowseView():New( self )

   ::oAgentesController             := AgentesController():New( self )

   ::oFormasdePagoController        := FormaPagoController():New( self )

   ::oCuentasRemesasController      := CuentasRemesaController():New( self )

   ::oRutasController               := RutasController():New( self )

   ::oClientesGruposController      := ClientesGruposController():New( self )

   ::oDireccionesController         := DireccionesController():New( self )
   ::oDireccionesController:oValidator:setDialog( ::oDialogView )

   ::oContactosController           := ContactosController():New( self )

   ::oIncidenciasController         := IncidenciasController():New( self )

   ::oDocumentosController          := DocumentosController():New( self )

   ::oCuentasBancariasController    := CuentasBancariasController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oDescuentosController          := DescuentosController():New( self )

   ::oClientesEntidadesController   := ClientesEntidadesController():New( self )
   
   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesController

   ::oContactosController:End()

   ::oIncidenciasController:End()

   ::oDocumentosController:End()

   ::oCuentasBancariasController:End()

   ::oCamposExtraValoresController:End()

   ::oDescuentosController:End()

   ::oClientesEntidadesController:End()

   ::oAgentesController:End()

   ::oFormasdePagoController:End()

   ::oCuentasRemesasController:End()

   ::oRutasController:End()

   ::oClientesGruposController :End()

   ::oDireccionesController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
