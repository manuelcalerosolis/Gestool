#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesController FROM SQLNavigatorController

   DATA oClientesController

   DATA oSerieDocumentoComponent

   DATA oNumeroDocumentoComponent

   DATA oFormasPagoController

   DATA oRutasController

   DATA oAgentesController

   DATA oAlmacenesController

   DATA oContadoresModel

   DATA oLineasController

   METHOD New()

   METHOD End()

   METHOD loadedBlankBuffer() 

   METHOD insertedBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS FacturasClientesController

   ::Super:New()

   ::cTitle                      := "Facturas de clientes"

   ::cName                       := "facturas_clientes"
   
   ::lTransactional              := .t.

   ::hImage                      := {  "16" => "gc_document_text_user_16",;
                                       "32" => "gc_document_text_user_32",;
                                       "48" => "gc_document_text_user_48" }

   ::oModel                      := SQLFacturasClientesModel():New( self )

   ::oContadoresModel            := SQLContadoresModel():New( self )

   ::oDialogView                 := FacturasClientesView():New( self )

   ::oValidator                  := FacturasClientesValidator():New( self, ::oDialogView )

   ::oBrowseView                 := FacturasClientesBrowseView():New( self )

   ::oRepository                 := FacturasClientesRepository():New( self )

   ::oClientesController         := ClientesController():New( self )

   ::oNumeroDocumentoComponent   := NumeroDocumentoComponent():New( self )

   ::oSerieDocumentoComponent    := SerieDocumentoComponent():New( self )

   ::oFormasPagoController       := FormasPagosController():New( self )   
   ::oFormasPagoController:setView( ::oDialogView )

   ::oRutasController            := RutasController():New( self )
   ::oRutasController:setView( ::oDialogView )

   ::oAgentesController          := AgentesController():New( self )
   ::oAgentesController:setView( ::oDialogView )

   ::oAlmacenesController        := AlmacenesController():New( self )
   ::oAlmacenesController:setView( ::oDialogView )

   ::oLineasController           := FacturasClientesLineasController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',      {|| ::insertedBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesController

   ::oClientesController:End()

   ::oFormasPagoController:End()

   ::oRutasController:End()

   ::oAgentesController:End()

   ::oAlmacenesController:End()

   ::oLineasController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() 

   hset( ::oModel:hBuffer, "serie",    ::oContadoresModel:getDocumentSerie( ::cName ) )
   
   hset( ::oModel:hBuffer, "numero",   ::oContadoresModel:getDocumentCounter( ::cName ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertedBuffer() 

   // padr( ::oContadoresModel:insertDocumentCounter( ::cName ), 50 ) )

RETURN ( Self )

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
      :cHeader             := 'Uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

