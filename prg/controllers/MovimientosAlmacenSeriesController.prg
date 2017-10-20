#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenSeriesController FROM SQLBaseController

   METHOD New()

   METHOD Dialog()          INLINE ( ::oDialogView:Dialog() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Series"

   ::oModel                := SQLMovimientosAlmacenSeriesModel():New( self )

   //::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } ) 
   //::oModel:setEvent( 'buildingRowSet',      {|| ::buildingRowSet() } ) 

   ::oDialogView           := MovimientosAlmacenSeriesView():New( self )

   //::oValidator            := MovimientosAlmacenLineasValidator():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//