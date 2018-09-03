#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesController FROM SQLNavigatorController

   DATA oArticulosTarifasController

   DATA oClientesController

   DATA oArticulosController

   DATA oSerieDocumentoComponent

   DATA oNumeroDocumentoComponent

   DATA oFormasPagoController

   DATA oRutasController

   DATA oAgentesController

   DATA oAlmacenesController

   DATA oContadoresModel

   DATA oClientesTarifasController

   DATA oFacturasClientesDescuentosController

   DATA oDireccionTipoDocumentoController

   DATA oFacturasClientesLineasController

   DATA oCombinacionesController

   DATA oCamposExtraValoresController

   DATA oIncidenciasController

   DATA oHistoryManager

   METHOD New()

   METHOD End()

   METHOD loadedBlankBuffer() 

   METHOD loadedBuffer()               INLINE ( ::oHistoryManager:Set( ::oModel:hBuffer ) )

   METHOD getClientUuid() 

   METHOD isClientFilled()             INLINE ( !empty( ::getModelBuffer( "cliente_codigo" ) ) )

   METHOD clientesSettedHelpText()

   METHOD clientesCleanedHelpText()    INLINE ( ::oArticulosTarifasController:oGetSelector:cText( space( 20 ) ),;
                                                ::oArticulosTarifasController:oGetSelector:lValid() )

   METHOD clientSetTarifa()

   METHOD clientSetDescuentos()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesController

   ::Super:New( oController )

   ::cTitle                                              := "Facturas de clientes"

   ::cName                                               := "facturas_clientes"
   
   ::lTransactional                                      := .t.

   ::hImage                                              := {  "16" => "gc_document_text_user_16",;
                                                               "32" => "gc_document_text_user_32",;
                                                               "48" => "gc_document_text_user_48" }

   ::oModel                                              := SQLFacturasClientesModel():New( self )

   ::oDialogView                                         := FacturasClientesView():New( self )

   ::oValidator                                          := FacturasClientesValidator():New( self, ::oDialogView )

   ::oBrowseView                                         := FacturasClientesBrowseView():New( self )

   ::oRepository                                         := FacturasClientesRepository():New( self )

   ::oContadoresModel                                    := SQLContadoresModel():New( self )

   ::oClientesController                                 := ClientesController():New( self )
   ::oClientesController:setView( ::oDialogView )

   ::oArticulosController                                := ArticulosController():New( self )
