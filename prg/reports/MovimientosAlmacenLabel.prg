#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLabelReport FROM SQLBaseReport

   DATA oMemList

   DATA nRowsToSkip

   DATA nLabelsToPrint

   DATA nLabelsPrinted

   METHOD New( oController )

   METHOD setRowSet( oRowSet )      INLINE ( ::oMemList := oRowSet )

   METHOD buildData() 

   METHOD skipper()

   METHOD goTop()

   METHOD fieldGet( cField )

   METHOD calculateRowsToSkip()

   METHOD resetLabelsToPrint()      INLINE ( ::nLabelsPrinted := 1,;
                                             ::nLabelsToPrint := ::oMemList:fieldGet( 'total_unidades' ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oEvents:set( "loadedFromString", {|| ::calculateRowsToSkip() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildData() 

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet( "Lineas de movimientos de almacén",;
                                 MovimientosAlmacenLineasRepository():getSerializedColumnsSentenceToLabels(),;
                                 {|| ::goTop() },;
                                 {|| ::skipper() },;
                                 {|| ::oMemList:skip(-1) },;
                                 {|| ::oMemList:eof() },;
                                 {|cField| ::fieldGet( cField ) } )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD skipper()

   if ::nRowsToSkip > 0
      
      ::nRowsToSkip--

      RETURN ( 0 )

   end if 

   ::nLabelsPrinted++

   if ::nLabelsPrinted > ::nLabelsToPrint  

      ::oMemList:Skip( 1 )   

      ::resetLabelsToPrint()

   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD goTop()

   ::resetLabelsToPrint()

RETURN ( ::oMemList:goTop() )

//---------------------------------------------------------------------------//

METHOD fieldGet( cField )

   if ::nRowsToSkip > 0
      RETURN ( "" )
   end if 

RETURN ( ::oMemList:fieldGet( cField ) )

//---------------------------------------------------------------------------//

METHOD calculateRowsToSkip()

   local nHeight        := ::oFastReport:GetProperty( "MasterData", "Height" )
   local nColumns       := ::oFastReport:GetProperty( "MainPage", "Columns" )
   local nPaperHeight   := ::oFastReport:GetProperty( "MainPage", "PaperHeight" ) * fr01cm

   ::nRowsToSkip        := 0

   if !empty( nPaperHeight ) .and. !empty( nHeight ) .and. !empty( nColumns )

      ::nRowsToSkip     := ( ::oController:getColumnaInicio() - 1 ) * int( nPaperHeight / nHeight )
      ::nRowsToSkip     += ( ::oController:getFilaInicio() - 1 )

   end if 

RETURN NIL

//---------------------------------------------------------------------------//

