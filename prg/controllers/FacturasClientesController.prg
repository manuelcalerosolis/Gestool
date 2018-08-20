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

   DATA oLineasController

   METHOD New()

   METHOD End()

   METHOD loadedBlankBuffer() 

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

   ::oContadoresModel                                    := SQLContadoresModel():New( self )

   ::oDialogView                                         := FacturasClientesView():New( self )

   ::oValidator                                          := FacturasClientesValidator():New( self, ::oDialogView )

   ::oBrowseView                                         := FacturasClientesBrowseView():New( self )

   ::oRepository                                         := FacturasClientesRepository():New( self )

   ::oClientesController                                 := ClientesController():New( self )

   ::oArticulosController                                := ArticulosController():New( self )

   ::oArticulosTarifasController                         := ArticulosTarifasController():New( self )
   ::oArticulosTarifasController:setView( ::oDialogView )

   ::oNumeroDocumentoComponent                           := NumeroDocumentoComponent():New( self )

   ::oSerieDocumentoComponent                            := SerieDocumentoComponent():New( self )

   ::oFormasPagoController                               := FormasPagosController():New( self )   
   ::oFormasPagoController:setView( ::oDialogView )

   ::oRutasController                                    := RutasController():New( self )
   ::oRutasController:setView( ::oDialogView )

   ::oAgentesController                                  := AgentesController():New( self )
   ::oAgentesController:setView( ::oDialogView )

   ::oAlmacenesController                                := AlmacenesController():New( self )
   ::oAlmacenesController:setView( ::oDialogView )

   ::oClientesTarifasController                          := ClientesTarifasController():New( self )

   ::oLineasController                                   := FacturasClientesLineasController():New( self )
   
   ::oFacturasClientesDescuentosController         := FacturasClientesDescuentosController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } )

   ::oClientesController:oGetSelector:setEvent( 'settedHelpText', {|| ::clientesSettedHelpText() } )

   ::oClientesController:oGetSelector:setEvent( 'cleanedHelpText', {|| ::clientesCleanedHelpText() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

   ::oClientesController:End()

   ::oArticulosController:End()

   ::oFormasPagoController:End()

   ::oRutasController:End()

   ::oAgentesController:End()
 
   ::oAlmacenesController:End()

   ::oArticulosTarifasController:End()

   ::oClientesTarifasController:End()

   ::oFacturasClientesDescuentosLineasController:End()

   ::oLineasController:End()

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS FacturasClientesController

   hset( ::oModel:hBuffer, "serie",    ::oContadoresModel:getDocumentSerie( ::cName ) )
   
   hset( ::oModel:hBuffer, "numero",   ::oContadoresModel:getDocumentCounter( ::cName ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clientesSettedHelpText() CLASS FacturasClientesController

   ::clientSetTarifa()

   ::clientSetDescuentos()

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

   SQLFacturasClientesDescuentosModel():insertDescuentosWhereClienteUuid()

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

