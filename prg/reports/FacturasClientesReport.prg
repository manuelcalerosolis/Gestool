#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesReport FROM SQLBaseReport

   DATA oFacturasClientesRowSet

   DATA oLineasFacturasClientesRowSet

   METHOD buildRowSet() 

   METHOD freeRowSet()

   METHOD setUserDataSet()

   METHOD Synchronize() 

END CLASS

//---------------------------------------------------------------------------//

METHOD buildRowSet( uIds )

   DEFAULT uIds                     := ::getIds()

   ::oFacturasClientesRowSet        := SQLRowSet();   
                                          :New();
                                          :Build( FacturasClientesRepository():getSqlSentenceByIdOrLast( uIds ) )

   ::oLineasFacturasClientesRowSet  := SQLRowSet();   
                                          :New();
                                          :Build( FacturasClientesLineasRepository():getSqlSentenceWhereParentUuid( ::oFacturasClientesRowSet:fieldget( "uuid" ) ) )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD freeRowSet() 

   ::oFacturasClientesRowSet:free()
   
   ::oLineasFacturasClientesRowSet:free()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD setUserDataSet() 

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Facturas de clientes",;
                                    SQLMovimientosAlmacenModel():getSerializeColumns(),;
                                    {|| ::oFacturasClientesRowSet:gotop() },;
                                    {|| ::oFacturasClientesRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesRowSet:eof() },;
                                    {|cField| ::oFacturasClientesRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Líneas de facturas de clientes",;
                                    SQLMovimientosAlmacenLineasModel():getSerializeColumns(),;
                                    {|| ::oLineasFacturasClientesRowSet:gotop() },;
                                    {|| ::oLineasFacturasClientesRowSet:skip( 1 ) },;
                                    {|| ::oLineasFacturasClientesRowSet:skip( -1 ) },;
                                    {|| ::oLineasFacturasClientesRowSet:eof() },;
                                    {|cField| ::oLineasFacturasClientesRowSet:fieldGet( cField ) } )

   ::oFastReport:SetMasterDetail(   "Facturas de clientes",;
                                    "Líneas de facturas de clientes",;
                                    {|| ::synchronize() } )

   ::oFastReport:SetResyncPair(    "Facturas de clientes", "Líneas de facturas de clientes" )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Synchronize() 

   msgalert( ::oFacturasClientesRowSet:fieldget( "uuid" ), "uuid" )

RETURN NIL

//---------------------------------------------------------------------------//


