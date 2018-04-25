#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ClientesController

   ::Super:New()

   ::cTitle                      := "Clientes"

   ::cName                       := "clientes"

   ::hImage                      := {  "16" => "gc_user_16",;
                                       "32" => "gc_user_32",;
                                       "48" => "gc_user2_48" }

   ::oModel                      := SQLClientesModel():New( self )

   ::oDialogView                 := ClientesView():New( self )

   ::oValidator                  := ClientesValidator():New( self, ::oDialogView )

   ::oAgentesController          := AgentesController():New()

   ::oDireccionesController      := DireccionesController():New( self )
   ::oDireccionesController:oValidator:setDialog( ::oDialogView )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//