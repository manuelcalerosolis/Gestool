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

   ::oDireccionesController      := DireccionesController():New( self )
   ::oDireccionesController:oValidator:setDialog( ::oDialogView )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:oModel:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:oModel:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::DireccionesControllerLoadCurrentBuffer() } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::DireccionesControllerUpdateBuffer() } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::DireccionesControllerLoadedDuplicateCurrentBuffer() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::DireccionesControllerLoadedDuplicateBuffer() } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::DireccionesControllerDeleteBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//