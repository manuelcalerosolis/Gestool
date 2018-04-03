#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenReport FROM SQLBaseReport

   DATA oMovimientosAlmacenRowSet

   DATA oLineasMovimientosAlmacenRowSet

   METHOD buildRowSet() 

   METHOD freeRowSet()

   METHOD setUserDataSet()

   METHOD Synchronize() 

END CLASS

//---------------------------------------------------------------------------//

METHOD buildRowSet( uIds )

   local oMovimientosAlmacenSelect        
   local oLineasMovimientosAlmacenSelect

   DEFAULT uIds                        := ::getIds()

   ::oMovimientosAlmacenRowSet         := SQLRowSet();   
                                             :New();
                                             :Build( MovimientosAlmacenRepository():getSqlSentenceByIdOrLast( uIds ) )

   ::oLineasMovimientosAlmacenRowSet   := SQLRowSet();   
                                             :New();
                                             :Build( MovimientosAlmacenLineasRepository():getSqlSentenceWhereParentUuid( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ) ) )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD freeRowSet() 

   ::oMovimientosAlmacenRowSet:free()
   
   ::oLineasMovimientosAlmacenRowSet:free()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD setUserDataSet() 

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Movimientos de almacén",;
                                    SQLMovimientosAlmacenModel():getSerializeColumns(),;
                                    {|| ::oMovimientosAlmacenRowSet:gotop() },;
                                    {|| ::oMovimientosAlmacenRowSet:skip(1) },;
                                    {|| ::oMovimientosAlmacenRowSet:skip(-1) },;
                                    {|| ::oMovimientosAlmacenRowSet:eof() },;
                                    {|cField| ::oMovimientosAlmacenRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Lineas de movimientos de almacén",;
                                    SQLMovimientosAlmacenLineasModel():getSerializeColumns(),;
                                    {|| ::oLineasMovimientosAlmacenRowSet:gotop() },;
                                    {|| ::oLineasMovimientosAlmacenRowSet:skip(1) },;
                                    {|| ::oLineasMovimientosAlmacenRowSet:skip(-1) },;
                                    {|| ::oLineasMovimientosAlmacenRowSet:eof() },;
                                    {|cField| ::oLineasMovimientosAlmacenRowSet:fieldGet( cField ) } )

   ::oFastReport:SetMasterDetail(   "Movimientos de almacén",;
                                    "Lineas de movimientos de almacén",;
                                    {|| ::synchronize() } )

   ::oFastReport:SetResyncPair(    "Movimientos de almacén", "Lineas de movimientos de almacén" )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Synchronize() 

   msgalert( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ), "uuid" )

RETURN NIL

//---------------------------------------------------------------------------//