/*
   ::oArticulosTarifasController                         := ArticulosTarifasController():New( self )
   ::oArticulosTarifasController:setView( ::oDialogView )

   ::oFormasPagoController                               := FormasPagosController():New( self )   
   ::oFormasPagoController:setView( ::oDialogView )

   ::oRutasController                                    := RutasController():New( self )
   ::oRutasController:setView( ::oDialogView )

   ::oAgentesController                                  := AgentesController():New( self )
   ::oAgentesController:setView( ::oDialogView )

   ::oAlmacenesController                                := AlmacenesController():New( self )
   ::oAlmacenesController:setView( ::oDialogView )

   ::oClientesTarifasController                          := ClientesTarifasController():New( self )

   ::oFacturasClientesLineasController                   := FacturasClientesLineasController():New( self )
   
   ::oFacturasClientesDescuentosController               := FacturasClientesDescuentosController():New( self )

   ::oDireccionTipoDocumentoController                   := DireccionTipoDocumentoController():New( self )

   ::oCamposExtraValoresController                       := CamposExtraValoresController():New( self )

   ::oCombinacionesController                            := CombinacionesController():New( self )

   ::oCamposExtraValoresController                       := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oIncidenciasController                              := IncidenciasController():New( self )

   ::oHistoryManager                                     := HistoryManager():New()

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',               {|| ::loadedBlankBuffer() } )

   ::oModel:setEvent( 'loadedBuffer',                    {|| ::loadedBuffer() } )

   ::oDireccionTipoDocumentoController:setEvent( 'activatingDialogView',         {|| ::isClientFilled() } ) 
   ::oDireccionTipoDocumentoController:oModel:setEvent( 'gettingSelectSentence', {|| ::getClientUuid() } )

   ::oFacturasClientesLineasController:setEvents( { 'appending', 'editing', 'deleting' }, {|| ::isClientFilled() }  )

   ::oClientesController:oGetSelector:setEvent( 'settedHelpText', {|| ::clientesSettedHelpText() } )

   ::oClientesController:oGetSelector:setEvent( 'cleanedHelpText', {|| ::clientesCleanedHelpText() } )

   ::oNumeroDocumentoComponent                           := NumeroDocumentoComponent():New( self )

   ::oSerieDocumentoComponent                            := SerieDocumentoComponent():New( self )
<<<<<<< HEAD
*/

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

   if !empty( ::oContadoresModel )
      ::oContadoresModel:End()
   end if

   if !empty( ::oClientesController )
      ::oClientesController:End()
   end if

   if !empty( ::oArticulosController )
      ::oArticulosController:End()
   end if

   if !empty( ::oArticulosTarifasController )
      ::oArticulosTarifasController:End()
   end if 

   if !empty( ::oFormasPagoController )
      ::oFormasPagoController:End()
   end if 

   if !empty( ::oRutasController )
      ::oRutasController:End()
   end if 

   if !empty( ::oAgentesController )
      ::oAgentesController:End()
   end if 
 
   if !empty( ::oAlmacenesController )
      ::oAlmacenesController:End()
   end if 

   if !empty( ::oClientesTarifasController )
      ::oClientesTarifasController:End()
   end if 

   if !empty( ::oFacturasClientesDescuentosController )
      ::oFacturasClientesDescuentosController:End()
   end if 

   if !empty( ::oDireccionTipoDocumentoController )
      ::oDireccionTipoDocumentoController:End()
   end if 

   if !empty( ::oCamposExtraValoresController )
      ::oCamposExtraValoresController:End()
   end if 
   
   if !empty( ::oIncidenciasController )
      ::oIncidenciasController:End()
   end if 

   if !empty( ::oFacturasClientesLineasController )
      ::oFacturasClientesLineasController:End()
   end if 

   if !empty( ::oHistoryManager )
      ::oHistoryManager:End()
   end if 

   if !empty( ::oNumeroDocumentoComponent )
      ::oNumeroDocumentoComponent:End()
   end if 

   if !empty( ::oSerieDocumentoComponent )
      ::oSerieDocumentoComponent:End()
   end if 

   ::Super:End()

   hb_gcall( .t. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS FacturasClientesController

   hset( ::oModel:hBuffer, "serie",    ::oContadoresModel:getDocumentSerie( ::cName ) )
   
   hset( ::oModel:hBuffer, "numero",   ::oContadoresModel:getDocumentCounter( ::cName ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getClientUuid() CLASS FacturasClientesController

   local uuidClient 

   uuidClient  := ::oClientesController:oModel:getUuidWhereCodigo( ::getModelBuffer( "cliente_codigo" ) )
   if !empty( uuidClient )
      ::oDireccionTipoDocumentoController:oDireccionesController:setUuidParent( uuidClient )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientesSettedHelpText() CLASS FacturasClientesController

   if ::oHistoryManager:isEqual( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )
      RETURN ( nil )
   end if          

   ::clientSetTarifa()

   ::clientSetDescuentos()

   ::oHistoryManager:setkey( "cliente_codigo", ::getModelBuffer( "cliente_codigo" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetTarifa() CLASS FacturasClientesController

   local cCodigoTarifa

   if empty( ::oClientesController:oGetSelector:uFields )
      RETURN ( nil )
   end if 

   cCodigoTarifa     := hget( ::oClientesController:oGetSelector:uFields, "tarifa_codigo" )

   if empty( cCodigoTarifa )
      cCodigoTarifa  := Company():getDefaultTarifa()
   end if

   ::oArticulosTarifasController:oGetSelector:cText( cCodigoTarifa )
   
   ::oArticulosTarifasController:oGetSelector:lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientSetDescuentos() CLASS FacturasClientesController

   ::oFacturasClientesDescuentosController:oModel:deleteWhereParentUuid( ::getModelBuffer( "uuid" ) )

   ::oFacturasClientesDescuentosController:oModel:insertWhereClienteCodigo( ::getModelBuffer( "cliente_codigo" ) )

   ::oFacturasClientesDescuentosController:refreshRowSetAndGoTop()

   ::oFacturasClientesDescuentosController:refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesValidator

   ::hValidators  := {  "codigo" =>    {  "required"   => "El código del cliente es un dato requerido"  } ,;  
                        "nombre" =>    {  "required"   => "El nombre del cliente es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'numero'
      :cHeader             := 'Número'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'numero' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'delegacion_uuid'    
      :cHeader             := 'Delegación uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'delegacion_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sesion_uuid'
      :cHeader             := 'Sesión uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'sesion_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_codigo'
      :cHeader             := 'Código cliente'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_nombre'
      :cHeader             := 'Nombre cliente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_poblacion'
      :cHeader             := 'Población'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_codigo_provincia'
      :cHeader             := 'Código provincia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_codigo_provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_codigo_postal'
      :cHeader             := 'Código postal'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_telefono'
      :cHeader             := 'Teléfono'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_movil'
      :cHeader             := 'Móvil'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_movil' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion_email'
      :cHeader             := 'Mail'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion_email' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifa_codigo'
      :cHeader             := 'Código tarifa'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifa_nombre'
      :cHeader             := 'Nombre tarifa'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

