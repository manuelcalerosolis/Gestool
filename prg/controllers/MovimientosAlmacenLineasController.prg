#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasController FROM SQLBaseController

   METHOD New()

   METHOD loadedBlankBuffer()

   METHOD buildingRowSet()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Movimientos de almacen lineas"

   ::oModel                := SQLMovimientosAlmacenLineasModel():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'buildingRowSet',      {|| ::buildingRowSet() } ) 

   ::oDialogView           := MovimientosAlmacenLineasView():New( self )

   // ::oValidator            := MovimientosAlmacenLineasValidator():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   local uuid              := hget( ::getSenderController():oModel:hBuffer, "uuid" )

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildingRowSet()

   local uuid              := hget( ::getSenderController():oModel:hBuffer, "uuid" )

   if empty( uuid )
      RETURN ( Self )
   end if 

   ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )

RETURN ( Self )

//---------------------------------------------------------------------------//





