#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLabel FROM SQLBaseReport

   DATA oMovimientosAlmacenRowSet

   DATA oLineasMovimientosAlmacenRowSet

   DATA cCurrentCode

   DATA nLabelsToPrint

   DATA nLabelsPrinted

   METHOD setRowSet( oRowSet )         INLINE ( ::oLineasMovimientosAlmacenRowSet := oRowSet )

   METHOD buildData() 

   METHOD freeData()

   METHOD Synchronize() 

   METHOD getSerializeColumns()

   METHOD skipper()

   METHOD gotop()

END CLASS

//---------------------------------------------------------------------------//

METHOD getSerializeColumns()

   local nField 
   local cSerializeColumns    := ""

   for nField := 1 to ::oLineasMovimientosAlmacenRowSet:fieldCount()
      cSerializeColumns       += ::oLineasMovimientosAlmacenRowSet:fieldName( nField ) + ", " 
   next

   msgalert( cSerializeColumns, "cSerializeColumns" )

RETURN ( cSerializeColumns )

//---------------------------------------------------------------------------//

METHOD buildData() 

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet( "Lineas de movimientos de almacén",;
                                 MovimientosAlmacenLineasRepository():getSerializedColumnsSentenceToLabels(),;
                                 {|| ::gotop() },;
                                 {|| ::skipper() },;
                                 {|| ::oLineasMovimientosAlmacenRowSet:skip(-1) },;
                                 {|| ::oLineasMovimientosAlmacenRowSet:eof() },;
                                 {|cField| ::oLineasMovimientosAlmacenRowSet:fieldGet( cField ) } )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD skipper()

   msgalert( "skipper" )

   ::nLabelsPrinted++

   msgalert( ::nLabelsPrinted, "nLabelsPrinted skipper" )

   msgalert( ::nLabelsToPrint, "nLabelsToPrint skipper" )

   if ::nLabelsPrinted > ::nLabelsToPrint  

      ::oLineasMovimientosAlmacenRowSet:skip( 1 )   

      ::nLabelsPrinted     := 1

      ::cCurrentCode       := ::oLineasMovimientosAlmacenRowSet:fieldGet( 'codigo_articulo' )

      ::nLabelsToPrint     := ::oLineasMovimientosAlmacenRowSet:fieldGet( 'total_unidades' )

   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD gotop()

   msgalert( "gotop" )
   
   ::nLabelsPrinted     := 1

   ::cCurrentCode       := ::oLineasMovimientosAlmacenRowSet:fieldGet( 'codigo_articulo' )

   ::nLabelsToPrint     := ::oLineasMovimientosAlmacenRowSet:fieldGet( 'total_unidades' )

   msgalert( ::cCurrentCode, "cCurrentCode" )

   msgalert( ::nLabelsToPrint, "nLabelsToPrint" )

RETURN ( ::oLineasMovimientosAlmacenRowSet:gotop() )

//---------------------------------------------------------------------------//

METHOD freeData() 

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Synchronize() 

   //msgalert( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ), "uuid" )

RETURN NIL

//---------------------------------------------------------------------------//


