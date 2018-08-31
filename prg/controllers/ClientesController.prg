#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   DATA oArticulosTarifasController

   METHOD New()

   METHOD End()

   METHOD validColumnAgentesBrowse( uValue, nKey )             INLINE ( ::validColumnBrowse( uValue, nKey, ::oAgentesController:oModel, "agente_uuid" ) )

   METHOD validColumnFormasdePagoBrowse( uValue, nKey )        INLINE ( ::validColumnBrowse( uValue, nKey, ::oFormasPagoController:oModel, "forma_pago_uuid" ) )

   METHOD validColumnRutasBrowse( uValue, nKey )               INLINE ( ::validColumnBrowse( uValue, nKey, ::oRutasController:oModel, "ruta_uuid" ) )

   METHOD validColumnGruposBrowse( uValue, nKey )              INLINE ( ::validColumnBrowse( uValue, nKey, ::oClientesGruposController:oModel, "cliente_grupo_uuid" ) )

   METHOD validColumnCuentasRemesasBrowse( uValue, nKey )      INLINE ( ::validColumnBrowse( uValue, nKey, ::oCuentasRemesasController:oModel, "cuenta_remesa_uuid" ) )

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

   ::oDialogView                    := ClientesView():New( self )

   ::oValidator                     := ClientesValidator():New( self, ::oDialogView )

   ::oBrowseView                    := ClientesBrowseView():New( self )
   
   ::oGetSelector                   := ClientGetSelector():New( self )

   ::oAgentesController             := AgentesController():New( self )
   ::oAgentesController:setView( ::oDialogView )

   ::oArticulosTarifasController    := ArticulosTarifasController():New( self )
   ::oArticulosTarifasController:setView( ::oDialogView )

   ::oFormasPagoController          := FormasPagosController():New( self )
   ::oFormasPagoController:setView( ::oDialogView )

   ::oCuentasRemesasController      := CuentasRemesaController():New( self )
   ::oCuentasRemesasController:setView( ::oDialogView )

   ::oRutasController               := RutasController():New( self )
   ::oRutasController:setView( ::oDialogView )

   ::oClientesGruposController      := ClientesGruposController():New( self )
   ::oClientesGruposController:setView( ::oDialogView )

   ::oDireccionesController         := DireccionesController():New( self )

   ::oContactosController           := ContactosController():New( self )

   ::oIncidenciasController         := IncidenciasController():New( self )

   ::oDocumentosController          := DocumentosController():New( self )

   ::oCuentasBancariasController    := CuentasBancariasController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oDescuentosController          := DescuentosController():New( self )

   ::oClientesEntidadesController   := ClientesEntidadesController():New( self )

/*
   ::oClientesTarifasController     := ClientesTarifasController():New( self )

   
   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )
*/
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesController

   ::oModel:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oBrowseView:End()

   ::oGetSelector:End()

   ::oAgentesController:End()

   ::oArticulosTarifasController:End()

   ::oFormasPagoController:End()

   ::oCuentasRemesasController:End()

   ::oRutasController:End()

   ::oClientesGruposController:End()

   ::oDireccionesController:End()

   ::oContactosController:End()

   ::oIncidenciasController:End()

   ::oDocumentosController:End()

   ::oCuentasBancariasController:End()

   ::oCamposExtraValoresController:End()

   ::oDescuentosController:End()

   ::oClientesEntidadesController:End()

/*
   ::oClientesTarifasController:End()
*/
   
   ::Super:End()
   
   ::oModel                      := nil 

   ::oDialogView                 := nil

   ::oValidator                  := nil

   ::oBrowseView                 := nil 

   ::oGetSelector                := nil

   ::oAgentesController          := nil
   
   ::oArticulosTarifasController := nil
   
   ::oFormasPagoController       := nil

   ::oCuentasRemesasController   := nil

   ::oRutasController            := nil

   ::oClientesGruposController   := nil

   ::oDireccionesController      := nil

   ::oContactosController        := nil

   ::oIncidenciasController      := nil

   ::oDocumentosController       := nil

   self                          := nil

RETURN ( nil )

//---------------------------------------------------------------------------//
