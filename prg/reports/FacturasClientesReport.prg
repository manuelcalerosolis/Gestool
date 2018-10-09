#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesReport FROM SQLBaseReport

   DATA oFacturasClientesRowSet

   DATA oFacturasClientesLineasRowSet
   
   DATA oFacturasClientesModel
   
   DATA oFacturasClientesLineasModel

   DATA hTotal

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()

   METHOD buidSentenceAndRowsetFacturasClientes( uIds )

   METHOD buidSentenceAndRowsetFacturasClientesLineas()

   METHOD buildRowSet() 

   METHOD freeRowSet()

   METHOD setUserDataSet()

   METHOD getFacturasClientesModel()         INLINE ( if( empty( ::oFacturasClientesModel ), ::oFacturasClientesModel := SQLFacturasClientesModel():New( self ), ), ::oFacturasClientesModel )

   METHOD getFacturasClientesLineasModel()   INLINE ( if( empty( ::oFacturasClientesLineasModel ), ::oFacturasClientesLineasModel := SQLFacturasClientesLineasModel():New( self ), ), ::oFacturasClientesLineasModel )

   METHOD getFacturasClientesRowSet()        INLINE ( if( empty( ::oFacturasClientesRowSet ), ::oFacturasClientesRowSet := SQLRowSet():New(), ), ::oFacturasClientesRowSet )

   METHOD getFacturasClientesLineasRowSet()  INLINE ( if( empty( ::oFacturasClientesLineasRowSet ), ::oFacturasClientesLineasRowSet := SQLRowSet():New(), ), ::oFacturasClientesLineasRowSet )

   METHOD getTotal( uuid )                   INLINE ( ::hTotal  := ::getController():getRepository():getTotal( uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::getFacturasClientesModel()

   ::getFacturasClientesLineasModel()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oFacturasClientesModel )
      ::oFacturasClientesModel:End()
   end if

   if !empty( ::oFacturasClientesLineasModel )
      ::oFacturasClientesLineasModel:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowsetFacturasClientes( uuid )

   if empty( uuid )
      ::oFacturasClientesModel:setLimit( 1 )
   else
      ::oFacturasClientesModel:setGeneralWhere( "facturas_clientes.uuid = " + quoted( uuid ) )
   end if 

   ::oFacturasClientesRowSet:Build( ::oFacturasClientesModel:getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowsetFacturasClientesLineas( uuid )

   ::oFacturasClientesLineasModel:setGeneralWhere( "facturas_clientes_lineas.parent_uuid = " + quoted( uuid ) )
   
   ::oFacturasClientesLineasRowSet:Build( ::oFacturasClientesLineasModel:getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSet( uuid )

   ::getFacturasClientesRowSet()

   ::getFacturasClientesLineasRowSet()

   ::buidSentenceAndRowsetFacturasClientes( uuid )

   ::buidSentenceAndRowsetFacturasClientesLineas( uuid )

   ::getTotal( uuid )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD freeRowSet() 

   if !empty( ::oFacturasClientesRowSet )
      ::oFacturasClientesRowSet:End()
   end if 
   
   if !empty( ::oFacturasClientesLineasRowSet )
      ::oFacturasClientesLineasRowSet:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setUserDataSet() 

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Facturas de clientes",;
                                    SQLFacturasClientesModel():getSerializeColumnsSelect(),;
                                    {|| ::oFacturasClientesRowSet:gotop() },;
                                    {|| ::oFacturasClientesRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesRowSet:eof() },;
                                    {|cField| ::oFacturasClientesRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Líneas de facturas de clientes",;
                                    SQLFacturasClientesLineasModel():getSerializeColumnsSelect(),;
                                    {|| ::oFacturasClientesLineasRowSet:gotop() },;
                                    {|| ::oFacturasClientesLineasRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesLineasRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesLineasRowSet:eof() },;
                                    {|cField| ::oFacturasClientesLineasRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Totales de facturas de clientes",;
                                    serializeArray( hgetKeys( ::hTotal ), ";" ),;
                                    {|| nil },;
                                    {|| nil },;
                                    {|| nil },;
                                    {|| nil },;
                                    {|cField| hget( ::hTotal, cField ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

