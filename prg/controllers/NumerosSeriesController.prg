#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS NumerosSeriesController FROM SQLBaseController

   DATA nTotalUnidades
   DATA cPreFix
   DATA oSerIni
   DATA nSerIni
   DATA oSerFin
   DATA nSerFin
   DATA oNumGen
   DATA nNumGen

   METHOD New()

   METHOD Dialog()          INLINE ( ::oDialogView:Dialog() )

   METHOD GenerarSeries()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Series"

   ::oModel                := SQLNumerosSeriesModel():New( self )

   //::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } ) 
   //::oModel:setEvent( 'buildingRowSet',      {|| ::buildingRowSet() } ) 

   ::oDialogView           := NumerosSeriesView():New( self )

   //::oValidator            := MovimientosAlmacenLineasValidator():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GenerarSeries()

   MsgInfo( "GenerarSeries" )

RETURN ( Self )

//---------------------------------------------------------------------------//