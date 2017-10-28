#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenReport FROM SQLBaseReport

   DATA oMovimientosAlmacenRowSet

   DATA oLineasMovimientosAlmacenRowSet

   METHOD buildData() 

   METHOD freeData()

   METHOD Synchronize() 

END CLASS

//---------------------------------------------------------------------------//

METHOD buildData() 

   local cSql
   local oMovimientosAlmacenSelect        
   local oLineasMovimientosAlmacenSelect  

   cSql     := "SELECT * FROM " + SQLMovimientosAlmacenModel():getTableName() + " "  
   if empty( ::getId() )
      cSql  += "ORDER BY id DESC LIMIT 1"
   else
      cSql  += "WHERE id = " + ::getId()
   end if 

   msgalert( cSql, "cSql" )

   oMovimientosAlmacenSelect           := getSqlDataBase():query( cSql )
   ::oMovimientosAlmacenRowSet         := oMovimientosAlmacenSelect:fetchRowSet()

   oLineasMovimientosAlmacenSelect     := getSqlDataBase():query( "SELECT * FROM " + SQLMovimientosAlmacenLineasModel():getTableName() + " WHERE parent_uuid = " + quoted( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ) ) )      
   ::oLineasMovimientosAlmacenRowSet   := oLineasMovimientosAlmacenSelect:fetchRowSet()

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

METHOD freeData() 

   ::oMovimientosAlmacenRowSet:free()
   
   ::oLineasMovimientosAlmacenRowSet:free()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Synchronize() 

   msgalert( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ), "uuid" )

RETURN NIL

//---------------------------------------------------------------------------//


